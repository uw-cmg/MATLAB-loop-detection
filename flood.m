function [edge, group1] = flood(subim1)
% flood function implements the watershed flood algorithm for extracting
% edge of loops in a croped image.
% inputs
% subim1: cropped image containing one elliptical loop
% outputs
% edge: black-white image with white dot indicating the edge
% group1: inner region of the loop

% adjust the contrast of the image
subim1 = imadjust(subim1);
% invert the image
subim = max(subim1(:)) - subim1;
[row, col] = size(subim);

% group1: inner region of the image
group1 = false(row,col);
centroid = round(weightedCentroid(subim));
if sum(isnan(centroid))
    centroid = round(centroidFind(subim1));
end
group1(centroid(1), centroid(2)) = 1;
min_size = round((row+col)/10);
se = strel('disk',min_size);
group1 = imdilate(group1,se);


%group2 = false(row,col,'gpuArray');
group2 = false(row,col);

group2(1,:)=1;
group2(row,:)=1;
group2(:,1)=1;
group2(:,col)=1;

% group2(1,1)=1;
% group2(1,col)=1;
% group2(row,col)=1;
% group2(row,1)=1;
% group2(centroid(1),1)=1;
% group2(centroid(1),col)=1;
% group2(1,centroid(2))=1;
% group2(row,centroid(2))=1;

subim(group1==1)=1;
subim(group2==1)=1;
strcut = strel('square',3);

bar = 1;
% to plot gif
% figure;
% imshow(subim1);
% h = figure;
% filename = 'flood.gif';
% gif plot end
%
% gradually increase the water level
while bar <= max(subim(:))
% % for debug
%     delay=0.01;
%     subplot(2,2,1);
%     imagesc(group1);
%     subplot(2,2,2);
%     imagesc(group2);
%     drawnow;
%     frame = getframe(h);
%     im = frame2im(frame);
%     [imind,cm]=rgb2ind(im,256);
%     % Write to the GIF File 
%     if bar == 1 
%         imwrite(imind,cm,filename,'gif', 'Loopcount',inf,'DelayTime', delay); 
%     elseif (rem(bar,4)==1)
%         imwrite(imind,cm,filename,'gif','WriteMode','append'); 
%     end
%     
%     pause(0.02)
%
    flooded = subim<bar;
    in = imdilate(group1,strcut);
    out = imdilate(group2,strcut);
    bound = in & out;
    true_flood = flooded & (~bound);
    inew = true_flood & in;
    onew = true_flood & out;
    temp1 = group1 | inew;
    temp2 = group2 | onew;
    % keep flooding until the region don't expand
    while (~isequal(temp1,group1) || ~isequal(temp2,group2))
        group1 = temp1;
        group2 = temp2;
        in = imdilate(group1,strcut);
        out = imdilate(group2,strcut);
        bound = in & out;
        true_flood = flooded & (~bound);
        inew = true_flood & in;
        onew = true_flood & out;
        temp1 = group1 | inew;
        temp2 = group2 | onew;
    end
    bar = bar + 1;
end
edge = ~(group1 | group2);
group1 = 1-group2;
end

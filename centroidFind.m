%determine the centroid position
function centroid = centroidFind(subim2)
% This function find the centroid position of a image 
% inputs:
% subim2: cropped image
% outputs:
% centroid: coordinates of the centroid point

subim2b = max(subim2(:)) - subim2;

p=FastPeakFind(subim2b);
px = p(1:2:end);
py = p(2:2:end);
centroid=[mean(py), mean(px)];


% figure
% imagesc(subim2b); hold on;
% plot(px,py,'r+')
% plot(centroid(1), centroid(2),'b*')
% hold off;

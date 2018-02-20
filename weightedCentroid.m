function centroid = weightedCentroid(subim)
% This function find the centroid position of a image 
% inputs:
% subim: cropped image
% outputs:
% centroid: coordinates of the centroid point

subimb = invert(subim);
%subimbw = invert(imbinarize(subim));
%stats = regionprops(subimbw,subimb,'Area','WeightedCentroid');
stats = regionprops(logical(subimb),subimb,'Area','WeightedCentroid');
[~,index] = max([stats.Area]);
if(size(index,1)==0)
    [nrows,ncols]=size(subim);
    centroid = [round(nrows/2),round(ncols/2)];
else
    centroid = [stats(index).WeightedCentroid(2),stats(index).WeightedCentroid(1)];
end
% figure;
% imagesc(subim); hold on;
% plot(centroid(1), centroid(2),'b*')
% hold off;

% calculate ellipse fitting score
function result = ellipseFitting(p, nrows, ncols)
% This function fits an ellipse and return the confidence score of being an
% ellipse.
% inputs:
% p: an array of points 
% nrows: number of rows of the image
% ncolds: number of columns of the images
% outputs:
% result: the fitted ellipse shape information and corresponding confidence
% score.

tempIm = false(nrows,ncols);
for i = 1:size(p,1)
    tempIm(p(i,1),p(i,2))=1;
end
fitscore = ellipseDetection(tempIm);
result = [fitscore(:,3), fitscore(:,4), fitscore(:,5)*pi/180, fitscore(:,1),...
    fitscore(:,2), fitscore(:,6)];
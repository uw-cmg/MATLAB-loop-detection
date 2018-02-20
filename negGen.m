function negIm = negGen(imIn, trueboxes)
% generate negative image by making patches on the positive image
% inputs
% imIn: input positive image with loops
% trueboxes: manually labeled bounding boxes
% outputs
% negIm: negative image generated

[nrows, ncols] = size(imIn);

for index = 1:size(trueboxes,1)
    rec = trueboxes(index,:);
    [x1, y1, len, lon] = deal(rec(1),rec(2),rec(3),rec(4));
    lon1 = round(lon/2);
    lon2 = lon-lon1;
    len1 = round(len/2);
    len2 = len-len1;
    p1y = min(y1+lon+lon1,nrows);
    p1x = min(x1+len+len1,ncols);
    p2y = max(y1-lon2,1);
    p2x = max(x1-len2,1);
    
    patch1 = imIn(p1y-lon1+1:p1y,p1x-len1+1:p1x);
    patch2 = imIn(p1y-lon1+1:p1y,p2x:p2x+len2-1);
    patch3 = imIn(p2y:p2y+lon2-1,p1x-len1+1:p1x);
    patch4 = imIn(p2y:p2y+lon2-1,p2x:p2x+len2-1);
    try
        imIn(y1:y1+lon-1,x1:x1+len-1) = [patch1,patch2;patch3,patch4];
    catch 
        a = 1;
    end
end
negIm = imIn;
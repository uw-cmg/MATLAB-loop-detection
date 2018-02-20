function [subim, rec] = crop(im, rec, option)
% This function crops an image to subimsge contained one defect by the 
% bounding box given
% inputs: 
% im: image
% rec: bounding box
% option: if "expand", then expand the rectangle to include more boundary
% area
% outputs:
% subim: cropped image
% rec: the sub image coordinates


% crop image 
if (nargin == 3 && option == "expand")
    rec = expand(rec, size(im,1), size(im,2));
end
subim = im(rec(2):rec(2)+rec(4),rec(1):rec(1)+rec(3));
% expand the bounding box

function extBox = expand(box,nrows, ncols)
padx = min(7, round(0.15*box(3)));
pady = min(7, round(0.15*box(4)));
newx = max(1, box(1)-padx);
newy = max(1, box(2)-pady);
otherx = min(ncols, box(1)+box(3)+padx);
othery = min(nrows, box(2)+box(4)+pady);
newwidth = otherx-newx;
newhight = othery-newy;
extBox = [newx, newy, newwidth, newhight];
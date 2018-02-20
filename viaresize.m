% change size 
function [rimg,rboxes]=viaresize(img,trueboxes,steps, low, high)
% change the size of the image and get the new bounding boxes for the
% resized image
% inputs
% img: image matrix
% trueboxes: original bounding boxes
% steps: number of steps for resize
% low: minimum ratio for resize
% high: maximum ratio for resize
for step = 0:steps
    ratio = low+(high-low)*step/steps;
    if (ratio == 1)
        continue;
    end
    rimg = imresize(img,ratio);
    rboxes = round(trueboxes*ratio);
%     showbbox(img,trueboxes);
%     showbbox(rimg,rboxes);
end

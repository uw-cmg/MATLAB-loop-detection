function [imagenames, positions]=readLabel(fullname,imagefolder)
% This function is similar to readData() except the output it returns.
% This function will output a cell array of imagenames and a cell array of
% bounding boxes. 
% inputs:
% fullname: file name of the txt file that has the bounding boxes.
% imagefolder: folder that contains the corresponding image
% outputs:
% imagenames: cell array of image filename
% bboxes: cell array of all the bounding boxes in the that image

trueboxes = dlmread(fullname);
positions = num2cell(trueboxes,2);
imagename = getImageName(fullname,imagefolder);
imagenames = cell(size(trueboxes,1),1);
[imagenames{:}]=deal(imagename);
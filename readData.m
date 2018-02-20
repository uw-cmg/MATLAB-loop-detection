function [imagename, bboxes] = readData(fullname, imagefolder)
% This function read a single txt file and return corresponding image name
% and the bounding boxes in the txt file
% inputs:
% fullname: file name of the txt file that has the bounding boxes.
% imagefolder: folder that contains the corresponding image
% outputs:
% imagename: image filename
% bboxes: all the bounding boxes in the that image

%

bboxes = dlmread(fullname);
imagename = getImageName(fullname,imagefolder);


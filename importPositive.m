function positiveInstances = importPositive(folder, imageFolder)
% This function reads all labeling txt files in one given folder and
% returns the table datastructure that can be read by
% traincascadeobjectdetector() to train the detector.
% inputs: 
% folder: folder name that has all the txt files as positive labeling
% imageFolder; image folder name that has all the corrsponding images
% outputs:
% positiveInstances: A table with two fields: imageFilename and bounding
% boxes


% loop every file in the folder
files = dir([folder,'/*.txt']);
value1 = {};
value2 = {};
for file = files'
    filename = file.name;
    fullname = fullfile(folder,filename);
    [imagename, bboxes] = readData(fullname,imageFolder);
    value1 = [value1;imagename];
    value2 = [value2;bboxes];
end
positiveInstances = table(value1, value2,'VariableNames',{'imageFilename' 'objectBoundingBoxes'});

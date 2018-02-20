function positiveInstances = genPosIns()
% old function, not used any more;
% This was originally used to read in saved matrix with image names and 
% bounding boxes.
% 
positive = load('PositiveManual.mat');
data = positive.labelingSession.ImageSet.ImageStruct;
field1 = 'imageFilename';
field2 = 'objectBoundingBoxes';
imNum = numel(data);
totNum = 0;
for index = 1: imNum
    totNum = totNum + size(data(index).objectBoundingBoxes,1);
end
value1 = cell(1,totNum);
value2 = cell(1,totNum);
num = 0;
for imageindex = 1:numel(data)
    imagename = data(imageindex).imageFilename;
    subrec = data(imageindex).objectBoundingBoxes;
    for recindex = 1:size(subrec,1)
        num = num + 1;
        value1{num} = imagename;
        value2{num} = subrec(recindex,:);
    end
end
positiveInstances = struct(field1, value1, field2, value2);
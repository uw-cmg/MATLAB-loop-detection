% This script parses excel file into txt file to save read and write time
% and save space
% The txt file only contains the bounding boxes information which is the coordinates, width, high.

% change the directory name is needed
files = dir('trainingset/*.xls');
index=1;
for file = files'
    filename = file.name;
    fullname = fullfile('trainingset',filename);
    imagename = getImageName(fullname);
    
    [~, positions] = getPos(fullname);
    truebox = cell2mat(positions);
    filename = ['tight_dataset/',imagename(10:end-4),'.txt'];
    dlmwrite(filename,truebox,'delimiter',' ');
end
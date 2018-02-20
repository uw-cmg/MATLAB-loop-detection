% This script is a helper script for checking if all the labeling is correct
% This script show all the images with labeled loops on them.
% This script is usually used for debuging.

% usage: check every excel file in the folder
% change the directory name if needed
files = dir('backup_excel/*.xls');
index = 0;
for file = files'
    fullname = fullfile('backup_excel',file.name);
    [imagenames, positions, XM, YM] = getPos(fullname);
    imname = imagenames{1};
    img = imread(imname);
    trueboxes = cell2mat(positions);
    trueImg = insertObjectAnnotation(img,'rectangle',trueboxes, '', 'LineWidth',3);
    figure;
    imshow(trueImg);
end
%%
% usage: check every txt file in the folder
% change the directory name if needed
files = dir('tight_dataset/*.txt');
% index = 0;
figure;
for file = files'
    %%
    fullname = fullfile('tight_dataset',file.name);
    imagefolder = 'positive';
    [imagenames, positions]=readLabel(fullname,imagefolder);
    imname = imagenames{1};
    img = imread(imname);
    trueboxes = cell2mat(positions);
    trueImg = insertObjectAnnotation(img,'rectangle',trueboxes, '', 'LineWidth',3);
    imshow(trueImg);
    pause(2)
end
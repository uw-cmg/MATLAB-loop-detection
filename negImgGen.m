% This script generates negative images by croping positive region from 
% position images

% The script works in the way as following:
% read in the human labeled files and get corresponding bounding boxes. 
% Then the scripts calls negGen() function to crop the boundign boxes out
% from the positive images

% loop every file in the folder
files = dir('training_dataset/*.txt');
parfor fileID = 1:numel(files)
    filename = files(fileID).name;
    fullname = fullfile('training_dataset',filename);
    imagefolder='positive';
    [imagenames, positions] = readLabel(fullname,imagefolder);
    trueboxes = cell2mat(positions);
    image_name = imagenames{1};
    img = imread(image_name);

    negIm = negGen(img, trueboxes);
    imname = ['training_negative_set/neg_', filename(1:end-4),'.jpg'];
    imwrite(negIm,imname,'jpg');
end
% This script is used to prepare the a sample from the the total dataset 
% for the CNN training
% Not used any more because a smaller sample set is not good compared to
% large dataset
% please discard it.

%% random sample data
folder = 'test_loops_new';
images = dir([folder,'\*.jpg']);
%%
numImgs = size(images,1);
sample_ratio = 0.01;
testingset=zeros(64,64,3,numImgs);
parfor fileID = 1:numImgs
    imagename = images(fileID).name;
    filename = fullfile(images(fileID).folder,imagename);
    I = imread(filename);

    % Some images may be grayscale. Replicate the image 3 times to
    % create an RGB image.
    if ~ismatrix(I)
        I = rgb2gray(I);
    end
    I2 = imadjust(I);
    I3 = imgaussfilt(I,2);
    I = cat(3,I,I2,I3);

    % Resize the image as required for the CNN.
    Iout = imresize(I, [64 64]);
    testingset(:,:,:,fileID) = Iout;
end
%%
[sampleSet,idx] = datasample(testingset,round(sample_ratio*numImgs),4,'Replace',false);
for i = 1:size(sampleSet,4)
    imagename = ['test_loops_resize\',num2str(i),'.jpg'];
    imwrite(uint8(sampleSet(:,:,:,i)), imagename);
end
%%
%% random sample data
negfolder = 'test_nonloop_new';
negimages = dir([negfolder,'\*.jpg']);
%%
numImgs = size(negimages,1);
sample_ratio = 0.01;
negtestingset=zeros(64,64,3,numImgs);
parfor fileID = 1:numImgs
    imagename = negimages(fileID).name;
    filename = fullfile(negimages(fileID).folder,imagename);
     I = imread(filename);

    % Some images may be grayscale. Replicate the image 3 times to
    % create an RGB image.
    if ~ismatrix(I)
        I = rgb2gray(I);
    end
    I2 = imadjust(I);
    I3 = imgaussfilt(I,2);
    I = cat(3,I,I2,I3);

    % Resize the image as required for the CNN.
    Iout = imresize(I, [64 64]);
    negtestingset(:,:,:,fileID) = Iout;
end
%%
[negsampleSet,negidx] = datasample(negtestingset,round(sample_ratio*numImgs),4,'Replace',false);

for i = 1:size(negsampleSet,4)
    imagename = ['nonloop_resize\',num2str(i),'.jpg'];
    imwrite(uint8(negsampleSet(:,:,:,i)), imagename);
end
%%

cropimages_new = cat(4,testingset,negtestingset);
cropimglabels_new = cell(size(cropimages_new,4),1);
cropimglabels_new(1:size(testingset,4))={'loop'};
cropimglabels_new(size(testingset,4)+1:end)={'nonloop'};
cropimglabels_new = categorical(cropimglabels_new);
randidx =  randperm(size(cropimglabels_new,1));
cropimages_new = cropimages_new(:,:,:,randidx);
cropimglabels_new = cropimglabels_new(randidx);


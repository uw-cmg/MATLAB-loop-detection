% This script loads a cascade object detector model and apply the model on
% the training image set to crop true detections as loop images and false
% detections as non-loop images.

%% Apply detector model on training images to generate loop/non-loop images
detectorname = 'loopDetector_v12_40_stage.xml';
folder = 'aug_training_files';
files = dir([folder, '/*.txt']);

parfor fileID = 1:numel(files)
    filename = files(fileID).name;
    fullname = fullfile(folder,filename);
    imagefolder='aug_training_positive';
    [imagenames, positions] = readLabel(fullname,imagefolder);
    truebox = cell2mat(positions);
    image_name = imagenames{1};
    img = imread(image_name);
    
    boxes = testDetector(img,detectorname);
    [PredTrue, PredFalse, DetectedBox, NotDetectedBox] = compareBbox(truebox, boxes);
    for i = 1:size(PredTrue,1)
        subim = crop(img, PredTrue(i,:),"expand");
        imagename = ['loops_notsogood\', image_name(23:end-4),'_pos_no',num2str(i),'.jpg'];
        imwrite(subim, imagename);
    end
%     for i = 1:size(NotDetectedBox,1)
%         subim = crop(img, NotDetectedBox(i,:),"expand");
%         imagename = ['loops\', image_name(23:end-4),'_no',num2str(i+size(PredTrue,1)),'.jpg'];
%         imwrite(subim, imagename);
%     end      
    for i =1:size(PredFalse,1)
        subim = crop(img, PredFalse(i,:),"expand");
        imagename = ['nonloop_notsogood\', image_name(23:end-4),'_neg_no',num2str(i),'.jpg'];
        imwrite(subim, imagename);
    end
end

%%
% This script can be also used to apply cascade object detector on the test
% set to generate test dataset for the CNN classifier.
%% Apply detector model on testing images to generate loop/non-loop images
detectorname = 'loopDetector_v12_40_stage.xml';
folder = 'testingset';
files = dir([folder, '/*.xls']);

parfor fileID = 1:numel(files)
    filename = files(fileID).name;
    fullname = fullfile(folder,filename);
%     imagefolder='aug_training_positive';
%     [imagenames, positions] = readLabel(fullname,imagefolder);
    [imagenames, positions,~,~] = getPos(fullname,'positive');
    truebox = cell2mat(positions);
    image_name = imagenames{1};
    img = imread(image_name);
    
    boxes = testDetector(img,detectorname);
    [PredTrue, PredFalse, DetectedBox, NotDetectedBox] = compareBbox(truebox, boxes);
    for i = 1:size(PredTrue,1)
        subim = crop(img, PredTrue(i,:),"expand");
        imagename = ['test_loops_new\', image_name(10:end-4),'_pos_no',num2str(i),'.jpg'];
        imwrite(subim, imagename);
    end
%     for i = 1:size(NotDetectedBox,1)
%         subim = crop(img, NotDetectedBox(i,:),"expand");
%         imagename = ['test_loops\', image_name(10:end-4),'_no',num2str(i+size(PredTrue,1)),'.jpg'];
%         imwrite(subim, imagename);
%     end 
    for i =1:size(PredFalse,1)
        subim = crop(img, PredFalse(i,:),"expand");
        imagename = ['test_nonloop_new\', image_name(10:end-4),'_neg_no',num2str(i),'.jpg'];
        imwrite(subim, imagename);
    end
end

% %%
% %%
% Old code, reads the dataset and splits into train set and test set for
% CNN training.
% There are new version of this code in the readcropImages.m 
%
%%
% testingset = test_crop_set{1};
% negtestingset = test_crop_set{2};
% %%
% cropimages = cat(4,testingset,negtestingset);
% cropimglabels = cell(size(cropimages,4),1);
% cropimglabels(1:size(testingset,4))={'loop'};
% cropimglabels(size(testingset,4)+1:end)={'nonloop'};
% cropimglabels = categorical(cropimglabels);
% randidx =  randperm(size(cropimglabels,1));
% cropimages = cropimages(:,:,:,randidx);
% cropimglabels = cropimglabels(randidx);
% %%
% [trainidx, validx, testidx] = dividerand(size(cropimglabels,1),0.7,0,0.3);
% trainimgs = cropimages(:,:,:,trainidx);
% trainlbs = cropimglabels(trainidx);
% testimgs = cropimages(:,:,:,testidx);
% testlbs = cropimglabels(testidx);
% trainimgs = uint8(trainimgs);
% testimgs = uint8(testimgs);
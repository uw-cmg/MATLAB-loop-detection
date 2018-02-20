% This Script is used to train a CNN classifier, which contains code to
% read in dataset images, construct a CNN, train and test a CNN.
%
%
%% Step 1: read in loop image
folder = 'loops_notsogood';
%folder = 'loops';
images = dir([folder,'\*.jpg']);
%%
numImgs = size(images,1);
trainingset=zeros(64,64,3,numImgs);
parfor fileID = 1:numImgs
    imagename = images(fileID).name;
    filename = fullfile(images(fileID).folder,imagename);
     I = imread(filename);

    % Some images may be rgb. Convert to grayscale image.
    if ~ismatrix(I)
        I = rgb2gray(I);
    end
    I2 = imadjust(I);
    I3 = imgaussfilt(I,2);
    I = cat(3,I,I2,I3);

    % Resize the image as required for the CNN.
    Iout = imresize(I, [64 64]);
    trainingset(:,:,:,fileID) = Iout;
end
%% Step 2: read in nonloop image
negfolder = 'nonloop_notsogood';
%negfolder = 'nonloop';
negimages = dir([negfolder,'\*.jpg']);
%%
numImgs = size(negimages,1);
negtrainingset=zeros(64,64,3,numImgs);
parfor fileID = 1:numImgs
    imagename = negimages(fileID).name;
    filename = fullfile(negimages(fileID).folder,imagename);
    I = imread(filename);

    % Some images may be rgb. Convert to grayscale image.
    if ~ismatrix(I)
        I = rgb2gray(I);
    end
    I2 = imadjust(I);
    I3 = imgaussfilt(I,2);
    I = cat(3,I,I2,I3);

    % Resize the image as required for the CNN.
    Iout = imresize(I, [64 64]);
    negtrainingset(:,:,:,fileID) = Iout;
end
%% Step 3: Add labels to loop and nonloop data
largeSet2 = cat(4,trainingset,negtrainingset);
largeSet2lbs = cell(size(largeSet2,4),1);
largeSet2lbs(1:size(trainingset,4))={'loop'};
largeSet2lbs(size(trainingset,4)+1:end)={'nonloop'};
largeSet2lbs = categorical(largeSet2lbs);
% ramdomize the dataset
randidx =  randperm(size(largeSet2lbs,1));
largeSet2 = largeSet2(:,:,:,randidx);
largeSet2lbs = largeSet2lbs(randidx);

% split the data into training set and testing set
% [trainidx, validx, testidx] = dividerand(size(clean_datasetLbs1,1),0.7,0,0.3);
% trainimgs = clean_dataset1(:,:,:,trainidx);
% trainlbs = clean_datasetLbs1(trainidx);
% testimgs = clean_dataset1(:,:,:,testidx);
% testlbs = clean_datasetLbs1(testidx);
% trainimgs = uint8(trainimgs);
% testimgs = uint8(testimgs);
%%
%%%% (Alternatively)load previously saved dataset to save time
% load largeSet2.mat
%%%% To obtain the test image set, change the directory and rerun the above
%%%% code.
% or simply load complete workspace saved
% load cnn_training.mat
%% Step 4: Display a few of the training images, resizing them for display.
numImageCategories = 2;
categories(largeSet2)
figure
thumbnails = uint8(largeSetAll(:,:,1,101:200));
thumbnails = imresize(thumbnails, [64 64]);
montage(thumbnails)

%% Step 5: Construct simple CNN strucuture
% Create the image input layer for 32x32x3 CIFAR-10 images
[height, width, numChannels, ~] = size(largeSet2);

imageSize = [height width numChannels];
inputLayer = imageInputLayer(imageSize)
%%
% Convolutional layer parameters
filterSize = [5 5];
%filterSize2 = [3 3];
numFilters = 64;

middleLayers = [

% The first convolutional layer has a bank of 32 5x5x3 filters. A
% symmetric padding of 2 pixels is added to ensure that image borders
% are included in the processing. This is important to avoid
% information at the borders being washed away too early in the
% network.
convolution2dLayer(filterSize, numFilters, 'Padding', 2)

% Note that the third dimension of the filter can be omitted because it
% is automatically deduced based on the connectivity of the network. In
% this case because this layer follows the image layer, the third
% dimension must be 3 to match the number of channels in the input
% image.

% Next add the ReLU layer:
reluLayer()
%crossChannelNormalizationLayer(3)
maxPooling2dLayer(3, 'Stride', 2)

% convolution2dLayer(filterSize2, numFilters*2, 'Padding', 1)
% reluLayer()

% convolution2dLayer(filterSize2, numFilters*3, 'Padding', 1)
% reluLayer()
% Follow it with a max pooling layer that has a 3x3 spatial pooling area
% and a stride of 2 pixels. This down-samples the data dimensions from
% 32x32 to 15x15.
% maxPooling2dLayer(2, 'Stride', 2)

% Repeat the 3 core layers to complete the middle of the network.
convolution2dLayer(filterSize, numFilters, 'Padding', 1)
reluLayer()
maxPooling2dLayer(3, 'Stride',2)

convolution2dLayer(filterSize, 2 * numFilters, 'Padding', 1)
reluLayer()
maxPooling2dLayer(3, 'Stride',2)

]
%%
finalLayers = [

% Add a fully connected layer with 64 output neurons. The output size of
% this layer will be an array with a length of 64.
fullyConnectedLayer(64)

% Add an ReLU non-linearity.
reluLayer()
%dropoutLayer(0.5)
% Add the last fully connected layer. At this point, the network must
% produce 10 signals that can be used to measure whether the input image
% belongs to one category or another. This measurement is made using the
% subsequent loss layers.
fullyConnectedLayer(numImageCategories)

% Add the softmax loss layer and classification layer. The final layers use
% the output of the fully connected layer to compute the categorical
% probability distribution over the image classes. During the training
% process, all the network weights are tuned to minimize the loss over this
% categorical distribution.
softmaxLayer
classificationLayer
]
%%
layers = [
    inputLayer
    middleLayers
    finalLayers
    ]
layers(2).Weights = 0.0001 * randn([filterSize numChannels numFilters]);
%%
functions = { ...
    @plotTrainingAccuracy, ...
    @(info) stopTrainingAtThreshold(info,95)};
% Set the network training options
opts = trainingOptions('sgdm', ...
    'Momentum', 0.9, ...
    'InitialLearnRate', 0.001, ...
    'LearnRateSchedule', 'piecewise', ...
    'LearnRateDropFactor', 0.05, ...
    'LearnRateDropPeriod', 8, ...
    'L2Regularization', 0.08, ...
    'MaxEpochs', 40, ...
    'MiniBatchSize', 128, ...
    'Verbose', true, ...
    'OutputFcn', functions,...
    'CheckpointPath','.\cnncheckpoint');
% A trained network is loaded from disk to save time when running the
% example. Set this flag to true to train the network.
%% Step 6: train a CNN
figure;
loopNet = trainNetwork(largeSet2, largeSet2lbs, layers, opts);
save('cnn_training.mat')
%%
% The following set is used for cleaning up the dataset.
% %% clean dataset
% result =classify(loopNet, largeSet2s);
% accuracy = sum(result == largeSet2slbs)/numel(largeSet2slbs)
% 
% %%
% falseAlarms = (result ~= largeSetLbs2) & (result == 'loop');
% figure
% thumbnails = uint8(largeSet2(:,:,1,falseAlarms));
% thumbnails = imresize(thumbnails, [64 64]);
% montage(thumbnails(:,:,:,1:100))
% %%
% for i = 1:sum(falseAlarms)
%     imagename = ['clean_loops\fa_',num2str(i),'.jpg'];
%     imwrite(uint8(thumbnails(:,:,:,i)), imagename);
% end
% %%
% falseNegative = (result ~= largeSetLbs2) & (result == 'nonloop');
% figure
% thumbnails = uint8(largeSet2(:,:,1,falseNegative));
% thumbnails = imresize(thumbnails, [64 64]);
% montage(thumbnails(:,:,:,1:100))
% %%
% for i = 1:sum(falseNegative)
%     imagename = ['clean_nonloop\fn_',num2str(i),'.jpg'];
%     imwrite(uint8(thumbnails(:,:,:,i)), imagename);
% end
% %% keep the correct ones
% trueClf = (result == largeSetLbs2);
% trueImgs = uint8(largeSet2(:,:,:,trueClf));
% trueLbs = largeSetLbs2(trueClf);
% %% re-read the debuged ones
% largeSet2s = cat(4, trueImgs, largeSet2);
% largeSet2slbs = cat(1, trueLbs, largeSet2lbs);
% 
% %%
% figure;
% loopNet = trainNetwork(largeSet1, largeSetLbs1, loopNet3D4.Layers, opts);
% save('cnn_training.mat')
% %%
% % Extract the first convolutional layer weights
% w = loopNet.Layers(2).Weights;
% 
% % rescale and resize the weights for better visualization
% w = mat2gray(w);
% 
% w = imresize(w, [100 100]);
% w = w(:,:,2,:);
% figure
% montage(w)
% %%
% lasttime = load('.\cnncheckpoint\convnet_checkpoint__9016__2017_08_15__13_37_59.mat');
% %%
% result2=classify(loopNet, cropimages_new);
% accuracy = sum(result2 == cropimglabels_new)/numel(cropimglabels_new)
% 
% %%
% falseAlarms = (result2 ~= cropimglabels_new) & (result2 == 'loop');
% figure
% thumbnails = uint8(cropimages_new(:,:,1,falseAlarms));
% thumbnails = imresize(thumbnails, [64 64]);
% montage(thumbnails)
% %%
% falseNegative = (result2 ~= cropimglabels_new) & (result2 == 'nonloop');
% figure
% thumbnails = uint8(cropimages_new(:,:,1,falseNegative));
% thumbnails = imresize(thumbnails, [64 64]);
% montage(thumbnails)

%% Step 7: Run the network on the test set.
[YTest,r] = classify(loopNet3D7, cropimages_new);

% Calculate the accuracy.
accuracy = sum(YTest == cropimglabels_new)/numel(cropimglabels_new)
%% Step 8: Plot the precision-recall curve
[X,Y,T] = perfcurve(cropimglabels_new,r(:,1),'loop','XCrit','prec'); 
%%
figure
plot(X,Y,'LineWidth',2)
xlabel('Precision')
ylabel('Recall')
title('Precision and Recall Curve for Loop Classification ')
% %%
% YTest = classify(loopNet3D3, largeSet1(:,:,:,1:45000));
% 
% % Calculate the accuracy.
% accuracy = sum(YTest == largeSetLbs1(1:45000))/numel(largeSetLbs1(1:45000))
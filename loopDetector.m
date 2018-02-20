%% Train a loop detector
% This script imports the positive instances (image name + bounding boxes)
% and negative images, and train a cascade object detector based on the
% dataset.

% v1.0 2016/12/07
% v2.0 2017/08/17

%%
% previous code, please discard
% positive = load('labelingSession1.mat');
%positiveInstances = positive.labelingSession.ImageSet.ImageStruct;
%positiveInstances = genPosIns();
% positiveInstances = importPositive('aug_training_files','aug_training_positive');
% negativeFolder = fullfile('aug_training_negative'); 

%% Step 1: load augmented database
positiveInstances = importPositive('aug_training_files','aug_training_positive');
negativeFolder = fullfile('aug_negative_images'); 
%% Step 2: train the model
% Train a cascade object detector using LBP features. 
trainCascadeObjectDetector('loopDetector_v13_45_stage.xml',positiveInstances,negativeFolder,...
    'FalseAlarmRate',0.3,'NumCascadeStages',45, 'TruePositiveRate', 0.997, ...
    'FeatureType', 'LBP');  

%%
% simple test code, not used now. The newer version is in the script called
% testSingleImg.m

% % Use the newly trained classifier to detect a stop sign in an image.
% detector = vision.CascadeObjectDetector('loopDetector_temp.xml');  
% 
% 
% %% Test the result
% 
% img = imread('Picture1.png'); 
% %%
% % Detect a stop sign.
% bbox = step(detector,img);
% %%
% % Insert bounding boxes and return marked image.
% detectedImg = insertObjectAnnotation(img,'rectangle',bbox,'','LineWidth',3);   
% %%
% % Display the detected stop sign.
% figure;
% imshow(detectedImg);
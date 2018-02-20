%% test on a single image
% This script can run the trained model on a single image and output the
% image with fitted ellipse on the image
%% read model and image
% uncomment the following statement if there is no cnn classifier in the
% workspace.
% load loopNet3D7.mat
detectorname = 'testingset/loopDetector_v13_40_stage.xml';
imagename = 'testImages/dalong3.jpg';
img = imread(imagename);
% detect image
rawboxes = testDetector(img,detectorname);
% screen and extract loop shape
[mlfboxes, loops] = mlScreen(img, rawboxes, loopNet3D7);
% show detected bounding box
% showbbox(img, mlfboxes);
% show fitted ellipse
figure;
imshow(img);
hold on;
ellipse(loops(:,1),loops(:,2),loops(:,3),loops(:,4),loops(:,5));
hold off;
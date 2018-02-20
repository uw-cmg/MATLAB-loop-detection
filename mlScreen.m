function [fboxes, loops] = mlScreen(img, boxes, loopNet)
% mlScreen uses machine learning to screen out bounding boxes produced by 
% cascade object detector. 
% inputs
% img: image matrix
% boxes: bounding boxes produceed by cascade object detector. size m*4,
% where m is the number of bounding boxes
% loopNet: a trained CNN classifier.
% outputs
% fboxes: screened bounding boxes, size n*4, where n is the number of
% screened bounding boxes
% loops: fitted ellipse loops. [major axis/2, minor axis/2, orientation, centroid_x, centroid_y]
% This function uses parallel process.

%% old code
% %write into temp test set
% header = ["counts score","unique counts score","standard deviation score", ...
%     "unique points ratio", "intensity ratio", "penalty ratio",...
%     "counts", "unique counts", "standard deviation", "mean intensity", ...
%     "counts intensity", "penalty","fit max score", "fit avg score", ...
%     "fit standard deviation", "label"];
% fileID = fopen('temp_test_images_dataset.csv','w');
% fprintf(fileID,'%s,%s,%s,%s,%s,%s, %s, %s,%s,%s,%s,%s,%s, %s, %s,%s\n',header);
% testmatrix=[];
% %end of old code
%% 
trainingset = zeros(64,64,3,size(boxes,1));
% loops=[];
for i = 1:size(boxes,1)
    [I, rec] = crop(img, boxes(i,:),"expand");
    
    if ~ismatrix(I)
        I = rgb2gray(I);
    end
    I2 = imadjust(I);
    I3 = imgaussfilt(I,2);
    I = cat(3,I,I2,I3);

    % Resize the image as required for the CNN.
    Iout = imresize(I, [64 64]);
    trainingset(:,:,:,i) = Iout;
    % old code if using tuned weights screening instead
%     [scores1,scores2, fitscores, fitloops] = screenScores(subim);
%     instance = [scores1,scores2,fitscores];
%     fitloops(4:5) = fitloops(4:5)+rec(1:2)-1;
%     loops = [loops; fitloops];
%     testmatrix = [testmatrix; instance];

end
% call CNN model to classify the bounding boxes
% result is the predicted loops using default threshold
% r2 is the confidence score given by the CNN model
% classify() is the built in function
[results, r2] = classify(loopNet, trainingset);

% set threshold to 0.2
fboxes = boxes(r2(:,1)>=0.2,:);
loops=zeros(size(fboxes,1),5);

% extract the shape information of the loop using flooding algorithm
% parfor i = 1:size(fboxes,1)
%     [I, rec] = crop(img, fboxes(i,:),"expand");
%     % call flood algorithm, to fit the loops
%     fitloops = foodfitting(I);
%     % uncomment this if using radial sweeping fitting instead
%     %[scores, ~, fitloops, ~] = screenScores(I,"fit");
%     fitloops(4:5) = fitloops(4:5)+rec(1:2)-1;
%     loops(i,:) = fitloops;
% end

%% old code using older version of screening method
% load clfnn2.mat
% scores = net(testmatrix');
% threshold = 0.25;
% 
% fboxes = boxes(scores>=threshold,:);
% fscores = scores(scores>=threshold);

    
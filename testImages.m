function [scores, majoraxis] = testImages(id, net, option)
% This function can test images in a specified folder 
% This function call the complete detection workflow: detection, screening
% and flooding, extraction, draw ellipses, and output the number of matched
% bounding boxes and mismatched bounding boxes for further calculation of
% precision and recall scores.
% inputs
% id: position of test image in the specified folder
% net: trained cnn classifier
% options: null or any value. If null, run test on small 6 image set. If
% any value, run test on complete 28 image set.
% outputs
% scores: number of matched bounding boxes and mismatched bouding boxes
% with the format of [standard true boxes that matched with computer labeled boxes,
% toal standard true boxes, computer labeled boxes matched with standard true boxes,
% computer, total computer labeled boxes]
% major axis: an array of all major axis producted by computer labeling

%% This section is used for individual image in the test set
% previously used for debugging
% not used any more
% 1. '0501_300kx_1nm_clhaadf3_0028_dis.xls';
% 2. '1ROI_100kx_4100CL_foil1.xls';
% 3. '200kV_500kx_p2nm_8cmCL_grain1_0004_n.xls';
% 4. '200kV_500kx_p2nm_8cmCL_grain1_0036.xls';
% 5. '200kV_500kx_p2nm_8cmCL_grain1_0056 - Copy.xls';
% 6. '200kV_500kx_p2nm_8cmCL_grain1_0090 - Copy.xls';
% 7. '200kV_500kx_p2nm_8cmCL_grain1_0135 - Copy.xls';
% 8. '200kV_500kx_p2nm_8cmCL_grain2_0034.xls';
% 9. '200kV_500kx_p2nm_8cmCL_grain2_0036.xls';
% 10. '200kV_500kx_p2nm_8cmCL_grain2_2_0008.xls';
% 11. '2501_300kx_1nm_clhaadf3_0042_dis.xls';
% 12. '2501_300kx_1nm_clhaadf3_0052_dis.xls';
% 13. 'K713_300kx_store4_grid1_0011_dis.xls';
% 14. 'K713_300kx_store4_grid1_0027_res.xls';
% 15. 'ROI10_100kx_4200CL_foil1.xls';
% 16. 'ROI4_100kx_4200CL_foil1.xls';
% 17. 'g1_backonzone_GBtowardmiddle_0001.xls';
% 18. 'g1_backonzone_GBtowardsfrom_0009.xls';
% 19. 'g2_midonzone_GBtowardsfront_0010.xls';
% 20. 'g2_midonzone_GBtowardsfront_0034.xls';
% 21. 'g2_midonzone_GBtowardsmmiddle_0009.xls';
% 22. 'grid1_roi1_500kx_0p5nm_haadf1_0013.xls';
% 23. 'grid1_roi1_500kx_0p5nm_haadf1_0025.xls';
% 24. 'grid1_roi2_500kx_0p5nm_haadf1_0035.xls';
% 25. 'grid1_roi2_500kx_0p5nm_haadf1_0061.xls';
% 26. 'leftgrain111neargb_bf.xls';
% 27. 'map1_70kx_onzap_CL4100.xls';
% 28. 'map8_70kx_onzap_CL4100.xls'
%% Read standard labeled files in the test folder
if (nargin > 2) 
    files = dir('testingset/*.xls');
    filename = files(id).name;
    fullname = fullfile('testingset',filename);
    [imagenames, positions, XM, YM, Major, Minor, Angle] = getPos(fullname,'positive');
else
    files = dir('standard_labels/*.xls');
    filename = files(id).name;
    fullname = fullfile('standard_labels',filename);
    [imagenames, positions, XM, YM, Major, Minor, Angle] = getPos(fullname,'survey');
end
%%  read image and standard true labeling
imname = imagenames{1};
trueboxes = cell2mat(positions);
img = imread(imname);
% showbbox(img,trueboxes);
% imshow(img)
%% call cascade object detector to obtain the detection results
detectorname = 'loopDetector_v13_40_stage.xml';
rawboxes = testDetector(img,detectorname);
%% Older version of screen the boxes using radial sweeping method
% fboxes=[];
% scores=[];
% fscores=[];
% dloops=[];
% threshold = 0.78;
% boxes=rawboxes;
% [nrows, ~] = size(boxes);
% for i = 1:nrows
%     box = boxes(i,:);
%     [subim, rec] = crop(img, box);
%     [score, fitloops] = screen(subim);
%     scores = [scores; score];
%     fitloops(4:5) = fitloops(4:5)+rec(1:2)-1;
%     dloops = [dloops; fitloops];
%     if (score>threshold)
%         fboxes=[fboxes;box];
%         fscores = [fscores;score];
%     end
% end
% fboxes = fboxes(filterOverlap(fboxes),:);
% fscores = fscores(filterOverlap(fboxes));
%% call CNN classifier to screen results
% in mlScreen function, flood algorithm is called to extract the shape
% information
[mlfboxes, loops] = mlScreen(img, rawboxes, net);
% figure;
% imshow(img);
% showbbox(img,rawboxes);
% showbbox(img,mlfboxes);
% evaluatescores = evaluate(trueboxes,rawboxes);
%% prepare the final output
% evaluatescores = evaluate(trueboxes,fboxes,img);
% disp(evaluatescores);
% % %% calculate true positive rate
[PredTrue, ~, DetectedBox, ~] = compareBbox(trueboxes, mlfboxes);
scores = [size(DetectedBox,1), size(trueboxes,1), size(PredTrue,1), size(mlfboxes,1)];
% evaluatescores = evaluate(trueboxes,mlfboxes,img);
majoraxis = loops(:,1)*2;
% disp(evaluatescores);
% %%
% scores(isnan(scores))=0;
% loops =dloops(scores>threshold,:);
% showbbox(img, mlfboxes);
%% plot the images with detected loops
% figure;
% imshow(img);
% hold on;
% ellipse(loops(:,1),loops(:,2),loops(:,3),loops(:,4),loops(:,5));
% hold off;
%% plot the images with loops labeled by human standard truth
% figure;
% imshow(img);
% hold on;
% ellipse(Major,Minor,pi*(180-Angle)/180,XM,YM);
% hold off;


end
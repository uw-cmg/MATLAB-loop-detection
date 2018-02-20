% This script is to test a single image given its labeling file name.
% It applies the cascade object detector on the image to detect the loop
% position and then calls the screening and extraction method to output the 
% detected result.
%% calculate confusion matrix
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
%%
files = dir('testingset/*.xls');
filename = files(28).name
%%
fullname = fullfile('backup_excel',filename);
%filename = '5401_300kx_1nm_clhaadf3_0020_dis.xls';
[imagenames, positions, XM, YM] = getPos(fullname,'positive');
imname = imagenames{1};
im = imread(imname);
trueboxes = cell2mat(positions);
img = imread(imname);
% showbbox(img,trueboxes);
% imshow(im)
%% read detected results
%detectorname = 'loopDetector_all_10_stage.xml';
detectorname = 'loopDetector_v12_40_stage.xml';
% generate imagename
filenamecrop = strsplit(fullname, {'\','/','.', '_dis.', '_res.','_111.'});
filenamecrop{1} = 'positive';
filenamecrop{end} = 'jpg';
imagename = strjoin(filenamecrop,{'/', '.'});
rawboxes = testDetector(img,detectorname);
% %% Screen the boxes
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
%%

% load loopnet.mat
mlfboxes = mlScreen(img, rawboxes, loopNet3D3);

%%
warning('off','images:initSize:adjustingMag')
% showbbox(img,trueboxes);
evaluatescores = evaluate(trueboxes,rawboxes,img);
disp(evaluatescores);
%% calculate true positive rate
% evaluatescores = evaluate(trueboxes,fboxes,img);
% disp(evaluatescores);
% % %% calculate true positive rate
evaluatescores = evaluate(trueboxes,mlfboxes,img);
disp(evaluatescores);
% %%
% scores(isnan(scores))=0;
% loops =dloops(scores>threshold,:);
% %showbbox(img,rawboxes,scores);
% figure;
% imshow(img);
% hold on;
% ellipse(loops(:,1),loops(:,2),loops(:,3),loops(:,4),loops(:,5));
% hold off;
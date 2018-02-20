function d2 = preprocess(subim)
d1 = medfilt2(subim,[3,3]);
filt = (fspecial('gaussian', 3,1));
d2=conv2(single(d1),filt,'same');
% figure;
% subplot(2,2,1);
% imagesc(d1);
% subplot(2,2,2);
% imagesc(d2);
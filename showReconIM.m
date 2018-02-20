% This script can plot out the bounding boxes of an image given its
% corresponding labeling filename.

%% plot Detected rectangles from instances
filename = 'excel2/K713_300kx_store4_grid1_0019_dis.xls';
[imagenames, positions, XM, YM] = getPos(filename);
imname = imagenames{1};
im = imread(imname);
figure;
imshow(im);
hold on;
totNum = numel(positions);
for index = 1:totNum
    rectangle('Position',positions{index},...
         'LineWidth',1,'LineStyle','-');
    plot(XM, YM, 'r+');
end
hold off;
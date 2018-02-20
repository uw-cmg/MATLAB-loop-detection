% convert tiff to jpg
folder = 'backup_negative';
files = dir([folder,'/*.bmp']);
index=1;
for fileID = 1:numel(files)
    imagename = files(fileID).name;
    fullname = fullfile(folder,imagename);
    img=imread(fullname);
    if (size(img,3)==3) 
        img = rgb2gray(img);
    end
    fulloutname = [folder,'bmpconvert',num2str(index),'.jpg'];
    imwrite(img, fulloutname);
    index = index + 1;
end

% generate imagename
function imagename=getImageName(fullname,imagefolder)
% This function convert the labeling file name into the corresponding
% imagename. *IMPORTANT* Please note that this function is used quite a lot 
% and it is suitable only for one layer of file directory, i.e.
% -- imagefolder/imagename -- labelfolder/labelfile.
% You can edit this function if you want to make it for multiple layers of
% file directory. But if you keep the function the way it is, pay attention 
% to the file directory and make sure
% that when you call this function, the image file is just under one layer
% of folder and the label file is just under one layer of folder.
% inputs:
% fullname: label file name with one layer of folder
% imagefolder; the folder that contains the corresponding image
% outputs:
% imagename: the corresponding image name


%filenamecrop = strsplit(fullname, {'/','.', '_dis.', '_res.','_111.'});
filenamecrop = strsplit(fullname, {'/','\','.txt','.xls', '_dis.', '_crop.txt' ,'_res.','_111.'});
imfolder = 'positive';
if (nargin==2)
    imfolder=imagefolder;
end
filenamecrop{1} = imfolder;
filenamecrop{end} = 'jpg';
imagename = strjoin(filenamecrop,{'/', '.'});

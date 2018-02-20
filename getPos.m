function [imagenames, positions, nXM, nYM, nMajor, nMinor, nAngle] = getPos(fullname,imagefolder)
% This function reads in the excel file and return a series of values about 
% the location, shape of the loops
% inputs
% fullname: full path to the excel file with labeling information
% imagefolder: corresponding image folder for the labeling files
% output:
% imagesnames: a cell array of imagenames for the corresponding excel
% file, actually all elements are the same image name.
% positions: a cell array of bounding boxes with the format of [x coordinate,
% y coordinate, width along x axis, height along y axis] 
% nXM: an array of centroid x coordinate position, not that useful, used mostly 
% for debuging.
% nYM: an array of centroid y coordinate position, not that useful, used mostly 
% for debuging.
% nMajor, nMinor, nAngle: similar with nXM, an array of major axis/minor
% axis/ orentiation angle of the loops.
% this function outputs imagenames and positions for use in the traning of
% cascade object detector, which is the required format in the input of
% traincascadeobjectdetector function.

delimiter = ',';
startRow = 2;

% Format string for each line of text:
%   column1: double (%f)
%	column2: double (%f)
%   column3: double (%f)
%	column4: double (%f)
%   column5: double (%f)
%	column6: double (%f)
%   column7: double (%f)
%	column8: double (%f)
%   column9: double (%f)
%	column10: double (%f)
%   column11: double (%f)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';

% Open the text file.
fileID = fopen(fullname,'r');

% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'HeaderLines' ,startRow-1, 'ReturnOnError', false);

% Close the text file.
fclose(fileID);

% Post processing for unimportable data.
% No unimportable data rules were applied during the import, so no post
% processing code is included. To generate code which works for
% unimportable data, select unimportable cells in a file and regenerate the
% script.

% Allocate imported array to column variable names
%VarName1 = dataArray{:, 1};
%Area = dataArray{:, 2};
%Mean = dataArray{:, 3};
%Min = dataArray{:, 4};
%Max = dataArray{:, 5};
XM = dataArray{:, 6};
YM = dataArray{:, 7};
Major = dataArray{:, 8};
Minor = dataArray{:, 9};
Angle = dataArray{:, 10};
%Length = dataArray{:, 11};

% for the older labeled files, there is no bounding box information in the
% excel files, so this part of code is to calcualte the boudning box from
% the major axis, minor axis and centroid positions of the loops.
pixres=1024/485.54;
XM=XM*pixres;
YM=YM*pixres;
Major = Major*pixres/2;
Minor = Minor*pixres/2;
xlength = round(2*sqrt((Major.*cosd(Angle)).^2 + (Minor.*sind(Angle)).^2));
ylength = round(2*sqrt((Major.*sind(Angle)).^2 + (Minor.*cosd(Angle)).^2));
%xlength = xlength+min(max(15, round(0.7*xlength)),35);
%ylength = ylength+min(max(15, round(0.7*ylength)),35);

% make the size of boudning boxes slightly larger to include more
% information.
xlength = xlength+min(max(5, round(0.3*xlength)),15);
ylength = ylength+min(max(5, round(0.3*ylength)),15);

x1 = round(XM - xlength/2);
y1 = round(YM - ylength/2);

% call getImageName function to generate the corresponding image names
imagename = getImageName(fullname,imagefolder);
% check rectangle boundary
x1 = max(x1,1);
y1 = max(y1,1);
im = imread(imagename);
[ylim, xlim, ~] = size(im);
xlength = min(x1+xlength,xlim)-x1;
ylength = min(y1+ylength,ylim)-y1;
 
% generate output cell
% select only open loops
% this part of code is for the older version of labeling files, where there
% are also black dots and dislocation lines labeled.
count = 0;
arraylength = numel(XM);
while (count <= arraylength-1 && XM(count+1) > 1)
    count = count + 1;
end

idx1 = xlength>8;
idx2 = ylength>8;
idx = idx1 & idx2;
idx(count+1:end)=0;

nXM = XM(idx);
nYM = YM(idx);
nMajor=Major(idx);
nMinor=Minor(idx);
nAngle=Angle(idx);


position = [x1, y1, xlength, ylength];
selpos = position(idx,:);
positions = num2cell(selpos,2);
count = numel(positions);
imagenames = cell(count,1);
[imagenames{:}]=deal(imagename);

% older code, please discard
% count = 0;
% for index = 1:numel(XM)
%     if(XM(index) == 0)
%         break;
%     end
%     if (xlength(index)<16 ||  ylength(index)<16)
%         continue;
%     end
%     count = count + 1;
% end
% imagenames = cell(count,1);
% positions = cell(count,1);
% count = 0;
% for index = 1:numel(XM)
%     if(XM(index) == 0)
%         break;
%     end
%     if (xlength(index)<16 ||  ylength(index)<16)
%         continue;
%     end
%     count = count + 1;
%     imagenames{count} = imagename;
%     positions{count} = [x1(index), y1(index), xlength(index), ylength(index)];
% end



function [scores, others, fitscores, fitloops] = screenScores(subim1,option)
% Old functions, not used any more;
% this function is an older version of screening method
% It implements the radial sweeping method and also combines flood fitting,
% elliptical hough transform and other scoring metrics
% inputs
% subim1: croped images with a single loop inside
% option: null or can be any value. If not null, then return fitted 
% elliptical shape, stored in fitscores variable only
% outputs
% scores: 1*n array with a serial of scores measured on the cropped image
% based on radial sweeping method
% others: other helper scoring metrics besides radial sweeping method
% fitscores: scores produced by elliptical hough fitting on the extracted
% local maximum points
% fitloops: loop shape produced by elliptical hough transform

global centroid;
global subim
subim = preprocess(invert(subim1));
centroid = round(weightedCentroid(subim1));
if sum(isnan(centroid))
    centroid = round(centroidFind(subim1));
end
steps = 360;
windowsize = 7;
p = sweep(steps);
counts = 0;
penaty=0;
[totalnums, ~] = size(p);
% This part can be optimized with matrix operation
% will be modified later if given more time
for i = 1:totalnums
    for j = 1:windowsize 
        right=i+j;
        if (right>totalnums)
            right=right-totalnums;
        end
        if (calDist(p(i,:),p(right,:))<2.5)
            counts = counts+1;
            break;
        end
    end
    right=i+1;
    if (right>totalnums)
            right=right-totalnums;
    end
    if (calDist(p(i,:),p(right,:))>10)
        penaty = penaty+1;
    end
end
stdscore = min(std2(subim1)/25,1);
unip = unique(p,'rows');
unicounts = size(unip,1);
uniratio=min(size(unip,1)*3/pi/(size(subim,1)+size(subim,2)),1);
intratio=0;
intensity=0;
% early stop
if (size(p,1)~=0)
    intensity=mean2(diag(subim(p(:,1),p(:,2))));
    intratio = min((intensity-mean2(subim))/20,1.2);
end

penatyratio=penaty;
if(unicounts ~=0)
    penatyratio = penaty/unicounts;
end
scores = [counts/steps,unicounts/steps,stdscore, uniratio, intratio, -penatyratio];
if (nargin > 1)
    others = 0;
    fitscore = ellipseFitting(p, size(subim,1), size(subim,2));
    fitscores = fitscore(1,1:5);
    fitloops = 0;
    return;
end
others = [counts, unicounts, std2(subim1), mean2(subim1), intensity, -penaty];
fitscore = ellipseFitting(p, size(subim,1), size(subim,2));
floodscore = foodfitting(subim1);
houghscore = fitscore(1,6)/counts;
if (isnan(houghscore))
    houghscore = 0;
end
pos_penalty = sqrt((floodscore(4)-fitscore(1,4))^2+(floodscore(5)-fitscore(1,5))^2);
pos_penalty = pos_penalty/max(size(subim));
axis_penalty = abs(fitscore(1,1)-floodscore(1))/floodscore(1) + ...
    abs(fitscore(1,2)-floodscore(2))/floodscore(2);
ori_penalty = abs(fitscore(1,3)-floodscore(3))/abs(floodscore(3));
fitscores = [houghscore, pos_penalty, axis_penalty, ori_penalty];
fitloops = [floodscore(1),floodscore(2),floodscore(3),floodscore(4),floodscore(5)];
% 
% 
% %difference between flood and hough transform
% 
% figure;
% subplot(1,2,1)
% imshow(subim1);
% hold on;
% ellipse(fitscore(1,1),fitscore(1,2),fitscore(1,3),fitscore(1,4),fitscore(1,5));
% hold off;
% subplot(1,2,2)
% imshow(subim1);
% hold on;
% ellipse(floodscore(1),floodscore(2),floodscore(3),floodscore(4),floodscore(5));
% hold off;

function distance = calDist(p1,p2)
distance = sqrt((p1(1)-p2(1))^2+(p1(2)-p2(2))^2);


function points = sweep(steps)
global centroid;
global subim;
global numRows;
global numCols;
[numRows,numCols] = size(subim);
points = [];
precision = 1;
%stepsize = 2*pi/steps;
for step = 0:steps-1
    theta = 0+2*pi*step/steps;
%for theta = 0:stepsize:2*pi
    incrc = precision*cos(theta);
    incrr = precision*sin(theta);
    maxpos=findmax(incrr, incrc);
    if (sum(maxpos ~= centroid))
        points = [points;maxpos];
    end
end



function maxpos = findmax(incrr, incrc)
global centroid;
global subim;
global numRows;
global numCols;

best=max([subim(centroid(1),centroid(2)),max(subim(1,:)),max(subim(numRows,:)),...
max(subim(:,numCols)), max(subim(:,1))]);
%best=mean2(subim);
bestloc = centroid;
pos=centroid;
pos(1) = pos(1)+incrr;
pos(2) = pos(2)+incrc;
row = round(pos(1));
col = round(pos(2));
while(row>0 && row<numRows && col >0 && col <numCols)
    if (subim(row,col)>best)
        bestloc = [row,col];
        best = subim(row,col);
    end
    pos(1) = pos(1)+incrr;
    pos(2) = pos(2)+incrc;
    row = round(pos(1));
    col = round(pos(2));
end
maxpos = bestloc;
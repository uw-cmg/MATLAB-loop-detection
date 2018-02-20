function [rimg,rboxes]=viarotate(img,trueboxes,angle)
% This function rotate positive image and corresponding bounding boxes and 
% return the rotated image and rotated bounding boxes
% inputs:
% img: image
% trueboxes: corresponding boxes
% angle: rotate angle
% outputs:
% rimg: rotated image
% rboxes; rotated bounding boxes


rimg = imrotate(img,angle,'crop');
[Y, X] = size(img);
bw = trueboxes(:,3);
bl = trueboxes(:,4);
% x0 = trueboxes(:,1)+ceil(bw/2);
% y0 = trueboxes(:,2)+ceil(bl/2);

% [theta,rho] = cart2pol(x0-X/2,Y/2-y0);
% [x1,y1] = pol2cart(theta+angle*pi/180,rho);
% bx = floor(x1+X/2) - ceil(bw/2);
% by = floor(Y/2-y1) - ceil(bl/2);
[x1, y1] = rotatetheta(trueboxes(:,1),trueboxes(:,2),angle, X, Y);
[x2, y2] = rotatetheta(trueboxes(:,1)+bw,trueboxes(:,2),angle, X, Y);
[x3, y3] = rotatetheta(trueboxes(:,1),trueboxes(:,2)+bl,angle, X, Y);
[x4, y4] = rotatetheta(trueboxes(:,1)+bw,trueboxes(:,2)+bl,angle, X, Y);
bx = min([x1,x2,x3,x4],[],2);
by = min([y1,y2,y3,y4],[],2);
bw = max([x1,x2,x3,x4],[],2) - bx;
bl = max([y1,y2,y3,y4],[],2) - by;
% remove boxes that is out of the size
bix = (bx < 1) & (bx >= 1 - bw/5);
bx(bix)=1;
biy = (by < 1) & (by >= 1 - bl/5);
by(biy)=1;
biw = (bx+bw > X) & (bx+bw <= X + bw/5);
bw(biw)=X-bx(biw);
bil = (by+bl > Y) & (by+bl <= Y + bl/5);
bl(bil)=Y-by(bil);
idx = (bx>=1) & (by>=1) & (bx+bw<=X) & (by+bl<=Y);
rboxes = [bx, by, bw, bl];
rboxes(~idx,:)=[];
% showbbox(img,trueboxes);
% showbbox(rimg,rboxes);

function [x1, y1] = rotatetheta(x0, y0, angle, X, Y)
[theta,rho] = cart2pol(x0-X/2,Y/2-y0);
[x1,y1] = pol2cart(theta+angle*pi/180,rho);
x1 = x1+X/2;
y1 = Y/2-y1;

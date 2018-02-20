function bboxes = checkboxes(rboxes, X, Y)
% check the bounding boxes coordinates to make sure it fits in the images
% resize the bounding box if the box is outside the image
% inputs
% rboxes: original bounding boxes, size (m*4)
% X: length of the x axis of the image
% Y: length of the y axis of the image
% outputs
% bboxes: the new bounding boxes that is for sure within the image frame
bboxes = rboxes;
bboxes(bboxes(:,1)<=0,1)=1;
bboxes(bboxes(:,2)<=0,2)=1;
iw = ((bboxes(:,1)+bboxes(:,3))>X);
bboxes(iw,3)=X - bboxes(iw,1);
il = ((bboxes(:,2)+bboxes(:,4))>Y);
bboxes(il,4)=Y - bboxes(il,2);
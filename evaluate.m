% calculate recall and precision
function scores = evaluate(truebox, boxes, img)
% This function compares the true bounding boxes with labeled bounding
% boxes and return the precision and recall score
% inputs:
% truebox: ground truth bounding boxes as standard
% boxes: labeled bounding boxes
% img: if null, do nothing; if img is an image, then plot the true
% bounding boxes and labeled bounding boxes on the image and show the
% difference
% outputs:
% scores: an array of recall and precision

%% count the predicted centers
[PredTrue, ~, DetectedBox, ~] = compareBbox(truebox, boxes);
recall = size(DetectedBox,1)/size(truebox,1);
precision = size(PredTrue,1)/size(boxes,1);
scores = [recall, precision];
detectlabel=1:size(boxes,1);
truelabel=1:size(truebox,1);
if (nargin==3)
%if (1)
    trueImg = insertObjectAnnotation(img,'rectangle',truebox, truelabel, 'LineWidth',3, 'color', 'blue');
    trueImg = insertObjectAnnotation(trueImg,'rectangle',DetectedBox, '', 'LineWidth',3);
    figure;
    imshow(trueImg);
    posImg = insertObjectAnnotation(img,'rectangle',boxes, detectlabel, 'LineWidth',3,'color', 'blue');
    posImg = insertObjectAnnotation(posImg,'rectangle',PredTrue, '', 'LineWidth',3);
    figure;
    imshow(posImg);  
end
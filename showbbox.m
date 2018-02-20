function showbbox(img,bboxes,scores)
% This function draws the bounding boxes on the image 
% inputs:
% img: image
% bboxes: bounding boxes 
% scores: the screening score of each bounding box. If null, show nothing.
% output:
% none

%%
if (nargin < 3)
% Insert bounding boxes and return marked image.
    detectedImg = insertObjectAnnotation(img,'rectangle',bboxes, '', 'LineWidth',3);   
else 
    detectedImg = insertObjectAnnotation(img,'rectangle',bboxes, scores, 'TextBoxOpacity', 0.5,'LineWidth',3);
end
% Display the detected stop sign.
figure;
imshow(detectedImg);
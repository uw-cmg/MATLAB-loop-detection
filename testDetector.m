function boxes = testDetector(img,detectorName)
% Apply the trained cascade object detector on a test image given and plot
% the detected bounding boxes on the image
% inputs
% img: image
% detectorName: trained cascade object detector
% outputs
% boxes: detected bounding boxes

detector = vision.CascadeObjectDetector(detectorName);  
boxes = step(detector,img);
%%
% Insert bounding boxes and return marked image.
detectedImg = insertObjectAnnotation(img,'rectangle',boxes, '', 'LineWidth',3);   
%%
% % Display the detected stop sign.
% figure;
% imshow(detectedImg);
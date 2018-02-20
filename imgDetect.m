% apply model and process the image
% output the predicted boxes
function fboxes = imgDetect(detectorname, img)
% old function. not used any more
% similar to testDetector, expect this function has an additional screening
% step by radial sweeping method.

boxes = testDetector(img,detectorname);
fboxes=[];
scores=[];
fscores=[];
threshold = 0.75;
[nrows, ~] = size(boxes);
for i = 1:nrows
    box = boxes(i,:);
    subim = crop(img, box);
    score = screen(subim);
    scores = [scores; score];
    if (score>threshold)
        fboxes=[fboxes;box];
        fscores = [fscores;score];
    end
end
fboxes = fboxes(filterOverlap(fboxes),:);
%fscores = fscores(filterOverlap(fboxes));

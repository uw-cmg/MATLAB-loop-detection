function  [PredTrue, PredFalse, DetectedBox, NotDetectedBox] = compareBbox(truebox, boxes)
% This function compares the tw0 set of bounding boxes and return the
% number of bounding boxes matched or mismatched.
% inputs:
% truebox: standard true bounding boxes
% boxes: bounding boxes for comparison
% outputs:
% PredTrue: bounding boxes in comparison set that matches with true
% bounding box set
% PredFalse: bounding boxes in comparison set that doesn't match with true
% set
% DetectedBox: bounding boxes in true set that matches with comparison set
% NotDetectedBox: bounding boxes in true set that doesn't match with
% comparison set
% All the bounding boxes set are kept in a matrix of size (m*4), where m is
% the number of bounding boxes in the set.

%%
testcenters = horzcat(boxes(:,1)+boxes(:,3)/2,boxes(:,2)+boxes(:,4)/2);
% count correct spotted defects
truecenters = horzcat(truebox(:,1)+truebox(:,3)/2,truebox(:,2)+truebox(:,4)/2);
% ismembertol is a built in function
[LIA,LocAllB] = ismembertol(truecenters, testcenters, 1, 'ByRows', true, ...
    'OutputAllIndices', true, 'DataScale', [20,20]);

DetectedBox = truebox(LIA,:);
NotDetectedBox = truebox(~LIA,:);

pos = unique(cell2mat(LocAllB));
pos = pos(pos~=0);
truePredictions = false(size(boxes,1),1);
truePredictions(pos) = 1;
PredTrue = boxes(truePredictions, :);
PredFalse = boxes(~truePredictions,:);

function [score, fitloops] = screen(subim1)
% use radial sweeping method to output the confidence score of loop and
% output the fitted elliptical loop parameters
% inputs
% subim1: cropped image with one loop inside
% outputs
% score: confidence score of being a loop, the higher the more likely to be
% a loop
% fitloops: fitted parameters of ellipse of the loop inside

[scores, ~, fitscores,fitloops] = screenScores(subim1);
% weights = [0.4,0.2,0.05,0.05,0.3,0.5];
allscores = [scores, fitscores];
allweights = [0.4;0.2;0.05;0.05;0.3;0.5;0;-0.05;-0.1;0];
score=allscores*allweights;
%score=scores*weights';
% [scores1,scores2, fitscores, fitloops] = screenScores(subim1);
% load trained_results2.mat
% instance = [scores1,scores2,fitscores];
% data = (instance - trained_results{1})./trained_results{2};
% score = data*trained_results{3}-trained_results{4};

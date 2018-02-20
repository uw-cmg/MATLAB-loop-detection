%% Test all images in the test set
% This script can take all images in the test set and give average recall
% and precision score over the test set.

%% Step 1: run through all images in the test set (small set with 6 images)
% load CNN model if not existing 
% load loopNet3D7.mat
% record the run time
t = cputime;
% matrix to keep all the scores
scores = zeros(6,4);
% cell matrix to keep all amjor axis
majoraxises = cell(6,1);
for i = 1:6
    [scores(i,:), majoraxises{i}] = testImages(i, loopNet3D7);
end
% total run time
totalTime = cputime-t
total = sum(scores, 1);
%% Step 2: get the average score on the test set
% t_recall is the recall score for all the loops in the test set
% t_precision is the precision score for all the loops in the test set
% m_recall is the average recall over images in the test set
% m_precision is the average precision over images in the test set
t_recall = total(1)/total(2)
t_precision = total(3)/total(4)
m_recall = mean(scores(:,1)./scores(:,2))
m_precision = mean(scores(:,3)./scores(:,4))

%% Sample output
% t_recall = 0.8512
% t_precision = 0.8374
% m_recall = 0.8416
% m_precision = 0.8366
%%
% This part of code is used for testing all 28 images in the test set.
% uncomment the section if need to get result for all 28 images
% Before running this section, note that in the arguments of testImages(),
% you need to add a third argument 'complete' to make sure it runs on the
% complete 28 image set.

t = cputime;
scores = zeros(28,4);

for i = 1:28
    [scores(i,:), majoraxis] = testImages(i, loopNet3D7,'complete');
end
totalTime = cputime-t
total = sum(scores, 1);
t_recall = total(1)/total(2)
t_precision = total(3)/total(4)
m_recall = mean(scores(:,1)./scores(:,2))
m_precision = mean(scores(:,3)./scores(:,4))

%% Sample output
% t_recall = 0.8546
% t_precision = 0.8733
% m_recall = 0.8576
% m_precision = 0.8651
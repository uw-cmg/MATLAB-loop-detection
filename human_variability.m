% This script compares human variation with standard labeling

%% Step 1: compare the results per image
files = dir('standard_labels/*.xls');
standard_labels = cell(numel(files),1);
manual_labels = cell(numel(files),1);
scores = zeros(numel(files),4);
majoraxises = cell(6,1);
for i = 1:numel(files)
    filename = files(i).name;
    fullname = fullfile('standard_labels',filename);
    humanfile = fullfile('manual_labels',filename);
    [imagenames, positions, XM, YM, Major, Minor, Angle] = getPos(fullname,'survey');
    %majoraxises{i} = Major;
    trueboxes = cell2mat(positions);
    [imagenames, positions, XM, YM, Major, Minor, Angle] = getPos(humanfile,'survey');
    predboxes = cell2mat(positions);
    %majoraxises{i} = Major;
    standard_labels{i}=trueboxes;
    manual_labels{i}=predboxes;
    [PredTrue, ~, DetectedBox, ~] = compareBbox(trueboxes, predboxes);
     scores(i,:) = [size(DetectedBox,1), size(trueboxes,1), size(PredTrue,1), size(predboxes,1)];
%      figure;
%     imshow(imagenames{1});
%     hold on;
%     ellipse(Major,Minor,pi*(180-Angle)/180,XM,YM);
%     hold off;
     
end
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
% %%
% files = dir('manual_labels/*.xls');
% manual_labels = cell(numel(files),1);
% for i = 1:numel(files)
%     filename = files(i).name;
%     fullname = fullfile('manual_labels',filename);
%     [imagenames, positions, XM, YM] = getPos(fullname,'survey');
%     predboxes = cell2mat(positions);
%     manual_labels{i}=predboxes;
% end

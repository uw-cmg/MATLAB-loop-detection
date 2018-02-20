
function stop = stopTrainingAtThreshold(info,thr)
%  Helper function in training CNN. Stop training if the accuracy has
%  reached a set threshold.

stop = false;
if info.State ~= "iteration"
    return
end

persistent iterationAccuracy

% Append accuracy for this iteration
iterationAccuracy = [iterationAccuracy info.TrainingAccuracy];

% Evaluate mean of iteration accuracy and remove oldest entry
if numel(iterationAccuracy) == 50
    stop = mean(iterationAccuracy) > thr;

    iterationAccuracy(1) = [];
end

end
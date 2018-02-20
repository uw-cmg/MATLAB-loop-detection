% CNN classification
% old version of using CNN features for screening;
% not used any more;
% the cnn netowrk is pre-trained alex network
% cannot garanttee it still works now
subims=[];
for i = 1:size(rawboxes,1)
    subim = crop(img, rawboxes(i,:));
    if ismatrix(subim)
        subim = cat(3,subim,subim,subim);
    end
    subim = imresize(subim, [227 227]);
    subims(:,:,:,i)=subim;
end
detectionFeatures = activations(net, subims, featureLayer, 'MiniBatchSize',32);
predictedLabels = predict(classifier, detectionFeatures);
cnnboxes = rawboxes(predictedLabels=='PosSubImg',:);
function genNegIm()
%
% old function; not used any more. 
% It basically load a pre-saved dataset and generate the negative images 
% from positive images

negative = load('labelingSession2.mat');
negativeInstance = negative.labelingSession.ImageSet.ImageStruct;
imNum = 0;
for imageindex = 1:numel(negativeInstance)
    imagename = negativeInstance(imageindex).imageFilename;
    im = imread(imagename);
    subrec = negativeInstance(imageindex).objectBoundingBoxes;
    for recindex = 1:size(subrec,1)
        [x1, y1, len, lon] = deal(subrec(recindex,1),subrec(recindex,2),...
            subrec(recindex,3),subrec(recindex,4));       
        
        imNum = imNum + 1;

        tempIm = im(y1:y1+lon-1,x1:x1+len-1,:);
        filename = ['negativeImages/', num2str(imNum),'.jpg'];
        imwrite(tempIm,filename,'jpg');
    end
end

        
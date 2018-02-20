% This script is to augment the existing positive images by rotation and 
% mirroring.

% This script is different from negImgAugmentation
%% image rotation
files = dir('training_dataset/*.txt');
steps = 4;
parfor fileID = 1:numel(files) 
    filename = files(fileID).name;
    fullname = fullfile('training_dataset',filename);
    copyfile(fullname, 'generatedLabelFiles_rotate/')
    imagefolder='positive';
    [imagenames, positions] = readLabel(fullname,imagefolder);
    trueboxes = cell2mat(positions);
    image_name = imagenames{1};
    copyfile(image_name, 'generated_positive_rotate/')
    img = imread(image_name);
    for step=1:steps
        angle = -180+step*360/steps;
        if (angle==0)
            continue;
        end
        [rimg, rboxes]=viarotate(img,trueboxes,angle);
        
        imname = ['generated_positive_rotate/rotate_', num2str(angle),'degree_',...
            filename(1:end-4),'.jpg'];
        imwrite(rimg,imname,'jpg');
        dataname = ['generatedLabelFiles_rotate/rotate_', num2str(angle),'degree_',...
            filename];
        dlmwrite(dataname,rboxes,'delimiter',' ');
        %showbbox(rimg,rboxes);
    end
end
% %% image resize
% files = dir('generatedLabelFiles_rotate/*.txt');
% [steps, low, high] = deal(4,0.6,1.4);
% parfor fileID = 1:numel(files)
%     filename = files(fileID).name;
%     fullname = fullfile('generatedLabelFiles_rotate',filename);
%     imagefolder='generated_positive_rotate';
%     [imagenames, positions] = readLabel(fullname,imagefolder);
%     trueboxes = cell2mat(positions);
%     image_name = imagenames{1};
%     img = imread(image_name);
%     movefile(image_name, 'generated_positive_resize/')
%     movefile(fullname, 'generatedLabelFiles_resize/')
%     for step = 0:steps
%         ratio = low+(high-low)*step/steps;
%         if (ratio == 1)
%             continue;
%         end
%         rimg = imresize(img,ratio);
%         rboxes = round(trueboxes*ratio);
%         [Y,X] = size(rimg);
%         rboxes = checkboxes(rboxes,X,Y);
%         imname = ['generated_positive_resize/resize', num2str(ratio),'ratio_',...
%             filename(1:end-4),'.jpg'];
%         imwrite(rimg,imname,'jpg');
%         dataname = ['generatedLabelFiles_resize/resize', num2str(ratio),'ratio_',...
%             filename];
%         dlmwrite(dataname,rboxes,'delimiter',' ');
%         %showbbox(rimg,rboxes);
%     end
% end
% %% image change aspect ratio
% files = dir('generatedLabelFiles_resize/*.txt');
% [steps, low, high] = deal(4,0.8,1.2);
% parfor fileID = 1:numel(files)
%     filename = files(fileID).name;
%     fullname = fullfile('generatedLabelFiles_resize',filename);
%     imagefolder='generated_positive_resize';
%     [imagenames, positions] = readLabel(fullname,imagefolder);
%     trueboxes = cell2mat(positions);
%     image_name = imagenames{1};
%     img = imread(image_name);
%     
%     for step = 0:steps
%         ratio = low+(high-low)*step/steps;
%         if (ratio == 1)
%             continue;
%         end
%         [numrows, numcols] = size(img);
%         rimg = imresize(img,[numrows,round(ratio*numcols)]);
%         rboxes = trueboxes;
%         rboxes(:,[1,3]) = round(rboxes(:,[1,3])*ratio);
%         [Y,X] = size(rimg);
%         rboxes = checkboxes(rboxes,X,Y);
%         imname = ['generated_positive_aspect/reshape', num2str(ratio),'ratio_',...
%             filename(1:end-4),'.jpg'];
%         imwrite(rimg,imname,'jpg');
%         dataname = ['generatedLabelFiles_aspect/reshape', num2str(ratio),'ratio_',...
%             filename];
%         dlmwrite(dataname,rboxes,'delimiter',' ');
%         %showbbox(rimg,rboxes);
%     end
%     movefile(fullname, 'generatedLabelFiles_aspect/')
%     movefile(image_name, 'generated_positive_aspect/')
% end
%% image mirror
files = dir('once/*.txt');
parfor fileID = 1:numel(files)
    filename = files(fileID).name;
    fullname = fullfile('once',filename);
    imagefolder='positive';
    [imagenames, positions] = readLabel(fullname,imagefolder);
    trueboxes = cell2mat(positions);
    image_name = imagenames{1};
%     img = imread(image_name);
%     
%     rimg = flip(img,2);
%     rboxes = trueboxes;
%     [Y,X]=size(rimg);
%     rboxes(:,1)=X-trueboxes(:,1)-trueboxes(:,3)+1;
%     imname = ['aug_training_positive/fliped_', filename(1:end-4),'.jpg'];
%     imwrite(rimg,imname,'jpg');
%     dataname = ['aug_training_files/fliped_',filename];
%     dlmwrite(dataname,rboxes,'delimiter',' ');
    copyfile(fullname, 'aug_training_files/')
    copyfile(image_name, 'aug_training_positive/')
end
%%

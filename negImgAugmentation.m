% This script is to augment the existing negative images by rotation,
% resizing, changing aspect ratio, and mirroring.

% The script can be a little complicated as it deals with different image
% data folders. You may need to change some folder name and block some
% section of code. For example, if you want to augment the "good" negative
% more times than "not-so-good" negative images, you may put the "good" and
% "not-so-good" negative images in seperate folders. And run the script for
% "good" image with this script. Then run the script for "not-so-good" image 
% folder with some sections of the code blocked, such as changing aspect 
% ratio or resizing section. Thus we can augment images selectively, making 
% "good" images more frequent.

%% image rotation 
% change the folder name if needed. Note you may also need to chaneg the
% corresponding name in side the fullfile() function.
files = dir('good_negative_images/*.jpg');
steps = 4;
parfor fileID = 1:numel(files)
    filename = files(fileID).name;
    fullname = fullfile('good_negative_images',filename);

    image_name = fullname;
    copyfile(image_name, 'generated_negative_rotate/')
    img = imread(image_name);
    for step=1:steps
        angle = -180+step*360/steps;
        if (angle==0)
            continue;
        end
        rimg = imrotate(img,angle,'crop');
        
        imname = ['generated_negative_rotate/rotate_', num2str(angle),'degree_',...
            filename];
        imwrite(rimg,imname,'jpg');
        bimg = imgaussfilt(rimg, 2);
        
        % add some blurred negative images

        imname = ['aug_negative_images/blur_rotate', num2str(angle),'degree_',...
            filename];
        imwrite(bimg,imname,'jpg');

        %showbbox(rimg,rboxes);
    end
end
%% image resize
% change the folder name if needed. Note you may also need to chaneg the
% corresponding name in side the fullfile() function.
files = dir('generated_negative_rotate/*.jpg');
[steps, low, high] = deal(2,0.7,1.3);
parfor fileID = 1:numel(files)
    filename = files(fileID).name;
    fullname = fullfile('generated_negative_rotate',filename);

    image_name = fullname;
    

    img = imread(image_name);

    for step = 1:steps
        ratio = low+(high-low)*step/steps;
        if (ratio == 1)
            continue;
        end
        rimg = imresize(img,ratio);

        imname = ['generated_negative_resize/resize', num2str(ratio),'ratio_',...
            filename];
        imwrite(rimg,imname,'jpg');
        %showbbox(rimg,rboxes);
    end
    movefile(image_name, 'generated_negative_resize/')
end

%% image change aspect ratio
% change the folder name if needed. Note you may also need to chaneg the
% corresponding name in side the fullfile() function.
files = dir('generated_negative_resize/*.jpg');
[steps, low, high] = deal(2,0.8,1.2);
parfor fileID = 1:numel(files)
    filename = files(fileID).name;
    fullname = fullfile('generated_negative_resize',filename);

    image_name = fullname;
    

    img = imread(image_name);
    
    
    for step = 0:steps-1
        ratio = low+(high-low)*step/steps;
        if (ratio == 1)
            continue;
        end
        [numrows, numcols] = size(img);
        rimg = imresize(img,[numrows,round(ratio*numcols)]);
       
        imname = ['generated_negative_aspect/reshape', num2str(ratio),'ratio_',...
            filename];
        imwrite(rimg,imname,'jpg');

        %showbbox(rimg,rboxes);
    end
    movefile(image_name, 'generated_negative_aspect/')
end

%% image mirror
% change the folder name if needed. Note you may also need to chaneg the
% corresponding name in side the fullfile() function.

files = dir('generated_negative_aspect/*.jpg');
parfor fileID = 1:numel(files)
    filename = files(fileID).name;
    fullname = fullfile('generated_negative_aspect',filename);

    image_name = fullname;
    
    img = imread(image_name);
    
    rimg = flip(img,2);

    imname = ['aug_negative_images/fliped_', filename];
    imwrite(rimg,imname,'jpg');

    movefile(image_name, 'aug_negative_images/')
end

% %% image blur
% files = dir('good_images/*.jpg');
% parfor fileID = 1:numel(files)
%     filename = files(fileID).name;
%     fullname = fullfile('good_images',filename);
% 
%     image_name = fullname;
%     
%     img = imread(image_name);
%     
%     rimg = imgaussfilt(img, 2);
% 
%     imname = ['aug_negative_images/blur_', filename];
%     imwrite(rimg,imname,'jpg');
% end
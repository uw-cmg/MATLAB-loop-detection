%floodfitting
function fitResults = foodfitting(subim)
% A typo in the function name, should be floodfitting. Please ignore it...
% this function calls flood function and then use regionprop to fit the
% extracted loop shape and returns the fitted loop shape
% inputs
% subim: cropped image with a single loop inside
% outputs
% fitResults: extracted loop information with the format as [major axis/2, 
% minor axis/2, orientation in rad unit, centrod x coordinate, centroid y 
% coordinate]

% call flodd function
[~, inner] = flood(subim);
% smooth the shape
im1 = imfilter(inner,ones(5)/20);
stats = regionprops(im1,'Area','Centroid',...
    'MajorAxisLength','MinorAxisLength','BoundingBox',...
    'Orientation');

% get the region with largest area
try
    [~,idx_s] = max([stats.Area]);
catch 
    % use default index if there is no area detected
    idx_s = 1;
end
stats_s = stats(idx_s);
centroids = reshape([stats_s.Centroid],2,[]);
centroids = centroids';
fitResults = [[stats_s.MajorAxisLength]'/2,[stats_s.MinorAxisLength]'/2,...
    (180-[stats_s.Orientation]')*pi/180,centroids(:,1),...
    centroids(:,2)];
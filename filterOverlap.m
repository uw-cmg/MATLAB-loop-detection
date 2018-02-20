function newbox = filterOverlap(bbox)
% clean overlapped bounding boxes. Keep the larger one if two bounding boxes 
% has 70% overlapping area.
% inputs
% bbox: original bounding boxes
% outputs
% newbox: logical array with 1 indicating to keep and 0 indicating to
% remove.
scores=bboxOverlapRatio(bbox,bbox, 'Min');
[a,b]=find(scores>0.7);
numbox = size(bbox,1);
overlaped = false(numbox,1);
for i = 1: size(a,1)
    index1 = a(i);
    index2 = b(i);
    if(index1>=index2)
        continue;
    end
    box1 = bbox(index1,:);
    box2 = bbox(index2,:);
    if (box1(3)*box1(4)>= box2(3)*box2(4))
        overlaped(index2)=1;
    else
        overlaped(index1)=1;
    end
end
newbox=~overlaped;
    
    
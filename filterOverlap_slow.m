% eliminate overlap bbox
function newbox = filterOverlap_slow(bbox)
numbox = size(bbox,1);
overlaped = false(numbox,1);
for i =1:numbox
    for j=i+1:numbox
        if(overlaped(j)==1)
            continue
        end
        box1 = bbox(i,:);
        box2 = bbox(j,:);
        fraction = bboxOverlapRatio(box1,box2, 'Min');
        if (fraction > 0.7)
            if (box1(3)*box1(4)>= box2(3)*box2(4))
                overlaped(j)=1;
            else
                overlaped(i)=1;
            end
        end        
    end
end
newbox=bbox(~overlaped,:);

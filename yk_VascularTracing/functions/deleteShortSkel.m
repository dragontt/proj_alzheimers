function SkeletonSegments=deleteShortSkel(SkeletonSegments)
% This function deletes skeleton segments of length shorter than 5 elements

for i=1:length(SkeletonSegments)
    if size(SkeletonSegments{i},1)<5
        SkeletonSegments{i}=[];
    end
end
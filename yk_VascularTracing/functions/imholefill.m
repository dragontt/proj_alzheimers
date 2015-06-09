function V=imholefill(V,threshold)
% This function fill the hole of the number of connected components under 
% threshold

V=imclose(V,strel('disk',10));
V=imcomplement(V);
for i=1:size(V,3)
    V1=V(:,:,i);
    CC=bwconncomp(V1,6);
    for j=1:CC.NumObjects
        if (length(CC.PixelIdxList{j})<threshold)
            V1(CC.PixelIdxList{j})=0;
        end
    end
    V(:,:,i)=V1;
end
V=logical(imcomplement(V));

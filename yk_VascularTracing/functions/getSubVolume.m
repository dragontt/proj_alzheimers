function [CCgp,xyDivCoord]=getSubVolume(V,dim)
% This function divide volumetric data into 16 subvolumes by splitting 4x4
% in xy plane
%
% CCgp - grouped connected components in each subvolume
%        row 1 - pixel index list
%        row 2 - subvolume num
%        row 3 - image size of the subvolume
%        row 4 - connected group number in master volume

CCmaster=bwconncomp(V,26);
sizeMaster=CCmaster.ImageSize;
ccNumMaster=CCmaster.NumObjects;
idxListMaster=CCmaster.PixelIdxList;
xyDivCoord=[0,floor(dim(1)/4),floor(dim(1)/2),floor(dim(1)*3/4),dim(1);...
            0,floor(dim(2)/4),floor(dim(2)/2),floor(dim(2)*3/4),dim(2)];
        
VSub=cell(4);
for i=1:4
    for j=1:4
        VSub{i,j}=V(xyDivCoord(1,i)+1:xyDivCoord(1,i+1),...
                    xyDivCoord(2,j)+1:xyDivCoord(2,j+1),:);
    end
end

% define connected components in subvolume
CCgp={};
for i=1:16
    CC=bwconncomp(VSub{i},26);
    for j=1:CC.NumObjects
        if length(CC.PixelIdxList{j})>100
            lengCCgp=size(CCgp,2);
            CCgp{1,lengCCgp+1}=CC.PixelIdxList{j}; % pixel index list in subvolume
            CCgp{2,lengCCgp+1}=i; % div num of subvolume
            CCgp{3,lengCCgp+1}=CC.ImageSize; % image size for each pixel index list
        end
    end
end

% match cc in subvolume with original volume
for i=1:size(CCgp,2) 
    CCgp{4,i}=0; 
end
for iPar=1:size(CCgp,2)
    [divY,divX]=ind2sub([4,4],CCgp{2,iPar});
    [I,J,K]=ind2sub(CCgp{3,iPar},CCgp{1,iPar}(1));
    I=I+xyDivCoord(1,divY);
    J=J+xyDivCoord(2,divX);
    idxgp=sub2ind(sizeMaster,I,J,K);
    for j=1:ccNumMaster
        out=find(~(idxListMaster{j}-idxgp));
        if ~isempty(out)
            CCgp{4,iPar}=j; % connected group number in master volume
            break;
        end
    end
end

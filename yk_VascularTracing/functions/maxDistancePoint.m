function [posD,maxD]=maxDistancePoint(BoundaryDistance,I)
% Mask the result by the binary input image
BoundaryDistance(~I)=0;

% Find the maximum distance voxel
[maxD,ind] = max(BoundaryDistance(:));
if(~isfinite(maxD))
    error('Skeleton:Maximum','Maximum from MSFM is infinite !');
end

[x,y,z]=ind2sub(size(I),ind); posD=[x;y;z];

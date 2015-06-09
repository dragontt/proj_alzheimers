function BoundaryDistance=getBoundaryDistance(I)
% Calculate Distance to vessel boundary

% Set all boundary pixels as fastmarching source-points (distance = 0)
S=ones(3,3,3);
B=xor(I,imdilate(I,S));
ind=find(B(:));

[x,y,z]=ind2sub(size(B),ind);
SourcePoint=[x(:) y(:) z(:)]';

% Calculate Distance to boundarypixels for every voxel in the volume
SpeedImage=ones(size(I));
BoundaryDistance = msfm(SpeedImage, SourcePoint, false, true);

% Mask the result by the binary input image
BoundaryDistance(~I)=0;
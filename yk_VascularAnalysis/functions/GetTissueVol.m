function V_tissue=GetTissueVol(im,Skel,distThd)
% This function computes the tissue volume related to the closest blood
% vessel segments. Distance transform is used for this categorization 
% technique.
%
% V_tissue contains numerated tissue region, whos value cooresponds to the
% vessel index [(1):(max vessel idx)].

% correct matrix dimension
dim=size(im);
tmpDim=dim(1); dim(1)=dim(2); dim(2)=tmpDim; 
for i=1:3
    maxDim=0;
    for j=1:size(Skel,2)
        tmpSkel=Skel{1,j};
        tmpMaxDim=round(max(tmpSkel(:,i)));
        if tmpMaxDim>maxDim
            maxDim=tmpMaxDim;
        end
    end
    if dim(i)<maxDim
        dim(i)=maxDim;
    end
end

% generate volumetric index assignment of linepath points (including
% start and end points), with x,y,z down sampling into halves.
%
% note: Computation time increases exponentially as data size increases.
dimHalf=ceil(dim/2);
V_xyzHalf=zeros(dimHalf);
V_mask=V_xyzHalf;
for i=1:size(Skel,2)
    tmpSkel=Skel{1,i};
    for j=2:size(tmpSkel,1)-1
        tmpLoc=zeros(1,3);
        for k=1:3
            tmpLoc(k)=ceil(tmpSkel(j,k)/2);
        end
        V_xyzHalf(tmpLoc(1),tmpLoc(2),tmpLoc(3))=i;
        V_mask(tmpLoc(1),tmpLoc(2),tmpLoc(3))=1;
    end
end

% compute distance transform and categorize region
[V_dist,idx_dist]=bwdist(V_mask,'chessboard');

V_group=cell(1,size(Skel,2));
parfor i=1:size(Skel,2)
    tmp=find(V_xyzHalf(idx_dist)==i);
    V_group{i}=tmp(find(V_dist(tmp)<ceil(distThd/2)));
end

% swap matrix dimension
for i=1:size(Skel,2)
    V_xyzHalf(V_group{i})=i;
end
V_xyzHalf=permute(V_xyzHalf,[2,1,3]);

% convert the downsampled volume back to volume in microns
V_tissue=zeros(dimHalf(2)*2,dimHalf(1)*2,dimHalf(3)*2);
for i=1:dimHalf(3)
    V_tissue(:,:,i*2-1)=imresize(V_xyzHalf(:,:,i),2,'nearest');
    V_tissue(:,:,i*2)=V_tissue(:,:,i*2-1);
end
dim=size(im);
V_tissue=V_tissue(1:dim(2),1:dim(1),1:dim(3));


    


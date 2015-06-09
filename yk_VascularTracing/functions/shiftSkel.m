function S=shiftSkel(CCgp,S,xyDivCoord,num_TopStack,idx)

% This function shifts skeleton acoording to subvolume x- ,y-, z- coordinate
[divY,divX]=ind2sub([4,4],CCgp{2,idx});
for k=1:length(S)
    S{k}(:,1)=S{k}(:,1)+xyDivCoord(1,divY);
    S{k}(:,2)=S{k}(:,2)+xyDivCoord(2,divX);
    S{k}(:,3)=S{k}(:,3)+num_TopStack-1;
end
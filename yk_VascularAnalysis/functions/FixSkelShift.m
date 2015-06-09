function Skel2=FixSkelShift(Skel,distMap,diamNbhd)
% This function corrects linepath points and nodes offset due to hand
% tracing, by shifting each point to the neighbor point with the largest
% distance to vessel boundary.

dim=size(distMap);
Skel2=Skel;

for i=1:size(Skel,2)
    skelList=Skel{1,i};
    for j=1:size(skelList,1)
        loc=round(skelList(j,:));
        if loc(1)<1|loc(2)<1|loc(3)<1
            skelList(j,:)=[max(loc(1),1),max(loc(2),1),max(loc(3),1)];
        elseif loc(1)>dim(1)|loc(2)>dim(2)|loc(3)>dim(3)
            skelList(j,:)=[min(loc(1),dim(1)),min(loc(2),dim(2)),min(loc(3),dim(3))];
        else
            bndyLow=zeros(1,3); bndyUp=bndyLow;
            for k=1:3
                bndyLow(k)=max(1,loc(k)-diamNbhd+1);
                bndyUp(k)=min(dim(k),loc(k)+diamNbhd-1);
            end
            dMapNbhd=distMap(bndyLow(1):bndyUp(1),bndyLow(2):bndyUp(2),bndyLow(3):bndyUp(3));
            [maxDist,idxLocal]=max(dMapNbhd(:));
            if maxDist>distMap(loc(1),loc(2),loc(3))
                subLocal=zeros(1,3);
                [subLocal(1),subLocal(2),subLocal(3)]=ind2sub([bndyUp(1)-bndyLow(1)+1,...
                    bndyUp(2)-bndyLow(2)+1,bndyUp(3)-bndyLow(3)+1],idxLocal);
                subGlobal=bndyLow-[1,1,1]+subLocal;
                skelList(j,:)=subGlobal;
            end
        end
    end
    skelList(any(isnan(skelList),2),:)=[];
    Skel2{1,i}=skelList;
end


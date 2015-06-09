function Skel=GetMaskedSkel(Skel,mask)

flag=false(1,size(Skel,2));
pixelIdxList=cell(1,size(mask,3));
for i=1:size(mask,3)
    pixelIdxList{i}=find(~mask(:,:,i));
end
for i=1:size(Skel,2)
    for j=1:size(Skel{1,i},1)
        loc=zeros(1,3);
        for k=1:3
            loc(k)=round(Skel{1,i}(j,k));
            loc(k)=max(loc(k),1);
            loc(k)=min(loc(k),size(mask,k));
        end
        currentIdxList=sub2ind(size(mask(:,:,1)),loc(1),loc(2));
        if ismember(currentIdxList,pixelIdxList{loc(3)})
            flag(i)=true;
            break;
        end
    end
end
for i=1:size(Skel,2)
    if flag(i)
        Skel{1,i}=[];
        Skel{2,i}=[];
    end
end
tmpSkel1=Skel(1,:);
tmpSkel2=Skel(2,:);
tmpSkel1=tmpSkel1(~cellfun('isempty',tmpSkel1));
tmpSkel2=tmpSkel2(~cellfun('isempty',tmpSkel2));
Skel=vertcat(tmpSkel1,tmpSkel2);
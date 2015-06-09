function Info=GetVessMorph(Skel,distMap)
% This function computes morphological parameters of individual blood
% vessel, including diameter, length, tortuosity, angle variance, surface
% roughness, depth in cerebral tissue

Info=cell(1,size(Skel,2));
dim=size(distMap);

for i=1:size(Skel,2)
    Info{i}=struct;
    Info{i}.Diameters={};
    Info{i}.AvgDiameter=0;
    Info{i}.StdDiameter=0;
    Info{i}.Skewness=0;
    Info{i}.Kurtosis=0;
    Info{i}.Length=0;
    Info{i}.Tortuosity=0;
    Info{i}.AvgDepth=0;
    Info{i}.StdDepth=0;
    Info{i}.AngleVar={};
    
    skelList=Skel{1,i};
    n=size(skelList,1);
    diamList=zeros(n,1);    
    leng=0;
    if size(Skel,2)>2
    vectorList=zeros(n-1,3);
    angleList=zeros(n-2,1);
    end
    
    for j=1:n
        loc=zeros(1,3); loc2=loc;
        for k=1:3
            loc(k)=round(skelList(j,k));
            loc(k)=max(loc(k),1);
            loc(k)=min(loc(k),dim(k));
            if j~=1 
                loc2(k)=round(skelList(j-1,k)); 
                loc2(k)=max(loc2(k),1);
                loc2(k)=min(loc2(k),dim(k));
            end
        end
        diamList(j)=2*distMap(loc(1),loc(2),loc(3));
        if j~=1 
            leng=leng+pdist([loc(1),loc(2),loc(3);loc2(1),loc2(2),loc2(3)],'euclidean'); 
            if size(Skel,2)>2
                if j==2
                    vectorList(j-1,:)=loc-loc2;
                else
                    vectorList(j-1,:)=loc-loc2;
                    angleList(j-2)=atan2(norm(cross(vectorList(1,:),vectorList(j-1,:))),...
                        dot(vectorList(1,:),vectorList(j-1,:)))*180/pi;
                end
            end
        end
    end
    
    Info{i}.Diameters=diamList;
    diamList=diamList';
    diamList(any(diamList(:),1))=[];
    Info{i}.AvgDiameter=mean(diamList);
    Info{i}.StdDiameter=std(diamList);
    Info{i}.Skewness=1/(n*(rms(diamList))^3)*sum(diamList.^3);
    Info{i}.Kurtosis=1/(n*(rms(diamList))^4)*sum(diamList.^4);
    Info{i}.Length=leng;
%     leng=S.Vessels{i}.lengthInMicrons;
%     Info{i}.Length=leng;
    Info{i}.Tortuosity=leng/pdist([skelList(1,1),skelList(1,2),skelList(1,3);...
        skelList(end,1),skelList(end,2),skelList(end,3)],'euclidean');
    Info{i}.AvgDepth=mean(skelList(:,3));
    Info{i}.StdDepth=std(skelList(:,3));
    Info{i}.AngleVar=angleList;
end


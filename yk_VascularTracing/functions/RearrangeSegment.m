function Skel=RearrangeSegment(S,Skel,im,nghbRange)

if nargin<4
    nghbRange=21;
end

% swap x,y in Skel
for i=1:length(Skel)
    tmp=Skel{i}(:,1);
    Skel{i}(:,1)=Skel{i}(:,2);
    Skel{i}(:,2)=tmp;
end

% get new nodes
listNewNodes={};
for i=1:S.NodesCount
    if (strcmp(S.Nodes{i}.type,'Communicating Capillary'))
        locNewNode=S.Nodes{i}.location;
        listRange=cell(1,3);
        for j=1:3
            for k=1:nghbRange
                listRange{j}(k)=round(locNewNode{j})-6+k;
            end
        end
        mtxRange=zeros(nghbRange^3,3);
        for p=1:nghbRange
            for q=1:nghbRange
                for r=1:nghbRange
                    mtxRange(nghbRange^2*(p-1)+nghbRange*(q-1)+r,:)=...
                        [listRange{1}(p),listRange{2}(q),listRange{3}(r)];
                end
            end
        end
        S.Nodes{i}.Range=mtxRange;
        listNewNodes=[listNewNodes,S.Nodes{i}];
    end
end

% fix out of boundary issue
sizeIm=size(im);
for i=1:length(Skel)
    for j=1:3
        for k=1:size(Skel{i},1)
            Skel{i}(k,j)=min(sizeIm(j),round(Skel{i}(k,j)));
            Skel{i}(k,j)=max(1,round(Skel{i}(k,j)));
        end
    end
end

% find match vessel to split
Skel2=Skel;
for i=1:length(listNewNodes)
    locXNode=listNewNodes{i}.location{1};
    locYNode=listNewNodes{i}.location{2};
    locZNode=listNewNodes{i}.location{3};
    listDist={};
    for j=1:length(Skel)
        idxInVess=find(ismember(Skel{j},listNewNodes{i}.Range,'rows'));
        if (~isempty(idxInVess))
            if (idxInVess(1)~=1 && idxInVess(1)~=size(Skel{j},1) &&...
                    idxInVess(end)~=1 && idxInVess(end)~=size(Skel{j},1))
                for k=1:length(idxInVess)
                    counter=length(listDist)+1;
                    listDist{counter}.idxVess=j;
                    listDist{counter}.idxInVess=idxInVess(k);
                    listDist{counter}.dist=pdist2([locXNode,locYNode,locZNode],Skel{j}(k,:));
                end
            end
        end
    end
    if (~isempty(listDist))
        minDist=inf;
        minIdx=0;
        for j=1:length(listDist)
            if (minDist>listDist{j}.dist)
                minDist=listDist{j}.dist;
                minIdx=j;
            end
        end
        Skel{listDist{minIdx}.idxVess}=Skel2{listDist{minIdx}.idxVess}(1:listDist{minIdx}.idxInVess,:);
        Skel{length(Skel)+1}=Skel2{listDist{minIdx}.idxVess}(listDist{minIdx}.idxInVess:end,:);
    end
end

% swap x,y in Skel
for i=1:length(Skel)
    tmp=Skel{i}(:,1);
    Skel{i}(:,1)=Skel{i}(:,2);
    Skel{i}(:,2)=tmp;
end

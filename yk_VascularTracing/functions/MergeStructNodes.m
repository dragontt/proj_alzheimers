function SS=MergeStructNodes(SS,threshold)
% This function merges cluster of nodes within certain distance.

if nargin<2
    threshold=5;
end

NodeList=zeros(SS.NodesCount,3);
for i=1:SS.NodesCount
    for j=1:3
        NodeList(i,j)=SS.Nodes{i}.location{j};
    end
end

% find cluster of nodes within short radius
mtxDist=pdist2(NodeList,NodeList);
mtxDist=triu(mtxDist,1);
idxCloseNodes=find(0<mtxDist & mtxDist<threshold);
[iCloseNodes,jCloseNodes]=ind2sub([SS.NodesCount,SS.NodesCount],idxCloseNodes);
pairNodes=zeros(length(idxCloseNodes),2);
pairNodes(:,1)=iCloseNodes;
pairNodes(:,2)=jCloseNodes;
clusterNodes={};
counter=1;
while true
    if ~isempty(pairNodes)
        clusterNodes{counter}=[pairNodes(1,1),pairNodes(1,2)];
        pairNodes(1,:)=[];
        [pairNodes,clusterNodes{counter}]=AddNodes(pairNodes,clusterNodes{counter});
        counter=counter+1;
    else
        break;
    end
end

% get center of each cluster
clusterCtr=cell(1,length(clusterNodes));
for i=1:length(clusterNodes)
    ptx=[]; pty=[]; ptz=[];
    for j=1:length(clusterNodes{i})
        ptx(j)=NodeList(clusterNodes{i}(j),1);
        pty(j)=NodeList(clusterNodes{i}(j),2);
        ptz(j)=NodeList(clusterNodes{i}(j),3);
    end
    ctrx=mean(ptx); ctry=mean(pty); ctrz=mean(ptz);
    clusterCtr{i}=[round(ctrx),round(ctry),round(ctrz)];
end

% update nodes and vessel info
nodes2Del=[];
for i=1:length(clusterNodes)
    % node location
    for k=1:3
        SS.Nodes{clusterNodes{i}(1)}.location{k}=clusterCtr{i}(k);
    end
    for j=2:length(clusterNodes{i})
        % node connection
        tmpLength1=length(SS.Nodes{clusterNodes{i}(1)}.connections);
        tmpLength2=length(SS.Nodes{clusterNodes{i}(j)}.connections);
        for k=1:tmpLength2
            SS.Nodes{clusterNodes{i}(1)}.connections(tmpLength1+k)...
                =SS.Nodes{clusterNodes{i}(j)}.connections(k);
            % vessel connection
            tmpVessConn=SS.Vessels{SS.Nodes{clusterNodes{i}(j)}.connections{k}}.connections;
            if length(tmpVessConn)==1
                tmpVessConn{1}=clusterNodes{i}(1);
            else
                if tmpVessConn{1}==clusterNodes{i}(j)
                    tmpVessConn{1}=clusterNodes{i}(1);
                else
                    tmpVessConn{2}=clusterNodes{i}(1);
                end
            end
            SS.Vessels{SS.Nodes{clusterNodes{i}(j)}.connections{k}}.connections=tmpVessConn;
        end
        nodes2Del=[nodes2Del,clusterNodes{i}(j)];
    end
end
nodes2Del=unique(sort(nodes2Del));

% delete and shift nodes
shift=zeros(1,SS.NodesCount);
for i=1:length(nodes2Del)
    shift(nodes2Del(i):end)=shift(nodes2Del(i):end)+1;
end
tmpSSNodes=SS.Nodes;
for i=nodes2Del(1):SS.NodesCount
    if ~ismember(i,nodes2Del)
        tmpSSNodes{i-shift(i)}=tmpSSNodes{i};
    end
end
for i=(SS.NodesCount-length(nodes2Del)+1):SS.NodesCount
    tmpSSNodes{i}={};
end
tmpSSNodes=tmpSSNodes(~cellfun('isempty',tmpSSNodes));
SS.Nodes=tmpSSNodes;
SS.NodesCount=length(tmpSSNodes);
for i=1:SS.NodesCount
    SS.Nodes{i}.name=char(['Node ',num2str(i)]);
end

% update nodes in vessel connections
for i=1:SS.VesselsCount
    SS.Vessels{i}.connections={};
end
for i=1:SS.NodesCount
    for j=1:length(SS.Nodes{i}.connections)
        tmpVessIdx=SS.Nodes{i}.connections{j};
        SS.Vessels{tmpVessIdx}.connections{length(SS.Vessels{tmpVessIdx}.connections)+1}=i;
    end
end

end


function [pairNodes,cluster]=AddNodes(pairNodes,cluster)
for i=1:length(cluster)
    idx=find(pairNodes==cluster(i));
    if ~isempty(idx)
        [I,J]=ind2sub(size(pairNodes),idx);
        for j=1:length(I)
            cluster=[cluster,pairNodes(I(j),1),pairNodes(I(j),2)];
            pairNodes(I(j),1)=0;
            pairNodes(I(j),2)=0;
        end
        pairNodes(all(pairNodes==0,2),:)=[];
        cluster=unique(sort(cluster));
        [pairNodes,cluster]=AddNodes(pairNodes,cluster);
    end
end
end
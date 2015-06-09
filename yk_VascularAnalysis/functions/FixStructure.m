function S=FixStructure(S)

% This function fixes errors of node-vessel connectivity and vessel
% numeratiion. It reindexes node and vessel number; reconnect vessel to node
% according to the smallest distance, if connection missed; then reassign
% the connection of node to vessel. The vessel to node connection is
% ordered as start point to node then end point to node.


% correct node index if input is in string format, starting count is 0
if ischar(S.Nodes{1}.locationInMicrons)
    for i=1:length(S.Nodes)
        tmpNode=textscan(S.Nodes{i}.name,'%s %d,');
        S.Nodes{i}.name=char(['Node ',num2str(tmpNode{2}+1)]);
    end
end

diffNodeNum=zeros(1,length(S.Nodes));
tmpS=S;
for i=1:length(S.Nodes)
    tmpS.Nodes{i}.connections={}; % clear connection of node to vessel
    tmpNode=textscan(S.Nodes{i}.name,'%s %d,');
    % reindex node number
    if tmpNode{2}~=i
        diffNodeNum(i)=i-tmpNode{2};
        tmpS.Nodes{i}.name=char(['Node ',num2str(i)]);
    end
end
S=tmpS;

nodes=cell(1,length(S.Nodes));
for i=1:length(S.Nodes)
    if ~ischar(S.Nodes{i}.locationInMicrons)
        nodes{i}=S.Nodes{i}.locationInMicrons;
    else
        tmpLoc=sscanf(S.Nodes{i}.locationInMicrons,'%f%s');
        S.Nodes{i}.locationInMicrons=cell(1,3);
        for j=1:3
            nodes{i}{j}=tmpLoc(2*j-1);
            S.Nodes{i}.locationInMicrons{j}=tmpLoc(2*j-1);
        end
    end
end

for i=1:length(S.Vessels)
    % fix string format
    if ischar(S.Vessels{i}.micronEndPoint)
        tmpLoc1=sscanf(S.Vessels{i}.micronEndPoint,'%f%s');
        tmpLoc2=sscanf(S.Vessels{i}.micronStartPoint,'%f%s');
        S.Vessels{i}.micronEndPoint=cell(1,3);
        S.Vessels{i}.micronStartPoint=cell(1,3);
        for j=1:3
            S.Vessels{i}.micronEndPoint{j}=tmpLoc1(2*j-1);
            S.Vessels{i}.micronStartPoint{j}=tmpLoc2(2*j-1); 
        end
        for j=1:length(S.Vessels{i}.connections)
            tmpName=textscan(S.Vessels{i}.connections{j},'%s %d,');
            S.Vessels{i}.connections{j}=tmpName{2}+1;
        end
    end
    
    % reindex vessel number
    S.Vessels{i}.name=char(['Line ',num2str(i)]);
    
    % case 1: vessel connects to more than 2 nodes
    
    if length(S.Vessels{i}.connections)>2
        fprintf('Vessel %d has more than 2 nodes\n',i);
        
    % case 2: vessel connects to 2 nodes
    % assumed vessel connects to the right nodes; only reindex connection
    % number after node number reindexing
        
    elseif length(S.Vessels{i}.connections)==2
        for j=1:2
            tmpNodeIdx=S.Vessels{i}.connections{j};
            
            if diffNodeNum(tmpNodeIdx)~=0
                S.Vessels{i}.connections{j}=tmpNodeIdx+diffNodeNum(tmpNodeIdx);
            end
        end
        % bring node connected to start point to the first slot
        tmpNode=S.Nodes{S.Vessels{i}.connections{2}}.locationInMicrons;
        tmpPts={S.Vessels{i}.micronStartPoint,S.Vessels{i}.micronEndPoint};
        ptNum=findSmallestDistNode(tmpNode,tmpPts);
        if ptNum==1
            tmpMemo=S.Vessels{i}.connections{2};
            S.Vessels{i}.connections{2}=S.Vessels{i}.connections{1};
            S.Vessels{i}.connections{1}=tmpMemo;
        end
        
    % case 3: vessel connects to either nothing or one node
    else
        if isempty(S.Vessels{i}.connections{1})
            % find node with the smallest distance to start point
            nodeNum1=findSmallestDistNode(S.Vessels{i}.micronStartPoint,nodes);
            S.Vessels{i}.connections{1}=nodeNum1;
            % find node with the smallest distance to end point
            nodeNum2=findSmallestDistNode(S.Vessels{i}.micronEndPoint,nodes);
            S.Vessels{i}.connections{2}=nodeNum2;
        else
            % reindex the connected node, and determine if it connects the
            % start or end point
            tmpNodeIdx=S.Vessels{i}.connections{1};
            if diffNodeNum(tmpNodeIdx)~=0
                S.Vessels{i}.connections{1}=tmpNodeIdx+diffNodeNum(tmpNodeIdx);
            end
            tmpNode=S.Nodes{S.Vessels{i}.connections{1}}.locationInMicrons;
            tmpPts={S.Vessels{i}.micronStartPoint,S.Vessels{i}.micronEndPoint};
            ptNum=findSmallestDistNode(tmpNode,tmpPts);
            % node closer to start point
            if ptNum==1
                nodeNum=findSmallestDistNode(S.Vessels{i}.micronEndPoint,nodes);
                S.Vessels{i}.connections{2}=nodeNum;
                % node closer to end point
            else
                S.Vessels{i}.connections{2}=S.Vessels{i}.connections{1};
                nodeNum=findSmallestDistNode(S.Vessels{i}.micronStartPoint,nodes);
                S.Vessels{i}.connections{1}=nodeNum;
            end
        end
    end
    
    % reassign the connection of node to vessel
    for j=1:2
        nodeIdx=S.Vessels{i}.connections{j};
        tmpL=length(S.Nodes{nodeIdx}.connections);
        S.Nodes{nodeIdx}.connections{tmpL+1}=i;
    end
end
end

function nodeNum=findSmallestDistNode(pt,nodes)
% pt and nodes are in cell format
distList=inf(1,length(nodes));
for x=1:length(nodes)
    pairedPts=[pt{1},pt{2},pt{3};nodes{x}{1},nodes{x}{2},nodes{x}{3}];
    distList(x)=pdist(pairedPts,'euclidean');
end
[smallestDist,nodeNum]=min(distList);
end

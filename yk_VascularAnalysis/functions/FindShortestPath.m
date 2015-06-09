function spathVessIdx=FindShortestPath(S,stalledNodeIdx,dstnNodeIdx,method)
% Method 0 - Branching Number
% Method 1 - Vessel Length

if method==0
    adjMtx=buildAdjMatrix(S,0);
    [cost,nodePath]=dijkstra(adjMtx,adjMtx,stalledNodeIdx,dstnNodeIdx);
elseif method==1
    adjMtx0=buildAdjMatrix(S,0);
    adjMtx1=buildAdjMatrix(S,1);
    [cost,nodePath]=dijkstra(adjMtx0,adjMtx1,stalledNodeIdx,dstnNodeIdx);
end

[minCost,minIdx]=min(cost);
spathNodeIdx=nodePath{minIdx};
% spathNodeIdx=[stalledNodeIdx(1),spathNodeIdx,PANodeIdx(minIdx)];

spathVessIdx=zeros(1,length(spathNodeIdx)-1);
for n=1:length(spathNodeIdx)-1
    vessIdxList1=[];
    vessIdxList2=[];
    for m=1:length(S.Nodes{spathNodeIdx(n)}.connections)
        vessIdxList1(m)=S.Nodes{spathNodeIdx(n)}.connections{m};
    end
    for m=1:length(S.Nodes{spathNodeIdx(n+1)}.connections)
        vessIdxList2(m)=S.Nodes{spathNodeIdx(n+1)}.connections{m};
    end
    tmpIntersection=intersect(vessIdxList1,vessIdxList2);
    spathVessIdx(n)=tmpIntersection(1);
end
end
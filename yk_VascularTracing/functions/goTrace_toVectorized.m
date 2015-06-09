function v= goTrace_toVectorized(s)
%Converts a structure exported from go tracer into a vectorized structure 
%with the same format as the output of vida vectorized structure v differs
%from the structure of vida output in the following ways:

        % v.Vertices has dummmy fields AllLabels AllConfidences AllNotes and All
        % Radii because this inforamtion is not available in the go trace
        % exported structure s.
        %
        % v.Strands has a dummy the Active value because this is not
        % provided in S
        %
        % v.maskSize is a dummy field(0,0,0) because it is not provided
        % in S
        
        
%convert all vessels into vec vessels
sV=s.Vessels;
v.Strands(1:length(sV))=struct;
%Dummy field, not specified in go trace structure
v.maskSize=[0,0,0];
%startpoint(vec), end point(vec), line path(vector of cord strings)

%build vector of nodes
nodes=zeros(length(s.Nodes),3);
ends=zeros(length(s.Nodes),1);
junc=zeros(length(s.Nodes),1);
free=zeros(length(s.Nodes),1);
%Make sure the cell array is always larger than needed to avoid out of
%bounds error.
strandInd=cell(3*length(s.Nodes),1);
nInd=1;

h=waitbar(0,'Export to GoTracer in Progress...');
maxLengthWaitBar=length(sV);

for ind= 1:length(sV)
    
    if (mod(ind,100)==0)
        waitbar(ind/maxLengthWaitBar);
    end
    
    %Deal with the start point
    %search if node exists already
    coord=cellToVec(sV{ind}.startPoint);
    [existsS,locS]=ismember(coord,nodes,'rows');
    
    if existsS
       %This is a junction node.
       v.Strands(ind).StartVertexIndex=locS;
       start=locS;
       strandInd{locS}=[strandInd{locS},ind];
       junc(locS)=1; free(locS)=0;
    else 
        v.Strands(ind).StartVertexIndex=nInd;
        nodes(nInd,:)=coord;
        %This is a free endpoint.
        ends(nInd)=1; free(nInd)=1;
        strandInd{nInd}=[strandInd{nInd},ind];
        start=nInd;
        nInd=nInd+1;
    end
    
    
    %Deal with the middle
    midI=nInd;
    %Deal with the cases where some of the points are repeated. 
    for pt=1:(length(sV{ind}.linePath))
        cTemp=str2num(sV{ind}.linePath{pt});
        strandInd{nInd}=[strandInd{nInd},ind];
        if ~ismember(cTemp,nodes,'rows')
            nodes(nInd,:)=cTemp;
            nInd=nInd+1;
        end
    end
    midE=nInd-1;
    
    %Deal with the end
    coord=cellToVec(sV{ind}.endPoint);
    [existsE,locE]=ismember(coord,nodes,'rows');
    
    if existsE
       %This is a junction point.
       v.Strands(ind).EndVertexIndex=locE;
       ending=locE;
       %Deal with the fact that end point is sometimes included in the linePath
       if midE==locE
          midE=midE-1; 
       else
           strandInd{locE}=[strandInd{locE},ind];
       end
       junc(locE)=1; free(locE)=0;
    else 
        %This is a free endpoint.
        v.Strands(ind).EndVertexIndex=nInd;
        nodes(nInd,:)=coord;
        ends(nInd)=1; free(nInd)=1;
        strandInd{nInd}=[strandInd{nInd},ind];
        ending=nInd;
        nInd=nInd+1;
    end
    v.Strands(ind).InteriorVertices=midI:midE;
    v.Strands(ind).StartToEndIndices=[start,(midI:midE),ending];
    
    %pad with zeros for efficiency
    if nInd>length(nodes)
        nodes=[nodes; zeros(length(nodes),3)];
        ends=[ends; zeros(length(nodes),1)];
        junc=[junc; zeros(length(nodes),1)];
        free=[free; zeros(length(nodes),1)];
        strandInd=[strandInd; cell(length(nodes),1)];
    end
    v.Strands(ind).Active=-1;
end
%Find the start vertex neighbor strands and end vertex neighbor strands
for ind=1:length(sV)
    v.Strands(ind).StartVertexNeighborStrands=strandInd{v.Strands(ind).StartVertexIndex};
    v.Strands(ind).EndVertexNeighborStrands=strandInd{v.Strands(ind).EndVertexIndex};
end

%Transfer all information about nodes to the structure.
cutoff=find(ismember(nodes,[0,0,0]),1);
v.Vertices.AllVerts=nodes(1:(cutoff-1),:);
v.Vertices.AllStrandEndPoints=ends(1:(cutoff-1));
v.Vertices.JunctionPoints=junc(1:(cutoff-1));
v.Vertices.FreeEndPoints=free(1:(cutoff-1));
v.Vertices.StrandIndices=strandInd(1:(cutoff-1));
%Dummy fields which cannot be calculated from S
v.Vertices.AllRadii=zeros(cutoff-1,1);
v.Vertices.AllLabels=v.Vertices.AllRadii;
v.Vertices.AllConfidences=v.Vertices.AllRadii;
v.Vertices.AllNotes=cell(cutoff-1,1);

delete(h);
end

function vec=cellToVec(c)
%converts the coordinates in the cell to a vector
vec=zeros(1,length(c));
for i=1:length(c)
    vec(i)=c{i};
end
end


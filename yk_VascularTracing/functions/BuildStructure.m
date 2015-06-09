function SS=BuildStructure(S)

SS=struct;
SS.Nodes={};
SS.NodesCount=0;
SS.StalledVesselCount=0;
SS.Vessels={};
SS.VesselsCount=0;

Nodes=[];
for i=1:length(S)
    Nodes=[Nodes;S{i}(1,:);S{i}(end,:)];
end
Nodes=unique(Nodes,'rows');

for i=1:size(Nodes,1)
    SS.Nodes{i}.adjacentconnections{1}=[];
    SS.Nodes{i}.class=char('Node');
    SS.Nodes{i}.connections={};
    for j=1:3
        SS.Nodes{i}.location{j}=Nodes(i,j);
        SS.Nodes{i}.locationInMicrons{j}=0;
    end
    SS.Nodes{i}.name=char(['Node ',num2str(i)]);
    SS.Nodes{i}.type=char('Not Defined');
end
SS.NodesCount=size(Nodes,1);

for i=1:length(S)
    SS.Vessels{i}.adjacentconnections{1}=[];
    SS.Vessels{i}.class=char('Vessel');
    SS.Vessels{i}.connections={};
    StartNEndNodes=[S{i}(1,:);S{i}(end,:)];
    flag=ismember(Nodes,StartNEndNodes,'rows');
    Vessel2Node=find(flag);
    if length(Vessel2Node)==1
        SS.Vessels{i}.connections{1}=Vessel2Node;
        tmpL=length(SS.Nodes{Vessel2Node}.connections);
        SS.Nodes{Vessel2Node}.connections{tmpL+1}=i;
    else
        for j=1:2
            SS.Vessels{i}.connections{j}=Vessel2Node(j);
            tmpL=length(SS.Nodes{Vessel2Node(j)}.connections);
            SS.Nodes{Vessel2Node(j)}.connections{tmpL+1}=i;
        end
    end
    for j=1:3
        SS.Vessels{i}.endPoint{j}=S{i}(end-1,j);
    end
    SS.Vessels{i}.lengthInMicrons=0;
    SS.Vessels{i}.leukocyte=char('Not Defined');
    if length(S{i})>4
        for j=1:length(S{i})-4
            tmpLP=[num2str(S{i}(j+2,1),'%10.6f'),', ',num2str(S{i}(j+2,2),...
                '%10.6f'),', ',num2str(S{i}(j+2,3),'%10.6f')];
            SS.Vessels{i}.linePath{j}=char(tmpLP);
            tmpLP2=[num2str(0,'%10.6f'),', ',num2str(0,'%10.6f'),', ',...
                num2str(0,'%10.6f')];
            SS.Vessels{i}.linePathInMicrons{j}=char(tmpLP2);
        end
    else
        tmpLP=(S{i}(2,:)+S{i}(end-1,:))/2;
        tmpLP=[num2str(tmpLP(1),'%10.6f'),', ',num2str(tmpLP(2),...
                '%10.6f'),', ',num2str(tmpLP(3),'%10.6f')];
        SS.Vessels{i}.linePath{1}=char(tmpLP);
    end
    for j=1:3
        SS.Vessels{i}.micronEndPoint{j}=0;
        SS.Vessels{i}.micronStartPoint{j}=0;
    end
    SS.Vessels{i}.name=char(['Line ',num2str(i)]);
    SS.Vessels{i}.stalledState=char('Not Defined');
    for j=1:3
        SS.Vessels{i}.startPoint{j}=S{i}(2,j);
    end
    SS.Vessels{i}.type=char('Not Defined');
end
SS.VesselsCount=length(S);

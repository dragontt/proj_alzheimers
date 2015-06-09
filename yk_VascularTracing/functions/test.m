function D=test(SS)
D=NaN(SS.VesselsCount,2);
for i=1:SS.VesselsCount
    nodeList=SS.Vessels{i}.connections;
    spt1=SS.Vessels{i}.startPoint{1};
    spt2=SS.Vessels{i}.startPoint{2};
    spt3=SS.Vessels{i}.startPoint{3};
    ept1=SS.Vessels{i}.endPoint{1};
    ept2=SS.Vessels{i}.endPoint{2};
    ept3=SS.Vessels{i}.endPoint{3};
    for j=1:length(nodeList)
        node1=SS.Nodes{nodeList{j}}.location{1};
        node2=SS.Nodes{nodeList{j}}.location{2};
        node3=SS.Nodes{nodeList{j}}.location{3};
        d2s=pdist([node1,node2,node3;spt1,spt2,spt3]);
        d2e=pdist([node1,node2,node3;ept1,ept2,ept3]);
        if d2s<d2e
            D(i,j)=d2s;
        else
            D(i,j)=d2e;
        end
    end
end
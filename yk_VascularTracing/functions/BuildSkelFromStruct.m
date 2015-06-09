function S=BuildSkelFromStruct(SS)
% This function builds skeleton segments in cell array from structure

S=cell(1,SS.VesselsCount);
for i=1:SS.VesselsCount
    S{i}=zeros(length(SS.Vessels{i}.linePath)+4,3);
    if length(SS.Vessels{i}.connections)==1
        for j=1:3
            S{i}(1,j)=SS.Nodes{SS.Vessels{i}.connections{1}}.location{j};
            S{i}(end,j)=SS.Nodes{SS.Vessels{i}.connections{1}}.location{j};
            S{i}(2,j)=SS.Vessels{i}.startPoint{j};
            S{i}(end-1,j)=SS.Vessels{i}.endPoint{j};
        end
    else
        startPt=zeros(1,3);
        node1=zeros(1,3); node2=node1;
        for j=1:3
            startPt(j)=SS.Vessels{i}.startPoint{j};
            node1(j)=SS.Nodes{SS.Vessels{i}.connections{1}}.location{j};
            node2(j)=SS.Nodes{SS.Vessels{i}.connections{2}}.location{j};
        end
        tmpDistPair=pdist2(startPt,[node1;node2]);
        for j=1:3
            if tmpDistPair(1)<tmpDistPair(2)
                S{i}(1,j)=SS.Nodes{SS.Vessels{i}.connections{1}}.location{j};
                S{i}(end,j)=SS.Nodes{SS.Vessels{i}.connections{2}}.location{j};
            else
                S{i}(1,j)=SS.Nodes{SS.Vessels{i}.connections{2}}.location{j};
                S{i}(end,j)=SS.Nodes{SS.Vessels{i}.connections{1}}.location{j};
            end
            S{i}(2,j)=SS.Vessels{i}.startPoint{j};
            S{i}(end-1,j)=SS.Vessels{i}.endPoint{j};
        end
    end
    for j=3:length(SS.Vessels{i}.linePath)+2
        S{i}(j,:)=str2num(SS.Vessels{i}.linePath{j-2});
    end
end


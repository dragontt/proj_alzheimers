function A=buildAdjMatrix(S,method)
% This function build an adjacency matrix from vessel skeleton information
%
% Method 0 - Branching Number
%        1 - Vessel Length

A=zeros(S.NodesCount);
if method==0
    for n=1:S.NodesCount
        tmpAdjNodes=[];
        for m=1:length(S.Nodes{n}.connections)
            tmpVessIdx=S.Nodes{n}.connections{m};
            if S.Vessels{tmpVessIdx}.connections{1}==n
                tmpAdjNodes(m)=S.Vessels{tmpVessIdx}.connections{2};
            else
                tmpAdjNodes(m)=S.Vessels{tmpVessIdx}.connections{1};
            end
        end
        for m=1:length(tmpAdjNodes)
            A(n,tmpAdjNodes(m))=1;
            A(tmpAdjNodes(m),n)=1;
        end
    end
elseif method==1
    for n=1:S.NodesCount
        tmpAdjNodes=[];
        tmpAdjWt=[];
        for m=1:length(S.Nodes{n}.connections)
            tmpVessIdx=S.Nodes{n}.connections{m};
            tmpAdjWt(m)=S.Vessels{tmpVessIdx}.lengthInMicrons;
            if S.Vessels{tmpVessIdx}.connections{1}==n
                tmpAdjNodes(m)=S.Vessels{tmpVessIdx}.connections{2};
            else
                tmpAdjNodes(m)=S.Vessels{tmpVessIdx}.connections{1};
            end
        end
        for m=1:length(tmpAdjNodes)
            A(n,tmpAdjNodes(m))=tmpAdjWt(m);
            A(tmpAdjNodes(m),n)=tmpAdjWt(m);
        end
    end
end


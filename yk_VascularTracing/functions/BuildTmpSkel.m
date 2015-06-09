function [SS,maskDel]=BuildTmpSkel(S,flagDelShortSkel,threshold)

% This function builds skeleton information into structure class
%
% S  - vessel skeleton in array
% SS - skeleton information in structure
% flagDelShortSkel - determine if need to delete short skeleton segment

if nargin<2
    flagDelShortSkel=0;
    threshold=5;
elseif nargin<3
    threshold=5;
end

% build temporary skel structure
for i=1:length(S)
    SS(i).SkelNum=i;
    SS(i).SkelPts=S{i};
    SS(i).StartPt=S{i}(1,:);
    SS(i).EndPt=S{i}(size(S{i},1),:);
    SS(i).SkelConn2StartPt=[];
    SS(i).SkelConn2EndPt=[];
end
for i=1:length(SS)
    for j=1:length(SS)
        if i~=j
            if SS(i).StartPt==SS(j).StartPt | SS(i).StartPt==SS(j).EndPt
                SS(i).SkelConn2StartPt=[SS(i).SkelConn2StartPt,j];
            elseif SS(i).EndPt==SS(j).StartPt | SS(i).EndPt==SS(j).EndPt
                SS(i).SkelConn2EndPt=[SS(i).SkelConn2EndPt,j];
            end
        end
    end
end

% delete short skel segement if flag is on
maskDel=[];
if flagDelShortSkel==1
    for i=1:length(SS)
        if isempty(SS(i).SkelConn2StartPt) || isempty(SS(i).SkelConn2EndPt)
            if size(S{i},1)<threshold
                maskDel=[maskDel,i];
            end
        end
    end
end
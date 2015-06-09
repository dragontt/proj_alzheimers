function [S,SS]=MergeSkel(S,SS,maskDel)
% This function merges skeletons with only one other branch connected.

if nargin==3
    for i=1:length(maskDel)
        S{maskDel(i)}={};
        for j=1:length(SS)
            [flag,idx]=ismember(maskDel(i),SS(j).SkelConn2StartPt);
            if flag
                SS(j).SkelConn2StartPt(idx)=[];
            end
            [flag,idx]=ismember(maskDel(i),SS(j).SkelConn2EndPt);
            if flag
                SS(j).SkelConn2EndPt(idx)=[];
            end
        end
    end
end

while true
    countMerge=0;
    for i=1:length(S)
        ii=SS(i).SkelConn2StartPt;
        if length(ii)==1
            if SS(ii).SkelConn2StartPt==i
                % StartPt to StartPt
                S{i}=[fliplr((S{i})')';S{ii}(2:end,:)];
                S{ii}=[];
                SS(i).SkelConn2StartPt=SS(i).SkelConn2EndPt;
                SS(i).SkelConn2EndPt=SS(ii).SkelConn2EndPt;
                SS(ii).SkelConn2StartPt=[];
                SS(ii).SkelConn2EndPt=[];
                countMerge=countMerge+1;
            elseif SS(ii).SkelConn2EndPt==i
                % StartPt to EndPt
                S{i}=[S{ii};S{i}(2:end,:)];
                S{ii}=[];
                SS(i).SkelConn2StartPt=SS(ii).SkelConn2StartPt;
                SS(ii).SkelConn2StartPt=[];
                SS(ii).SkelConn2EndPt=[];
                countMerge=countMerge+1;
            end
        end
        ii=SS(i).SkelConn2EndPt;
        if length(ii)==1
            if SS(ii).SkelConn2StartPt==i
                % EndPt to StartPt
                S{i}=[S{i};S{ii}(2:end,:)];
                S{ii}=[];
                SS(i).SkelConn2EndPt=SS(ii).SkelConn2EndPt;
                SS(ii).SkelConn2StartPt=[];
                SS(ii).SkelConn2EndPt=[];
                countMerge=countMerge+1;
            elseif SS(ii).SkelConn2EndPt==i
                % EndPt to EndPt
                S{i}=[S{ii}(1:end-1,:);fliplr((S{i})')'];
                S{ii}=[];
                SS(i).SkelConn2EndPt=SS(i).SkelConn2StartPt;
                SS(i).SkelConn2StartPt=SS(ii).SkelConn2StartPt;
                SS(ii).SkelConn2StartPt=[];
                SS(ii).SkelConn2EndPt=[];
                countMerge=countMerge+1;
            end
        end
    end
    
    % Update S and SS
    S=S(~cellfun('isempty',S));
    [SS,~]=BuildTmpSkel(S,0);
    
    % Break when no more skeleton merge occurs
    if countMerge==0
        break;
    end
end
S=S(~cellfun('isempty',S));




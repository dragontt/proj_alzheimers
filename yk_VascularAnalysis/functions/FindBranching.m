function [spathStalled,spathUnstalled]=FindBranching(S)

% This function finds stall branching from stalled vessel to ascending
% venule and penetrating arteriole
%
% spathStalled Row 1 - The shortest path based on branching number
% spathStalled Row 2 - The shortest path bsaed on length of vessel segment
%
% Notes: as stall blocks the capillary blood flow, the connection of two
% nodes to a stalled vessel is empty.

% Find vessel indices
stalledVessIdx=[];
unstalledVessIdx=[];
PAVessIdx=[];
AVVessIdx=[];
for i=1:length(S.Vessels)
    if strcmp(S.Vessels{i}.stalledState,'Stalled')
        stalledVessIdx=[stalledVessIdx,i];
    elseif strcmp(S.Vessels{i}.type,'Not Defined') || strcmp(S.Vessels{i}.type,'Capillary')
        unstalledVessIdx=[unstalledVessIdx,i];
    elseif strcmp(S.Vessels{i}.type,'Penetrating Arteriole')
        PAVessIdx=[PAVessIdx,i];
    elseif strcmp(S.Vessels{i}.type,'Ascending Venule')
        AVVessIdx=[AVVessIdx,i];
    end
end

% Get node indices from vessel indices
stalledNodeIdx=zeros(1,length(stalledVessIdx)*2);
unstalledNodeIdx=zeros(1,length(unstalledVessIdx)*2);
PANodeIdx=zeros(1,length(PAVessIdx)*2);
AVNodeIdx=zeros(1,length(AVVessIdx)*2);
for i=1:length(stalledVessIdx)
    stalledNodeIdx(2*i-1)=S.Vessels{stalledVessIdx(i)}.connections{1};
    stalledNodeIdx(2*i)=S.Vessels{stalledVessIdx(i)}.connections{2};
    % Delete node-to-stalled-vessel connection
    for j=-1:0
        tmpIdx=stalledNodeIdx(2*i+j);
        for k=1:length(S.Nodes{tmpIdx}.connections)
            if S.Nodes{tmpIdx}.connections{k}==stalledVessIdx(i)
                S.Nodes{tmpIdx}.connections{k}={};
            end
        end
        S.Nodes{tmpIdx}.connections=...
            S.Nodes{tmpIdx}.connections(~cellfun('isempty',S.Nodes{tmpIdx}.connections));
    end
end
for i=1:length(unstalledVessIdx)
    unstalledNodeIdx(2*i-1)=S.Vessels{unstalledVessIdx(i)}.connections{1};
    unstalledNodeIdx(2*i)=S.Vessels{unstalledVessIdx(i)}.connections{2};
end
for i=1:length(PAVessIdx)
    PANodeIdx(2*i-1)=S.Vessels{PAVessIdx(i)}.connections{1};
    PANodeIdx(2*i)=S.Vessels{PAVessIdx(i)}.connections{2};
end
for i=1:length(AVVessIdx)
    AVNodeIdx(2*i-1)=S.Vessels{AVVessIdx(i)}.connections{1};
    AVNodeIdx(2*i)=S.Vessels{AVVessIdx(i)}.connections{2};
end

% Find shortest path based on the branching number
spathStalled=cell(2,length(stalledVessIdx));
spathUnstalled=cell(2,length(unstalledVessIdx));
for k=1:2
    parfor i=1:length(stalledVessIdx)
        spathStalled{k,i}.StalledVesselIndex=stalledVessIdx(i);
        % compute smallest path using dijsktra algorithm
        % assumption: shortest path to the nearest PA is the priority
        spath2PAVessIdx1=FindShortestPath(S,stalledNodeIdx(i*2-1),PANodeIdx,k-1);
        spath2PAVessIdx2=FindShortestPath(S,stalledNodeIdx(i*2),PANodeIdx,k-1);
        if length(spath2PAVessIdx1)<=length(spath2PAVessIdx2)
            spath2PAVessIdx=spath2PAVessIdx1;
            spath2AVVessIdx=FindShortestPath(S,stalledNodeIdx(i*2),AVNodeIdx,0);
            spath2PANodeIdx=stalledNodeIdx(i*2-1);
            spath2AVNodeIdx=stalledNodeIdx(i*2);
        else
            spath2PAVessIdx=spath2PAVessIdx2;
            spath2AVVessIdx=FindShortestPath(S,stalledNodeIdx(i*2-1),AVNodeIdx,0);
            spath2PANodeIdx=stalledNodeIdx(i*2);
            spath2AVNodeIdx=stalledNodeIdx(i*2-1);
        end
        spathStalled{k,i}.Path2PAVesselIndices=spath2PAVessIdx;
        spathStalled{k,i}.Path2AVVesselIndices=spath2AVVessIdx;
        spathStalled{k,i}.Path2PANodeIndex=spath2PANodeIdx;
        spathStalled{k,i}.Path2AVNodeIndex=spath2AVNodeIdx;
        
        %     % update skeleton color mark
        %     Skel=updateSkelColor(Skel,spath2PAVessIdx,spath2AVVessIdx,stalledVessIdx,k-1);
    end
    
    parfor i=1:length(unstalledVessIdx)
        spathUnstalled{k,i}.UnstalledVesselIndex=unstalledVessIdx(i);
        % compute smallest path using dijsktra algorithm
        % assumption: shortest path to the nearest PA is the priority
        unspath2PAVessIdx1=FindShortestPath(S,unstalledNodeIdx(i*2-1),PANodeIdx,k-1);
        unspath2PAVessIdx2=FindShortestPath(S,unstalledNodeIdx(i*2),PANodeIdx,k-1);
        if length(unspath2PAVessIdx1)<=length(unspath2PAVessIdx2)
            unspath2PAVessIdx=unspath2PAVessIdx1;
            unspath2AVVessIdx=FindShortestPath(S,unstalledNodeIdx(i*2),AVNodeIdx,0);
            unspath2PANodeIdx=unstalledNodeIdx(i*2-1);
            unspath2AVNodeIdx=unstalledNodeIdx(i*2);
        else
            unspath2PAVessIdx=unspath2PAVessIdx2;
            unspath2AVVessIdx=FindShortestPath(S,unstalledNodeIdx(i*2-1),AVNodeIdx,0);
            unspath2PANodeIdx=unstalledNodeIdx(i*2);
            unspath2AVNodeIdx=unstalledNodeIdx(i*2-1);
        end
        spathUnstalled{k,i}.Path2PAVesselIndices=unspath2PAVessIdx;
        spathUnstalled{k,i}.Path2AVVesselIndices=unspath2AVVessIdx;
        spathUnstalled{k,i}.Path2PANodeIndex=unspath2PANodeIdx;
        spathUnstalled{k,i}.Path2AVNodeIndex=unspath2AVNodeIdx;
    end
end
end







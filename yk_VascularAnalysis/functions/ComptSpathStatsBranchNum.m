function [spathStats,spathList]=ComptSpathStatsBranchNum(spath,numBins,maxBranchNum)
% This function outputs histogram of stall branching number to PA and AV
%
% spathStats:
% Column 1 - Branching number index;
% Column 2 - PA counts;
% Column 3 - AV counts;
% Column 4 - pct of PA counts;
% Column 5 - pct of AV counts;
%
% Last row counts branching numeber >= maxBranchNum

if nargin<2
    numBins=20;
    maxBranchNum=20;
elseif nargin<3
    maxBranchNum=20;
end

widthBin=maxBranchNum/numBins;
if widthBin<1
    warning('Maximum branching number cannot be smaller than number of bins!');
    return;
end
if round(widthBin)-widthBin~=0 
    warning('Number of bins needs to be a multiplier of maximum branching number!');
    return;
end

spathStats=zeros(maxBranchNum,5);
spathStats(:,1)=1:maxBranchNum;
countEmpty1=0;
countEmpty2=0;

for i=1:length(spath)
    if length(spath{i}.Path2PAVesselIndices)>=maxBranchNum
        spathStats(maxBranchNum,2)=spathStats(maxBranchNum,2)+1;
    else
        if ~isempty(spath{i}.Path2PAVesselIndices)
            spathStats(length(spath{i}.Path2PAVesselIndices),2)=...
                spathStats(length(spath{i}.Path2PAVesselIndices),2)+1;
        else
            countEmpty1=countEmpty1+1;
        end
    end
    
    if length(spath{i}.Path2AVVesselIndices)>=maxBranchNum
        spathStats(maxBranchNum,3)=spathStats(maxBranchNum,3)+1;
    else
        if ~isempty(spath{i}.Path2AVVesselIndices)
            spathStats(length(spath{i}.Path2AVVesselIndices),3)=...
                spathStats(length(spath{i}.Path2AVVesselIndices),3)+1;
        else
            countEmpty2=0;
        end
    end
end

spathStats(:,4)=spathStats(:,2)/(length(spath)-countEmpty1);
spathStats(:,5)=spathStats(:,3)/(length(spath)-countEmpty2);

tmp=zeros(size(spathStats,1)/widthBin,5);
if widthBin>1
    for i=1:size(spathStats,1)/widthBin
        tmp(i,1)=spathStats(i*2,1);
        tmp(i,2)=spathStats(i*2-1,2)+spathStats(i*2,2);
        tmp(i,3)=spathStats(i*2-1,3)+spathStats(i*2,3);
        tmp(i,4)=spathStats(i*2-1,4)+spathStats(i*2,4);
        tmp(i,5)=spathStats(i*2-1,5)+spathStats(i*2,5);
    end
    spathStats=tmp;
end

spathList=zeros(2,length(spath));
for i=1:length(spath)
    spathList(1,i)=length(spath{i}.Path2PAVesselIndices);
    spathList(2,i)=length(spath{i}.Path2AVVesselIndices);
end


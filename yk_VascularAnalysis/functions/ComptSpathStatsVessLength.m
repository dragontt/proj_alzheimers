function [spathStats,spathList]=ComptSpathStatsVessLength(spath,S,numBins,maxLength)
% This function outputs histogram of stall branching number to PA and AV
%
% Column 1 - Vessel length index;
% Column 2 - PA counts;
% Column 3 - AV counts;
% Column 4 - pct of PA counts;
% Column 5 - pct of AV counts;
%
% Last row counts vessel length (in microns) >= maxLength

if nargin<3
    numBins=10;
    maxLength=1000;
end

lengthList=zeros(2,length(spath));
for i=1:size(lengthList,2)
    for j=1:length(spath{i}.Path2PAVesselIndices)
        tmpIdx=spath{i}.Path2PAVesselIndices(j);
        lengthList(1,i)=lengthList(1,i)+S.Vessels{tmpIdx}.lengthInMicrons;
    end
    for j=1:length(spath{i}.Path2AVVesselIndices)
        tmpIdx=spath{i}.Path2AVVesselIndices(j);
        lengthList(2,i)=lengthList(2,i)+S.Vessels{tmpIdx}.lengthInMicrons;
    end
end

widthBin=maxLength/numBins;
spathStats=zeros(numBins,5);
spathStats(:,1)=widthBin:widthBin:maxLength;
countEmpty1=0;
countEmpty2=0;

for i=1:size(lengthList,2)
    if lengthList<=0
        countEmpty1=countEmpty1+1;
    elseif lengthList(1,i)<=widthBin & lengthList>0
        spathStats(1,2)=spathStats(1,2)+1;
    elseif lengthList(1,i)>maxLength-widthBin
        spathStats(numBins,2)=spathStats(numBins,2)+1;
    else
        for j=2:numBins-1
            if lengthList(1,i)>widthBin*(j-1) && lengthList(1,i)<=widthBin*j
                spathStats(j,2)=spathStats(j,2)+1;
            end
        end
    end
    
    if lengthList<=0
        countEmpty2=countEmpty2+1;
    elseif lengthList(2,i)<=widthBin & lengthList>0
        spathStats(1,3)=spathStats(1,3)+1;
    elseif lengthList(2,i)>maxLength-widthBin
        spathStats(numBins,3)=spathStats(numBins,3)+1;
    else
        for j=2:numBins-1
            if lengthList(2,i)>widthBin*(j-1) && lengthList(2,i)<=widthBin*j
                spathStats(j,3)=spathStats(j,3)+1;
            end
        end
    end
end

spathStats(:,4)=spathStats(:,2)/(length(spath)+countEmpty1);
spathStats(:,5)=spathStats(:,3)/(length(spath)+countEmpty2);

spathList=lengthList;

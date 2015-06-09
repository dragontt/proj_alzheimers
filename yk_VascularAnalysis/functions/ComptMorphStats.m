function stats_morph=ComptMorphStats(morphInfo,numBin,minVal,maxVal)
% This function computes the histograms of morphological information of
% blood vessel
% 
% stats contains:
% Column 1 - max value of each morphological measurement
% Column 2 - number of data points in each bin
% Column 3 - percentage of data points in each bin
% Last row is the volume great than (maxVal-widthVal)

widthVal=(maxVal-minVal)/numBin;
stats_morph=zeros(numBin,3);

for i=1:numBin
    stats_morph(i,1)=minVal+widthVal*i;
end

for i=1:size(morphInfo,1)
    if morphInfo(i)<=widthVal+minVal && ~isnan(morphInfo(i))
        stats_morph(1,2)=stats_morph(1,2)+1;
    elseif morphInfo(i)>minVal+maxVal-widthVal && ~isinf(morphInfo(i))
        stats_morph(numBin,2)=stats_morph(numBin,2)+1;
    end
    for j=2:numBin-1
        if morphInfo(i)>minVal+widthVal*(j-1) && morphInfo(i)<=minVal+widthVal*j
            stats_morph(j,2)=stats_morph(j,2)+1;
        end
    end
end

sumCount=sum(stats_morph(:,2));
for i=1:numBin
    stats_morph(i,3)=stats_morph(i,2)/sumCount;
end
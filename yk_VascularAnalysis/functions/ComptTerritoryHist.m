function [stats_stallTerr,stats_unstallTerr]=ComptTerritoryHist(V_tissue,Skel,numBin,maxVol)
% This function computes the histograms of territory volumes of stalled 
% vessel and those of unstalled vessel
% 
% stats contains: 
% Column 1 - max volume (in micron^3) in each range
% Column 2 - number of territory counted within volume (in micron^3) range,
%            which is characterized by numBin and maxVol
% Column 3 - percentage of terriotry
% Last row is the volume greater than (maxVol-widthVol)

countVol=(histc(V_tissue(:),unique(V_tissue(:))))';
countVol=countVol(2:end);

stats_stallTerr=zeros(numBin,3);
stats_unstallTerr=stats_stallTerr;
widthVol=maxVol/numBin;
for i=1:numBin
    stats_stallTerr(i,1)=widthVol*i;
    stats_unstallTerr(i,1)=widthVol*i;
end

for i=1:length(countVol)
    if Skel{2,i}==8
        if countVol(i)<=widthVol
            stats_stallTerr(1,2)=stats_stallTerr(1,2)+1;
        elseif countVol(i)>maxVol-widthVol
            stats_stallTerr(numBin,2)=stats_stallTerr(numBin,2)+1;
        end
        for j=2:numBin-1
            if countVol(i)>widthVol*(j-1) && countVol(i)<=widthVol*j
                stats_stallTerr(j,2)=stats_stallTerr(j,2)+1;
            end
        end
    elseif Skel{2,i}==5 || Skel{2,i}==6 || Skel{2,i}==7
        if countVol(i)<=widthVol
            stats_unstallTerr(1,2)=stats_unstallTerr(1,2)+1;
        elseif countVol(i)>maxVol-widthVol
            stats_unstallTerr(numBin,2)=stats_unstallTerr(numBin,2)+1;
        end
        for j=2:numBin-1
            if countVol(i)>widthVol*(j-1) && countVol(i)<=widthVol*j
                stats_unstallTerr(j,2)=stats_unstallTerr(j,2)+1;
            end
        end
    end
end

sumStallTerr=sum(stats_stallTerr(:,2));
sumUnstallTerr=sum(stats_unstallTerr(:,2));
for i=1:numBin
    stats_stallTerr(i,3)=stats_stallTerr(i,2)/sumStallTerr;
    stats_unstallTerr(i,3)=stats_unstallTerr(i,2)/sumUnstallTerr;
end


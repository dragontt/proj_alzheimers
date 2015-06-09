function [morphInfoStalled,morphInfoUnstalled]=GetMorphInfo(Info,Skel)
% This function computes statistics of morphological information of stalled
% vs. unstalled capillaries
% 
% column 1 - blood vessel index
% column 2 - average diameter
% column 3 - skewness
% column 4 - kurtosis
% column 5 - length
% column 6 - tortuosity
% column 7 - average depth in tissue

numStalled=NaN(size(Skel,2),1);
numUnstalled=numStalled;
for i=1:size(Skel,2)
    if Skel{2,i}==8
        numStalled(i)=i;
    else
        numUnstalled(i)=i;
    end
end
numStalled(any(isnan(numStalled),2))=[];
numUnstalled(any(isnan(numUnstalled),2))=[];

morphInfoStalled=zeros(length(numStalled),7);
morphInfoUnstalled=zeros(length(numUnstalled),7);

for i=1:length(numStalled)
    morphInfoStalled(i,1)=numStalled(i);
    morphInfoStalled(i,2)=Info{numStalled(i)}.AvgDiameter;
    morphInfoStalled(i,3)=Info{numStalled(i)}.Skewness;
    morphInfoStalled(i,4)=Info{numStalled(i)}.Kurtosis;
    morphInfoStalled(i,5)=Info{numStalled(i)}.Length;
    morphInfoStalled(i,6)=Info{numStalled(i)}.Tortuosity;
    morphInfoStalled(i,7)=Info{numStalled(i)}.AvgDepth;
end
for i=1:length(numUnstalled)
    morphInfoUnstalled(i,1)=numUnstalled(i);
    morphInfoUnstalled(i,2)=Info{numUnstalled(i)}.AvgDiameter;
    morphInfoUnstalled(i,3)=Info{numUnstalled(i)}.Skewness;
    morphInfoUnstalled(i,4)=Info{numUnstalled(i)}.Kurtosis;
    morphInfoUnstalled(i,5)=Info{numUnstalled(i)}.Length;
    morphInfoUnstalled(i,6)=Info{numUnstalled(i)}.Tortuosity;
    morphInfoUnstalled(i,7)=Info{numUnstalled(i)}.AvgDepth;
end

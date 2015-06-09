function lengthList=ComputeTotalLength(spath,S)

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
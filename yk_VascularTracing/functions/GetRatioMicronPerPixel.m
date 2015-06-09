function ratioMicronPerPixel=GetRatioMicronPerPixel(S_Raw)

ratioMicronPerPixel=zeros(1,3);
for i=1:3
ratioMicronPerPixel(i)=S_Raw.Nodes{1}.locationInMicrons{i}/S_Raw.Nodes{1}.location{i};
end
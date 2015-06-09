function S=shiftNodes(S)

shiftPix=[-3,-3,0];
for i=1:length(S)
    S{i}(1,:)=S{i}(1,:)+shiftPix;
    S{i}(end,:)=S{i}(end,:)+shiftPix;
end
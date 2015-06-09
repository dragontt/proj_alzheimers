function [S,mask]=combineSubSkel(Sgp,CCgp)
% This function combines skeletons in subvolume and maps them back in
% master volume.

numSkel=0;
for i=1:length(Sgp)
    numSkel=numSkel+length(Sgp{i});
end
counter=0;
S=cell(1,numSkel);
mask=zeros(2,numSkel);
for j=1:length(Sgp)
    for k=1:length(Sgp{j})
        counter=counter+1;
        S{counter}=Sgp{j}{k};
        mask(1,counter)=CCgp{2,j};
        mask(2,counter)=CCgp{4,j};
    end
end
S=S(~cellfun('isempty',S));
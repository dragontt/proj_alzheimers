function [V_path2PA,V_path2AV,V_stall]=GetStalledVessNPathTerritoryVol(V_tissue,Skel)
% This function gets volumn of tissue terriotory along linepathes of
% stalled vessel and shortest pathes to the nearest PA and AV

V_path2PA=[];
V_path2AV=[];
V_stall=[];

for i=1:size(Skel,2)
    if Skel{2,i}==6
        V_path2PA=GetTerritoryVol(V_tissue,i);
    elseif Skel{2,i}==7
        V_path2AV=GetTerritoryVol(V_tissue,i);
    elseif Skel{2,i}==8
        V_stall=GetTerritoryVol(V_tissue,i);
    end
end

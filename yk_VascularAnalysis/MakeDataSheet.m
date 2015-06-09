% This script extract vascular information from analyzed matlab file, and
% make a local data sheet within the same folder.
%
% Data Entry:
% 01. Animal ID
% 02. Animal Type (0-WT, 1-AD)
% 03. Vessel ID 
% 04. Age in days
% 05. Dynamic Type (0-flow, 1-stall)
% 06. Vessel Type
% 07. Treatment
% 08. (Topology) Branching number to penetrating arteriole 
% 09. (Topology) Branching number to ascending venule
% 10. (Topology) Length to penetrating arteriole
% 11. (Topology) Length to ascending venule
% 12. (Morphology) Vessel length
% 13. (Morphology) Average vessel diameter
% 14. (Morphology) Vessel depth
% 15. (Morphology) Vessel tortuosity
% 16. (Morphology) Vessel surface roughness - Skewness

% load mat file
addpath(genpath('./functions/'));
file=struct;
[file.filename,file.pathname]=uigetfile('*.mat','Choose mat file');
load([file.pathname,'/',file.filename]);

% get user input
prompt={'Animal ID:','Animal Type (WT/AD)','Age in Days','Treatment'};
userData=inputdlg(prompt,'Input');

% make data sheet
numEntries=15;
DB=cell(S.VesselsCount,numEntries);

DB(:,1)=userData(1);
if (strcmp(userData{2},'WT')) DB(:,2)={0};
elseif (strcmp(userData{2},'AD')) DB(:,2)={1}; 
end
DB(:,4)={str2double(userData{3})};
DB(:,7)=userData(4);

for i=1:S.VesselsCount
    DB{i,3}=i;
    if (strcmp(S.Vessels{i}.stalledState,'Stalled')) DB{i,5}=1;
    else DB{i,5}=0;
    end
    if (strcmp(S.Vessels{i}.type,'Not Defined') || strcmp(S.Vessels{i}.type,'Capillary'))
        DB{i,6}='Capillary';
    else 
        DB{i,6}=S.Vessels{i}.type;
    end
    DB{i,12}=morph{1,i}.Length;
    DB{i,13}=morph{1,i}.AvgDiameter;
    DB{i,14}=morph{1,i}.AvgDepth;
    DB{i,15}=morph{1,i}.Tortuosity;
    DB{i,16}=morph{1,i}.Skewness;
end

if (exist('spathStalled','var')) 
    for i=1:size(spathStalled,2)
        idx=spathStalled{1,i}.StalledVesselIndex;
        DB{idx,8}=length(spathStalled{1,i}.Path2PAVesselIndices);
        DB{idx,9}=length(spathStalled{1,i}.Path2AVVesselIndices);
        listPA=spathStalled{2,i}.Path2PAVesselIndices;
        listAV=spathStalled{2,i}.Path2AVVesselIndices;
        totalLengthPA=0;
        totalLengthAV=0;
        for j=1:length(listPA)-1
            totalLengthPA=totalLengthPA+morph{listPA(j)}.Length;
        end
        for j=1:length(listAV)-1
            totalLengthAV=totalLengthAV+morph{listAV(j)}.Length;
        end
        DB{idx,10}=totalLengthPA;
        DB{idx,11}=totalLengthAV;
    end
    for i=1:size(spathUnstalled,2)
        idx=spathUnstalled{1,i}.UnstalledVesselIndex;
        DB{idx,8}=length(spathUnstalled{1,i}.Path2PAVesselIndices);
        DB{idx,9}=length(spathUnstalled{1,i}.Path2AVVesselIndices);
        listPA=spathUnstalled{2,i}.Path2PAVesselIndices;
        listAV=spathUnstalled{2,i}.Path2AVVesselIndices;
        totalLengthPA=0;
        totalLengthAV=0;
        for j=1:length(listPA)-1
            totalLengthPA=totalLengthPA+morph{listPA(j)}.Length;
        end
        for j=1:length(listAV)-1
            totalLengthAV=totalLengthAV+morph{listAV(j)}.Length;
        end
        DB{idx,10}=totalLengthPA;
        DB{idx,11}=totalLengthAV;
    end
end

% save data sheet
save([file.pathname,'/','DataSheet'],'DB');


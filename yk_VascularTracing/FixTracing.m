% initialization
clear; close all; clc;
addpath(genpath('./functions/'));
% if (matlabpool('size')==0)
%     matlabpool open;
% end

% load plist and image volume
file=struct;
[file.fnPlist,file.pnPlist]=uigetfile('*.plist','Choose plist file');
[file.fnImage,file.pnImage]=uigetfile('*.tif','Choose tif image');

handle=waitbar(0,'Fixing Tracing Structure 0/3');
S=loadPlist(strcat(file.pnPlist,file.fnPlist));
im=importtif(strcat(file.pnImage,file.fnImage));
ratioMicronPerPixel=GetRatioMicronPerPixel(S);

% fix plist structure, and extract segment
waitbar(1/3,handle,'Fixing Tracing Structure 1/3');
tic;
S=FixStructure(S);
Skel=RearrangeSkeleton(S);
Skel=Skel(1,:);
Skel=shiftNodes(Skel);
toc;

% rearrange segment based on new nodes
waitbar(2/3,handle,'Fixing Tracing Structure 2/3');
tic;
Skel=RearrangeSegment(S,Skel,im,31);
toc;

% merge segment with one branch
waitbar(1,handle,'Fixing Tracing Structure 3/3');
tic;
[tmpS,~]=BuildTmpSkel2(Skel,0,1);
[Skel,~]=MergeSkel(Skel,tmpS);
S=BuildStructure(Skel);
S=MergeStructNodes(S,10);
Skel=BuildSkelFromStruct(S);
[tmpS,~]=BuildTmpSkel(Skel,0);
[Skel,~]=MergeSkel(Skel,tmpS);
S=BuildStructure(Skel);
toc;
delete(handle);

% save data
dimX=size(im,1); dimY=size(im,2);
SVectorized=goTrace_toVectorized(fixPlistStructure(S));
GOTracerReadableFile=ExportToGOTracer(SVectorized,dimX,dimY,ratioMicronPerPixel(1),file.pnPlist);
output=structToXMLPlist(GOTracerReadableFile);
hSaveGoTracer=fopen(strcat([file.pnPlist,file.fnPlist,'_FIXED.gotrace']),'w');
fwrite(hSaveGoTracer,output);
fclose(hSaveGoTracer);



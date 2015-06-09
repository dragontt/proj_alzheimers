clear; close all; clc;

% This script performs following data processing:
% - Fix plist structure
% - Fix skeleton alignment and shift to vasculature image stack
% - Segment vasculature 
% - Compute vascular morphology information, and analyze statistics
% - Compute the shortest path from stalled vessel to PA and AV
%   respectively, and analyze statistics
% - Compute tissue volume corresponding to its nearest vasculature
%
% Input: 
%   S   - plist structure
%   im  - can only be 8bit grayscale image stack
% 
% Output:
%   mask    - computed binary mask 
%   S       - fixed plist structure (not masked)
%   Skel    - alignment and shift corrected vascular skeleton (masked)
%   im      - image stack
%   V       - binarized vaculature segement
%   morph   - morphology computation of each vessel
%   morphStalled
%   morphUnstalled - list of stalled and unstalled vessel morphologies
%   spathStalled
%   spathUnstalled - shortest paths of stalled and unstalled vessels to 
%                    their nearest AP and AV according to branch number 
%                    (1st row), and vessel segment length (2nd row)


%% INITIALIZATION
addpath(genpath('./functions/'));

% enable parallel computing
if matlabpool('size')==0
    matlabpool open;
end

%% MASK?
choice=questdlg('Is the image masked?','Mask Option','Yes','No','No');
switch choice
    case 'Yes'
        hasMask=true;
    case 'No'
        hasMask=false;
end

%%  PREPARE DATA
% load plist and image volume
file=struct;
[file.fnPlist,file.pnPlist]=uigetfile('*.plist','Choose plist file');
[file.fnImage,file.pnImage]=uigetfile('*.tif','Choose tif image');

S=loadPlist(strcat(file.pnPlist,file.fnPlist));
im=importtif(strcat(file.pnImage,file.fnImage));
mask=GetBinaryMask(im,hasMask);
disp('Import plist and tif image completed');

% ratioMicronPerPixel=GetRatioMicronPerPixel(S);

% fix plist structure, and extract blood vessel skeleton
S=FixStructure(S); 
Skel=RearrangeSkeleton(S);
if hasMask Skel=GetMaskedSkel(Skel,mask); end
disp('Fix plist structure completed');

% fix rendering alignment
im2=FixAlignment(im); % im2 - ONLY for rendering alginment purpose
figure; visualSkel3d(Skel,'gotracer color render');hold on;
visualStalledSkel3d(Skel,'stalled vessel');hold on;
visualSlice3d(im2,50,'gray');hold off;axis image; 

% image preparation and check thresholding
paramIm_gauSize=5;
paramIm_windowSize=85;
paramIm_offset=-9;
paramIm_numElim=1000;
paramIm_isHoleFill=0;
paramIm_isBgSub=0;

V=imprep(im,paramIm_gauSize,paramIm_windowSize,paramIm_offset,...
    paramIm_numElim,paramIm_isHoleFill,paramIm_isBgSub);

visualSlice2d(im,V); 

% fix vessel skeleton shift
distMap=bwdist(imcomplement(V));
Skel=FixSkelShift(Skel,distMap,10);
disp('Fix skeleton - vessel image alignment');


%% DIMENSION ANALYSIS
% compute basic vessel morophology
morph=GetVessMorph(Skel,distMap);
[morphStalled,morphUnstalled]=GetMorphInfo(morph,Skel);

paramMorph_numBins=10;
paramMorph_maxDiam=15;
paramMorph_maxSkew=1.25;
paramMorph_maxKurt=1.25;
paramMorph_maxLeng=200;
paramMorph_maxTort=2;
paramMorph_maxDept=size(V,3);

morphStatsStalled=struct;
morphStatsUnstalled=struct;
morphStatsStalled.Diameter=ComptMorphStats(morphStalled(:,2),paramMorph_numBins,3,paramMorph_maxDiam);
morphStatsUnstalled.Diameter=ComptMorphStats(morphUnstalled(:,2),paramMorph_numBins,3,paramMorph_maxDiam);
morphStatsStalled.Skewness=ComptMorphStats(morphStalled(:,3),paramMorph_numBins,.75,paramMorph_maxSkew);
morphStatsUnstalled.Skewness=ComptMorphStats(morphUnstalled(:,3),paramMorph_numBins,.75,paramMorph_maxSkew);
morphStatsStalled.Kurtosis=ComptMorphStats(morphStalled(:,4),paramMorph_numBins,.75,paramMorph_maxKurt);
morphStatsUnstalled.Kurtosis=ComptMorphStats(morphUnstalled(:,4),paramMorph_numBins,.75,paramMorph_maxKurt);
morphStatsStalled.Length=ComptMorphStats(morphStalled(:,5),paramMorph_numBins,0,paramMorph_maxLeng);
morphStatsUnstalled.Length=ComptMorphStats(morphUnstalled(:,5),paramMorph_numBins,0,paramMorph_maxLeng);
morphStatsStalled.Tortuosity=ComptMorphStats(morphStalled(:,6),paramMorph_numBins,.9,paramMorph_maxTort);
morphStatsUnstalled.Tortuosity=ComptMorphStats(morphUnstalled(:,6),paramMorph_numBins,.9,paramMorph_maxTort);
morphStatsStalled.Depth=ComptMorphStats(morphStalled(:,7),paramMorph_numBins,0,paramMorph_maxDept);
morphStatsUnstalled.Depth=ComptMorphStats(morphUnstalled(:,7),paramMorph_numBins,0,paramMorph_maxDept);

% apply gaussian fit to morphology stats
morphStatsStalled=ComputeGaussFit(morphStatsStalled);
morphStatsUnstalled=ComputeGaussFit(morphStatsUnstalled);

disp('Get vessel morphological information completed');

% plot morphology histogram and its guassian fits
figure('Position',[10,1000,1200,500]);
subplot(2,3,1);viewMorphStats(morphStatsStalled.Diameter,morphStatsUnstalled.Diameter,...
    'Average Diameter',morphStatsStalled.Gauss_Diameter,morphStatsUnstalled.Gauss_Diameter);
subplot(2,3,2);viewMorphStats(morphStatsStalled.Skewness,morphStatsUnstalled.Skewness,...
    'Skewness',morphStatsStalled.Gauss_Skewness,morphStatsUnstalled.Gauss_Skewness);
subplot(2,3,3);viewMorphStats(morphStatsStalled.Kurtosis,morphStatsUnstalled.Kurtosis,...
    'Kurtosis',morphStatsStalled.Gauss_Kurtosis,morphStatsUnstalled.Gauss_Kurtosis);
subplot(2,3,4);viewMorphStats(morphStatsStalled.Length,morphStatsUnstalled.Length,...
    'Length',morphStatsStalled.Gauss_Length,morphStatsUnstalled.Gauss_Length);
subplot(2,3,5);viewMorphStats(morphStatsStalled.Tortuosity,morphStatsUnstalled.Tortuosity,...
    'Tortuosity',morphStatsStalled.Gauss_Tortuosity,morphStatsUnstalled.Gauss_Tortuosity);
subplot(2,3,6);viewMorphStats(morphStatsStalled.Depth,morphStatsUnstalled.Depth,...
    'Average Depth',morphStatsStalled.Gauss_Depth,morphStatsUnstalled.Gauss_Depth);

figure('Position',[1200,1000,800,800]);
viewMorphStatsBoxplot(morphStalled,morphUnstalled);

% im=uint8(im);
% save([file.pnPlist,'Analysis'],...
%     'im','V','S','Skel','morph','morphStalled','morphUnstalled');

%% BRANCHING ANALYSIS
% find the smallest path from stalled vessel nodes to PA and AV nodes
[spathStalled,spathUnstalled]=FindBranching(S);

paramTop_numBins=10;
paramTop_maxBranchNum=20;
paramTop_maxVessLength=2000;

% branch number, stalled
[spathStatsBranch{1},spathListBranch{1}]=...
    ComptSpathStatsBranchNum(spathStalled(1,:),paramTop_numBins,paramTop_maxBranchNum);
% branch number, unstalled
[spathStatsBranch{2},spathListBranch{2}]=...
    ComptSpathStatsBranchNum(spathUnstalled(1,:),paramTop_numBins,paramTop_maxBranchNum);
% vessel length, stalled
[spathStatsLength{1},spathListLength{1}]=...
    ComptSpathStatsVessLength(spathStalled(2,:),S,paramTop_numBins,paramTop_maxVessLength);
% vessel length unstalled
[spathStatsLength{2},spathListLength{2}]=...
    ComptSpathStatsVessLength(spathUnstalled(2,:),S,paramTop_numBins,paramTop_maxVessLength);

disp('Find vessel branching completed');

figure('Position',[10,10,800,450]); 
viewSpathStats(spathStatsBranch,spathStatsLength);

figure('Position',[1200,10,600,500]);
viewSpathStatsBoxplot(spathListBranch,spathListLength);

%% Tissue Volume 
% % compute the tissue volume corresponding to the closest vessel or node
% volTissue=GetTissueVol(im,Skel,50);
% 
% % visual rendering (long rendering process in Matlab)
% figure; 
% visualSlice3d(volTissue,50,'jet',0); hold on;
% visualSkel3d(Skel,'gotracer color render'); hold off; axis image;
% 
% % [volPath2PA,volPath2AV,volStalled]=GetStalledVessNPathTerritoryVol(volTissue,Skel);
% % [stats_stallTerr,stats_unstallTerr]=ComptTerritoryHist(V_tissue,Skel,10,500000);
% % 
% % figure; viewTerrStats(stats_stallTerr,stats_unstallTerr);
% 
% disp('Find vessel territory completed');

im=uint8(im);
save([file.pnPlist,'Analysis'],...
    'im','V','S','Skel','morph','morphStalled','morphUnstalled','spathStalled','spathUnstalled');




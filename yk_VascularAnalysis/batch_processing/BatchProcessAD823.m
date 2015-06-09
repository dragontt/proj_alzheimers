% batch process AD 823 Combined AB stacks

close all; clear; clc;

cd ..;
addpath(genpath('./functions/'));
batchMorph=cell(1,5); % last column is for the unstalled vessel
batchSpath=cell(2,5); % first row shortest path of branching; second row shortest path of length
numStalled=zeros(1,4);

paramTop_numBins=10;
paramTop_maxBranchNum=20;
paramTop_maxVessLength=2000;

%% day 0 pre
load('/Users/schafferlab/Documents/MATLAB/yk_Data/AD Analysis/AD 823/Combined AB/day 0 pre/Analysis.mat');

[spathStatsBranch{1},spathListBranch{1}]=ComptSpathStatsBranchNum(spathStalled(1,:),paramTop_numBins,paramTop_maxBranchNum);
[spathStatsBranch{2},spathListBranch{2}]=ComptSpathStatsBranchNum(spathUnstalled(1,:),paramTop_numBins,paramTop_maxBranchNum);
[spathStatsLength{1},spathListLength{1}]=ComptSpathStatsVessLength2(spathStalled(2,:),lengthListStalled,paramTop_numBins,paramTop_maxVessLength);
[spathStatsLength{2},spathListLength{2}]=ComptSpathStatsVessLength2(spathUnstalled(2,:),lengthListUnstalled,paramTop_numBins,paramTop_maxVessLength);

batchMorph{1}=morphStalled;
for i=1:2
    tmp=spathListBranch{1}(i,:);
    tmp(find(tmp==0))=[];
    batchSpath{1,1}{i}=tmp;
    tmp=spathListBranch{2}(i,:);
    tmp(find(tmp==0))=[];
    batchSpath{1,5}{i}=tmp;
    tmp=spathListLength{1}(i,:);
    tmp(find(tmp==0))=[];
    batchSpath{2,1}{i}=tmp;
    tmp=spathListLength{2}(i,:);
    tmp(find(tmp==0))=[];
    batchSpath{2,5}{i}=tmp;
end
numStalled(1)=size(spathStalled,2);

%% day 0 post
load('/Users/schafferlab/Documents/MATLAB/yk_Data/AD Analysis/AD 823/Combined AB/day 0 post/Analysis.mat');

[spathStatsBranch{1},spathListBranch{1}]=ComptSpathStatsBranchNum(spathStalled(1,:),paramTop_numBins,paramTop_maxBranchNum);
[spathStatsLength{1},spathListLength{1}]=ComptSpathStatsVessLength2(spathStalled(2,:),lengthListStalled,paramTop_numBins,paramTop_maxVessLength);

batchMorph{2}=morphStalled;
batchMorph{5}=morphUnstalled;
for i=1:2
    tmp=spathListBranch{1}(i,:);
    tmp(find(tmp==0))=[];
    batchSpath{1,2}{i}=tmp;
    tmp=spathListLength{1}(i,:);
    tmp(find(tmp==0))=[];
    batchSpath{2,2}{i}=tmp;
end
numStalled(2)=size(spathStalled,2);

%% day 1
load('/Users/schafferlab/Documents/MATLAB/yk_Data/AD Analysis/AD 823/Combined AB/day 1/Analysis.mat');

[spathStatsBranch{1},spathListBranch{1}]=ComptSpathStatsBranchNum(spathStalled(1,:),paramTop_numBins,paramTop_maxBranchNum);
[spathStatsLength{1},spathListLength{1}]=ComptSpathStatsVessLength2(spathStalled(2,:),lengthListStalled,paramTop_numBins,paramTop_maxVessLength);

batchMorph{3}=morphStalled;
for i=1:2
    tmp=spathListBranch{1}(i,:);
    tmp(find(tmp==0))=[];
    batchSpath{1,3}{i}=tmp;
    tmp=spathListLength{1}(i,:);
    tmp(find(tmp==0))=[];
    batchSpath{2,3}{i}=tmp;
end
numStalled(3)=size(spathStalled,2);

%% day 4
load('/Users/schafferlab/Documents/MATLAB/yk_Data/AD Analysis/AD 823/Combined AB/day 4/Analysis.mat');

[spathStatsBranch{1},spathListBranch{1}]=ComptSpathStatsBranchNum(spathStalled(1,:),paramTop_numBins,paramTop_maxBranchNum);
[spathStatsLength{1},spathListLength{1}]=ComptSpathStatsVessLength2(spathStalled(2,:),lengthListStalled,paramTop_numBins,paramTop_maxVessLength);

batchMorph{4}=morphStalled;
for i=1:2
    tmp=spathListBranch{1}(i,:);
    tmp(find(tmp==0))=[];
    batchSpath{1,4}{i}=tmp;
    tmp=spathListLength{1}(i,:);
    tmp(find(tmp==0))=[];
    batchSpath{2,4}{i}=tmp;
end
numStalled(4)=size(spathStalled,2);

%% view plots
figure(1);
plot(numStalled); hold on; scatter(1:4,numStalled); hold off;
axis([1,4,0,max(numStalled)]);
set(gca,'XTick',1:4);
set(gca,'XTickLabel',{'day0 pre','day0 post','day1','day4'});
title('Number of Stalled Vessels');
set(gcf, 'Color', 'White');

figure(2);
titleArray=[{'Average Diameter'},{'Skewness'},{'Kurtosis'},...
    {'Length'},{'Tortuosity'},{'Average Depth'}];
for i=1:6
    subplot(2,3,i);
    boxplot([batchMorph{1}(:,i+1);batchMorph{2}(:,i+1);batchMorph{3}(:,i+1);...
        batchMorph{4}(:,i+1);batchMorph{5}(:,i+1);],...
        [zeros(size(batchMorph{1},1),1);ones(size(batchMorph{2},1),1);...
        2*ones(size(batchMorph{3},1),1);3*ones(size(batchMorph{4},1),1);...
        4*ones(size(batchMorph{5},1),1)],'labels',{'day0 pre','day0 post',...
        'day1','day4','unstalled'},'jitter',0,'whisker',5);
    title(titleArray{i});
end
set(gcf, 'Color', 'White');

figure(3);
maxBranch=max([max(batchSpath{1,1}{1}),max(batchSpath{1,2}{1}),...
    max(batchSpath{1,3}{1}),max(batchSpath{1,4}{1}),...
    max(batchSpath{1,5}{1}),max(batchSpath{1,1}{2}),...
    max(batchSpath{1,2}{2}),max(batchSpath{1,3}{2}),...
    max(batchSpath{1,4}{2}),max(batchSpath{1,5}{2})]);
maxLength=max([max(batchSpath{2,1}{1}),max(batchSpath{2,2}{1}),...
    max(batchSpath{2,3}{1}),max(batchSpath{2,4}{1}),...
    max(batchSpath{2,5}{1}),max(batchSpath{2,1}{2}),...
    max(batchSpath{2,2}{2}),max(batchSpath{2,3}{2}),...
    max(batchSpath{2,4}{2}),max(batchSpath{2,5}{2})]);

% branch number, 2PA
subplot(2,2,1);
boxplot([batchSpath{1,1}{1},batchSpath{1,2}{1},batchSpath{1,3}{1},...
    batchSpath{1,4}{1},batchSpath{1,5}{1}],...
    [zeros(1,length(batchSpath{1,1}{1})),ones(1,length(batchSpath{1,2}{1})),...
    2*ones(1,length(batchSpath{1,3}{1})),3*ones(1,length(batchSpath{1,4}{1})),...
    4*ones(1,length(batchSpath{1,5}{1}))],'labels',{'day0 pre','day0 post',...
        'day1','day4','unstalled'},'jitter',0,'whisker',1.5);
title('Branching Number to Penetrating Arteriole');
ylim([-2,maxBranch+2]);

% branch number, 2AV
subplot(2,2,2);
boxplot([batchSpath{1,1}{2},batchSpath{1,2}{2},batchSpath{1,3}{2},...
    batchSpath{1,4}{2},batchSpath{1,5}{2}],...
    [zeros(1,length(batchSpath{1,1}{2})),ones(1,length(batchSpath{1,2}{2})),...
    2*ones(1,length(batchSpath{1,3}{2})),3*ones(1,length(batchSpath{1,4}{2})),...
    4*ones(1,length(batchSpath{1,5}{2}))],'labels',{'day0 pre','day0 post',...
        'day1','day4','unstalled'},'jitter',0,'whisker',1.5);
    title('Branching Number to Ascending Venule');
ylim([-2,maxBranch+2]);

% vessel length, 2PA
subplot(2,2,3);
boxplot([batchSpath{2,1}{1},batchSpath{2,2}{1},batchSpath{2,3}{1},...
    batchSpath{2,4}{1},batchSpath{2,5}{1}],...
    [zeros(1,length(batchSpath{2,1}{1})),ones(1,length(batchSpath{2,2}{1})),...
    2*ones(1,length(batchSpath{2,3}{1})),3*ones(1,length(batchSpath{2,4}{1})),...
    4*ones(1,length(batchSpath{2,5}{1}))],'labels',{'day0 pre','day0 post',...
        'day1','day4','unstalled'},'jitter',0,'whisker',1.5);
title('Vessel Length to Penetrating Arteriole');
ylim([-50,maxLength+50]);

% vessel length, 2AV
subplot(2,2,4);
boxplot([batchSpath{2,1}{2},batchSpath{2,2}{2},batchSpath{2,3}{2},...
    batchSpath{2,4}{2},batchSpath{2,5}{2}],...
    [zeros(1,length(batchSpath{2,1}{2})),ones(1,length(batchSpath{2,2}{2})),...
    2*ones(1,length(batchSpath{2,3}{2})),3*ones(1,length(batchSpath{2,4}{2})),...
    4*ones(1,length(batchSpath{2,5}{2}))],'labels',{'day0 pre','day0 post',...
        'day1','day4','unstalled'},'jitter',0,'whisker',1.5);
title('Vessel Length to Ascending Venule');
ylim([-50,maxLength+50]);
set(gcf, 'Color', 'White');

% This scripts combines the variables in A and B stacks needed for batch
% processing, which are morphStalled, morphUnstalled, spathStalled,
% spathUnstalled, lengthListStalled, lengthListUnstalled.

%% load day 0 pre
load('/Users/schafferlab/Documents/MATLAB/yk_Data/AD Analysis/AD 830/A stack/day 0 pre/Analysis.mat');
tmp_morphStalled=morphStalled;
tmp_morphUnstalled=morphUnstalled;
tmp_spathStalled=spathStalled;
tmp_spathUnstalled=spathUnstalled;
tmp_lengthListStalled=ComputeTotalLength(spathStalled,S);
tmp_lengthListUnstalled=ComputeTotalLength(spathUnstalled,S);
load('/Users/schafferlab/Documents/MATLAB/yk_Data/AD Analysis/AD 830/B stack/day 0 pre/Analysis.mat');
lengthListStalled=ComputeTotalLength(spathStalled,S);
lengthListUnstalled=ComputeTotalLength(spathUnstalled,S);

% concatenate data
morphStalled=vertcat(tmp_morphStalled,morphStalled);
morphUnstalled=vertcat(tmp_morphUnstalled,morphUnstalled);
spathStalled=horzcat(tmp_spathStalled,spathStalled);
spathUnstalled=horzcat(tmp_spathUnstalled,spathUnstalled);
lengthListStalled=horzcat(tmp_lengthListStalled,lengthListStalled);
lengthListUnstalled=horzcat(tmp_lengthListUnstalled,lengthListUnstalled);

% save data
save('/Users/schafferlab/Documents/MATLAB/yk_Data/AD Analysis/AD 830/Combined AB/day 0 pre/Analysis.mat',...
    'morphStalled','morphUnstalled','spathStalled','spathUnstalled',...
    'lengthListStalled','lengthListUnstalled');


%% load day 0 post
load('/Users/schafferlab/Documents/MATLAB/yk_Data/AD Analysis/AD 830/A stack/day 0 post/Analysis.mat');
tmp_morphStalled=morphStalled;
tmp_morphUnstalled=morphUnstalled;
tmp_spathStalled=spathStalled;
tmp_spathUnstalled=spathUnstalled;
tmp_lengthListStalled=ComputeTotalLength(spathStalled,S);
tmp_lengthListUnstalled=ComputeTotalLength(spathUnstalled,S);
load('/Users/schafferlab/Documents/MATLAB/yk_Data/AD Analysis/AD 830/B stack/day 0 post/Analysis.mat');
lengthListStalled=ComputeTotalLength(spathStalled,S);
lengthListUnstalled=ComputeTotalLength(spathUnstalled,S);

% concatenate data
morphStalled=vertcat(tmp_morphStalled,morphStalled);
morphUnstalled=vertcat(tmp_morphUnstalled,morphUnstalled);
spathStalled=horzcat(tmp_spathStalled,spathStalled);
spathUnstalled=horzcat(tmp_spathUnstalled,spathUnstalled);
lengthListStalled=horzcat(tmp_lengthListStalled,lengthListStalled);
lengthListUnstalled=horzcat(tmp_lengthListUnstalled,lengthListUnstalled);

% save data
save('/Users/schafferlab/Documents/MATLAB/yk_Data/AD Analysis/AD 830/Combined AB/day 0 post/Analysis.mat',...
    'morphStalled','morphUnstalled','spathStalled','spathUnstalled',...
    'lengthListStalled','lengthListUnstalled');


%% load day 1
load('/Users/schafferlab/Documents/MATLAB/yk_Data/AD Analysis/AD 830/A stack/day 1/Analysis.mat');
tmp_morphStalled=morphStalled;
tmp_morphUnstalled=morphUnstalled;
tmp_spathStalled=spathStalled;
tmp_spathUnstalled=spathUnstalled;
tmp_lengthListStalled=ComputeTotalLength(spathStalled,S);
tmp_lengthListUnstalled=ComputeTotalLength(spathUnstalled,S);
load('/Users/schafferlab/Documents/MATLAB/yk_Data/AD Analysis/AD 830/B stack/day 1/Analysis.mat');
lengthListStalled=ComputeTotalLength(spathStalled,S);
lengthListUnstalled=ComputeTotalLength(spathUnstalled,S);

% concatenate data
morphStalled=vertcat(tmp_morphStalled,morphStalled);
morphUnstalled=vertcat(tmp_morphUnstalled,morphUnstalled);
spathStalled=horzcat(tmp_spathStalled,spathStalled);
spathUnstalled=horzcat(tmp_spathUnstalled,spathUnstalled);
lengthListStalled=horzcat(tmp_lengthListStalled,lengthListStalled);
lengthListUnstalled=horzcat(tmp_lengthListUnstalled,lengthListUnstalled);

% save data
save('/Users/schafferlab/Documents/MATLAB/yk_Data/AD Analysis/AD 830/Combined AB/day 1/Analysis.mat',...
    'morphStalled','morphUnstalled','spathStalled','spathUnstalled',...
    'lengthListStalled','lengthListUnstalled');


%% load day 3
load('/Users/schafferlab/Documents/MATLAB/yk_Data/AD Analysis/AD 830/A stack/day 3/Analysis.mat');
tmp_morphStalled=morphStalled;
tmp_morphUnstalled=morphUnstalled;
tmp_spathStalled=spathStalled;
tmp_spathUnstalled=spathUnstalled;
tmp_lengthListStalled=ComputeTotalLength(spathStalled,S);
tmp_lengthListUnstalled=ComputeTotalLength(spathUnstalled,S);
load('/Users/schafferlab/Documents/MATLAB/yk_Data/AD Analysis/AD 830/B stack/day 3/Analysis.mat');
lengthListStalled=ComputeTotalLength(spathStalled,S);
lengthListUnstalled=ComputeTotalLength(spathUnstalled,S);

% concatenate data
morphStalled=vertcat(tmp_morphStalled,morphStalled);
morphUnstalled=vertcat(tmp_morphUnstalled,morphUnstalled);
spathStalled=horzcat(tmp_spathStalled,spathStalled);
spathUnstalled=horzcat(tmp_spathUnstalled,spathUnstalled);
lengthListStalled=horzcat(tmp_lengthListStalled,lengthListStalled);
lengthListUnstalled=horzcat(tmp_lengthListUnstalled,lengthListUnstalled);

% save data
save('/Users/schafferlab/Documents/MATLAB/yk_Data/AD Analysis/AD 830/Combined AB/day 3/Analysis.mat',...
    'morphStalled','morphUnstalled','spathStalled','spathUnstalled',...
    'lengthListStalled','lengthListUnstalled');


%% load day 7
load('/Users/schafferlab/Documents/MATLAB/yk_Data/AD Analysis/AD 830/A stack/day 7/Analysis.mat');
tmp_morphStalled=morphStalled;
tmp_morphUnstalled=morphUnstalled;
tmp_spathStalled=spathStalled;
tmp_spathUnstalled=spathUnstalled;
tmp_lengthListStalled=ComputeTotalLength(spathStalled,S);
tmp_lengthListUnstalled=ComputeTotalLength(spathUnstalled,S);
load('/Users/schafferlab/Documents/MATLAB/yk_Data/AD Analysis/AD 830/B stack/day 7/Analysis.mat');
lengthListStalled=ComputeTotalLength(spathStalled,S);
lengthListUnstalled=ComputeTotalLength(spathUnstalled,S);

% concatenate data
morphStalled=vertcat(tmp_morphStalled,morphStalled);
morphUnstalled=vertcat(tmp_morphUnstalled,morphUnstalled);
spathStalled=horzcat(tmp_spathStalled,spathStalled);
spathUnstalled=horzcat(tmp_spathUnstalled,spathUnstalled);
lengthListStalled=horzcat(tmp_lengthListStalled,lengthListStalled);
lengthListUnstalled=horzcat(tmp_lengthListUnstalled,lengthListUnstalled);

% save data
save('/Users/schafferlab/Documents/MATLAB/yk_Data/AD Analysis/AD 830/Combined AB/day 7/Analysis.mat',...
    'morphStalled','morphUnstalled','spathStalled','spathUnstalled',...
    'lengthListStalled','lengthListUnstalled');


%% load day 14
load('/Users/schafferlab/Documents/MATLAB/yk_Data/AD Analysis/AD 830/A stack/day 14/Analysis.mat');
tmp_morphStalled=morphStalled;
tmp_morphUnstalled=morphUnstalled;
tmp_spathStalled=spathStalled;
tmp_spathUnstalled=spathUnstalled;
tmp_lengthListStalled=ComputeTotalLength(spathStalled,S);
tmp_lengthListUnstalled=ComputeTotalLength(spathUnstalled,S);
load('/Users/schafferlab/Documents/MATLAB/yk_Data/AD Analysis/AD 830/B stack/day 14/Analysis.mat');
lengthListStalled=ComputeTotalLength(spathStalled,S);
lengthListUnstalled=ComputeTotalLength(spathUnstalled,S);

% concatenate data
morphStalled=vertcat(tmp_morphStalled,morphStalled);
morphUnstalled=vertcat(tmp_morphUnstalled,morphUnstalled);
spathStalled=horzcat(tmp_spathStalled,spathStalled);
spathUnstalled=horzcat(tmp_spathUnstalled,spathUnstalled);
lengthListStalled=horzcat(tmp_lengthListStalled,lengthListStalled);
lengthListUnstalled=horzcat(tmp_lengthListUnstalled,lengthListUnstalled);

% save data
save('/Users/schafferlab/Documents/MATLAB/yk_Data/AD Analysis/AD 830/Combined AB/day 14/Analysis.mat',...
    'morphStalled','morphUnstalled','spathStalled','spathUnstalled',...
    'lengthListStalled','lengthListUnstalled');

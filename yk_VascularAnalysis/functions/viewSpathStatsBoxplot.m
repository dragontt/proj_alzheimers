function viewSpathStatsBoxplot(spathListBranch,spathListLength)

maxBranch=max([max(spathListBranch{1}(1,:)),max(spathListBranch{2}(1,:)),...
    max(spathListBranch{1}(2,:)),max(spathListBranch{2}(2,:))]);

maxLength=max([max(spathListLength{1}(1,:)),max(spathListLength{2}(1,:)),...
    max(spathListLength{1}(2,:)),max(spathListLength{2}(2,:))]);

% branch number, 2PA
lengStalled=size(spathListBranch{1}(1,:),2);
lengUnstalled=size(spathListBranch{2}(1,:),2);

subplot(2,2,1);
boxplot([spathListBranch{1}(1,:),spathListBranch{2}(1,:)],...
    [zeros(1,lengStalled),ones(1,lengUnstalled)],...
    'labels',{'Stalled','Unstalled'},'jitter',0,'whisker',1.5);
title('Branching Number to Penetrating Arteriole');
ylim([-2,maxBranch+2]);


% branch number, 2AV
lengStalled=size(spathListBranch{1}(2,:),2);
lengUnstalled=size(spathListBranch{2}(2,:),2);

subplot(2,2,2);
boxplot([spathListBranch{1}(2,:),spathListBranch{2}(2,:)],...
    [zeros(1,lengStalled),ones(1,lengUnstalled)],...
    'labels',{'Stalled','Unstalled'},'jitter',0,'whisker',1.5);
title('Branching Number to Ascending Venule');
ylim([-2,maxBranch+2]);


% vessel length, 2PA
lengStalled=size(spathListLength{1}(1,:),2);
lengUnstalled=size(spathListLength{2}(1,:),2);

subplot(2,2,3);
boxplot([spathListLength{1}(1,:),spathListLength{2}(1,:)],...
    [zeros(1,lengStalled),ones(1,lengUnstalled)],...
    'labels',{'Stalled','Unstalled'},'jitter',0,'whisker',1.5);
title('Vessel Length to Penetrating Arteriole');
ylim([-50,maxLength+50]);


% vessel length, 2AV
lengStalled=size(spathListLength{1}(2,:),2);
lengUnstalled=size(spathListLength{2}(2,:),2);

subplot(2,2,4);
boxplot([spathListLength{1}(2,:),spathListLength{2}(2,:)],...
    [zeros(1,lengStalled),ones(1,lengUnstalled)],...
    'labels',{'Stalled','Unstalled'},'jitter',0,'whisker',1.5);
title('Vessel Length to Ascending Venule');
ylim([-50,maxLength+50]);


set(gcf, 'Color', 'White');
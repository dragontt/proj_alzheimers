function viewMorphStatsBoxplot(stats_Stalled,stats_Unstalled)

lengStalled=size(stats_Stalled,1);
lengUnstalled=size(stats_Unstalled,1);

titleArray=[{'Average Diameter'},{'Skewness'},{'Kurtosis'},...
    {'Length'},{'Tortuosity'},{'Average Depth'}];

for i=1:6
    subplot(2,3,i);
    boxplot([stats_Stalled(:,i+1);stats_Unstalled(:,i+1)],...
        [zeros(lengStalled,1);ones(lengUnstalled,1)],...
        'labels',{'Stalled','Unstalled'},'jitter',0,'whisker',5);
    title(titleArray{i});
end

set(gcf, 'Color', 'White');
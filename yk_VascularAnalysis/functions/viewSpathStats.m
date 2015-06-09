function viewSpathStats(stats_spath_branch,stats_spath_length)
% This function displays histogram of shortest pathes to from stalled
% vessel and unstalled vessel to PA respectively, and those to AV.

ha=tight_subplot(2,2,[.125 0],[.1 .1],[.1 .1]);

% plot based on branching number
stats_spath_stall=stats_spath_branch{1};
stats_spath_unstall=stats_spath_branch{2};

yMax=max([max(stats_spath_branch{1}(:,4:5)),max(stats_spath_branch{2}(:,4:5)),...
    max(stats_spath_length{1}(:,4:5)),max(stats_spath_length{2}(:,4:5))]*100+2);
xMax=stats_spath_stall(end,1);

axes(ha(1));
plot(stats_spath_stall(:,1),stats_spath_stall(:,4)*100,'r'); hold on;
plot(stats_spath_unstall(:,1),stats_spath_unstall(:,4)*100,'b'); hold on;
scatter(stats_spath_stall(:,1),stats_spath_stall(:,4)*100,'r','o'); hold on;
scatter(stats_spath_unstall(:,1),stats_spath_unstall(:,4)*100,'b','+'); hold off;
set(gca,'xdir','reverse');
axis([0,xMax,0,yMax]);
title('Branching Percentage to Penetrating Arteriole');
xlabel('Branching Number');
ylabel('Percentage Count (%)');

axes(ha(2));
plot(stats_spath_stall(:,1),stats_spath_stall(:,5)*100,'r'); hold on;
plot(stats_spath_unstall(:,1),stats_spath_unstall(:,5)*100,'b'); hold on;
scatter(stats_spath_stall(:,1),stats_spath_stall(:,5)*100,'r','o'); hold on;
scatter(stats_spath_unstall(:,1),stats_spath_unstall(:,5)*100,'b','+'); hold off;
axis([0,xMax,0,yMax]);
title('Branching Percentage to Ascending Venule');
xlabel('Branching Number');
set(gca,'yaxislocation','right');
ylabel('Percentage Count (%)');
set(legend('Stalled','Unstalled'), 'Position', [.45,.8,.1,.1]);

% plot based on vessel length
stats_spath_stall=stats_spath_length{1};
stats_spath_unstall=stats_spath_length{2};

xMax=stats_spath_stall(end,1);

axes(ha(3));
plot(stats_spath_stall(:,1),stats_spath_stall(:,4)*100,'r'); hold on;
plot(stats_spath_unstall(:,1),stats_spath_unstall(:,4)*100,'b'); hold on;
scatter(stats_spath_stall(:,1),stats_spath_stall(:,4)*100,'r','o'); hold on;
scatter(stats_spath_unstall(:,1),stats_spath_unstall(:,4)*100,'b','+'); hold off;
set(gca,'xdir','reverse');
axis([0,xMax,0,yMax]);
title('Branching Percentage to Penetrating Arteriole');
xlabel('Vessel Length (micron)');
ylabel('Percentage Count (%)');

axes(ha(4));
plot(stats_spath_stall(:,1),stats_spath_stall(:,5)*100,'r'); hold on;
plot(stats_spath_unstall(:,1),stats_spath_unstall(:,5)*100,'b'); hold on;
scatter(stats_spath_stall(:,1),stats_spath_stall(:,5)*100,'r','o'); hold on;
scatter(stats_spath_unstall(:,1),stats_spath_unstall(:,5)*100,'b','+'); hold off;
axis([0,xMax,0,yMax]);
title('Branching Percentage to Ascending Venule');
xlabel('Vessel Length (micron)');
set(gca,'yaxislocation','right');
ylabel('Percentage Count (%)');
set(legend('Stalled','Unstalled'), 'Position', [.45,.335,.1,.1]);

set(gcf, 'Color', 'White');
% set(ha(1:4),'XTickLabel',''); set(ha,'YTickLabel','');

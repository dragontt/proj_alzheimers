function viewTerrStats(stats_stallTerr,stats_unstallTerr)
% This function displays histograms of territory volumes of stalled vessels
% and unstalled vessels

plot(stats_stallTerr(:,1),stats_stallTerr(:,3)*100,'r'); hold on;
plot(stats_unstallTerr(:,1),stats_unstallTerr(:,3)*100,'b'); hold on;
scatter(stats_stallTerr(:,1),stats_stallTerr(:,3)*100,'r'); hold on;
scatter(stats_unstallTerr(:,1),stats_unstallTerr(:,3)*100,'b'); hold off;

box on;
title('Territory Volume Histogram');
xlabel('Territory Volume (micron^3)');
ylabel('Percentage Count (%)');
legend('Stalled','Unstalled');
set(gcf, 'Color', 'White');
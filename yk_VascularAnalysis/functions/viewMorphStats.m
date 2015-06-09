function viewMorphStats(stats_morphStalled,stats_morphUnstalled,plotTitle,fit_Stalled,fit_Unstalled)
% This function displays histograms of morphologial information of each
% blood vessel.

scatter(stats_morphStalled(:,1),stats_morphStalled(:,3)*100,'r','o'); hold on;
scatter(stats_morphUnstalled(:,1),stats_morphUnstalled(:,3)*100,'b','+'); hold on;

if nargin<3
    plotTitle='Untitled';
elseif nargin<4
    plot(stats_morphStalled(:,1),stats_morphStalled(:,3)*100,'r','LineWidth',1); hold on;
    plot(stats_morphUnstalled(:,1),stats_morphUnstalled(:,3)*100,'b','LineWidth',1); hold off;
elseif nargin<5
    error('Not enough input for Gaussian fit');
elseif nargin==5
    plot(stats_morphStalled(:,1),stats_morphStalled(:,3)*100,':r','LineWidth',1); hold on;
    plot(stats_morphUnstalled(:,1),stats_morphUnstalled(:,3)*100,':b','LineWidth',1); hold on;
    if ~isempty(fit_Stalled)
        h=plot(fit_Stalled); 
        set(h,'Color',[1,0,0],'LineWidth',1); hold on;
    end
    if ~isempty(fit_Unstalled)
        h=plot(fit_Unstalled,'b'); 
        set(h,'Color',[0,0,1],'LineWidth',1); hold off;
    end
end

box on;
title(plotTitle);
xlabel('');
xlim([stats_morphStalled(1,1),stats_morphStalled(end,1)]);
ylabel('Percentage Count (%)');
legend('Stalled','Unstalled');
set(gcf, 'Color', 'White');
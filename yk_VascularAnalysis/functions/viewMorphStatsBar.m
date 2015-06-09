function viewMorphStatsBar(stats_morphStalled,stats_morphUnstalled,plotTitle,fit_Stalled,fit_Unstalled)
% This function displays histograms of morphologial information of each
% blood vessel.

numBin=size(stats_morphStalled,1);
stats_morph=zeros(numBin,3);
stats_morph(:,1)=stats_morphStalled(:,1);
stats_morph(:,2)=stats_morphStalled(:,3)*100;
stats_morph(:,3)=stats_morphUnstalled(:,3)*100;

if nargin<3
    plotTitle='Untitled';
elseif nargin<4
    h1=bar(stats_morph(:,1),[stats_morph(:,2),stats_morph(:,3)]); hold off;
    set(h1(1),'BarWidth',2,'LineStyle','none','FaceColor',[0.75,0.15,0]);
    set(h1(2),'BarWidth',2,'LineStyle','none','FaceColor',[0,0.15,0.75]);
elseif nargin<5
    error('Not enough input for Gaussian fit');
elseif nargin==5
    h1=bar(stats_morph(:,1),[stats_morph(:,2),stats_morph(:,3)]); hold on;
    set(h1(1),'BarWidth',2,'EdgeColor',[1,1,1],'FaceColor',[0.75,0.15,0]);
    set(h1(2),'BarWidth',2,'EdgeColor',[1,1,1],'FaceColor',[0,0.15,0.75]); 
    if ~isempty(fit_Stalled)
        h2=plot(fit_Stalled); 
        set(h2,'Color',[1,1,1],'LineWidth',3); hold on;
        h3=plot(fit_Stalled); 
        set(h3,'Color',[1,0,0],'LineWidth',1); hold on;
    end
    if ~isempty(fit_Unstalled)
        h2=plot(fit_Unstalled,'b'); 
        set(h2,'Color',[1,1,1],'LineWidth',3); hold on;
        h3=plot(fit_Unstalled); 
        set(h3,'Color',[0,0,1],'LineWidth',1); hold off;
    end
end

axis square;
title(plotTitle);
xlabel('');
xlim([stats_morph(1,1),stats_morph(end,1)]);
ylabel('Percentage Count (%)');
legend('Stalled','Unstalled');
set(gcf, 'Color', 'White');


function viewEdgeBundle(S)

nodeDepthList=zeros(1,length(S.Nodes));
nodeWheelList=zeros(2,length(S.Nodes));
for i=1:length(S.Nodes)
    nodeDepthList(i)=S.Nodes{i}.location{3};
end
maxNodeWheel=ceil(max(nodeDepthList)/100)*100;
for i=1:length(S.Nodes)
    t=2*pi*nodeDepthList(i)/maxNodeWheel;
    nodeWheelList(1,i)=cos(t);
    nodeWheelList(2,i)=sin(t);
end

A=buildAdjMatrix(S,0);
Au=triu(A);
[nodeI,nodeJ]=ind2sub([length(S.Nodes),length(S.Nodes)],find(Au));

t=0:0.01:2*pi;
cirX=cos(t);
cirY=sin(t);
plot(cirX,cirY,'Color',[.75,.75,.75],'LineWidth',2);
hold on;
% for i=1:size(nodeI,1)
%    plot([nodeWheelList(1,nodeI(i)),nodeWheelList(1,nodeJ(i))],...
%        [nodeWheelList(2,nodeI(i)),nodeWheelList(2,nodeJ(i))],...
%        'Color',rand(1,3),'LineWidth',1);
%    hold on;
% end
for i=1:size(nodeI,1)
    tmpI=nodeWheelList(:,nodeI(i));
    tmpJ=nodeWheelList(:,nodeJ(i));
    tmpV(1,1)=-(tmpI(1)+tmpJ(1))/2;
    tmpV(2,1)=-(tmpI(2)+tmpJ(2))/2;
    tmpV=tmpV/sqrt(tmpV(1)^2+tmpV(2)^2);
    tmpR=sqrt((tmpI(1)-tmpJ(1))^2+(tmpI(2)-tmpJ(2))^2)/2;
    tmpMov=sqrt(tmpV(1)^2+tmpV(2)^2)*tmpR;
    tmpCtl=-tmpV+tmpV*tmpMov;
    L=fnplt(cscvn([tmpI(1),tmpCtl(1),tmpJ(1);tmpI(2),tmpCtl(2),tmpJ(2)]));
    plot(L(1,:),L(2,:),'Color',rand(1,3),'LineWidth',1.5);
    hold on;
end
for i=1:length(S.Nodes)
    scatter(nodeWheelList(1,i),nodeWheelList(2,i),'MarkerEdgeColor',[1,1,1],...
        'MarkerFaceColor',[1-nodeDepthList(i)/maxNodeWheel,0,nodeDepthList(i)/maxNodeWheel],'LineWidth',0.5);
    hold on;
end
hold off;
set(gcf, 'Color', 'White');
axis image; axis off;
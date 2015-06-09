function visualStalledSkel3d(Skel,typeVisual,spathStall,idxStalled,typeBranch)

% Plot blood vessel skeletons with xy slice image of chose stack number.
%
% Blood vessel render options:
% - Random Color Render
% - GoTracer Color Render
%
% Color:
% black       - stalled vessel
% rose        - shortest path to PA
% blue violet - shortest path to AV
%
% typeBranch - branching number
% typeBranch - vessel Length

if nargin<2
    typeVisual='stalled vessel';
elseif strcmpi(typeVisual,'stall branching')
    if nargin<3 || nargin<4 || nargin<5
    error('Error: not enough shortest path data selected!');
    end
end
typeVisual=lower(typeVisual);

daspect([1,1,1]); view(3);

switch typeVisual
    % render all stalled vessels
    case 'stalled vessel'
        for i=1:length(Skel)
            L=fnplt(cscvn(transpose(Skel{1,i})));
            if  Skel{2,i}==8
                plot3(L(1,:),L(2,:),L(3,:),'Color',[.8516,.6445,.1250],'LineWidth',3);
            end
            hold on;
        end
        hold off;
        
        % render specified stalled vessel and its branching path
    case 'stall branching'
        L=fnplt(cscvn(transpose(Skel{1,idxStalled})));
        plot3(L(1,:),L(2,:),L(3,:),'Color',[0,0,0],'LineWidth',3);
        hold on;
        
        typeBranch=lower(typeBranch);
        switch typeBranch
            case 'branching number'
                for i=1:size(spathStall,2)
                    paList=[];
                    avList=[];
                    if spathStall{1,i}.StalledVesselIndex==idxStalled
                        paList=[paList,spathStall{1,i}.Path2PAVesselIndex];
                        avList=[avList,spathStall{1,i}.Path2AVVesselIndex];
                    end
                    for j=1:length(paList)
                        L=fnplt(cscvn(transpose(Skel{1,paList(j)})));
                        plot3(L(1,:),L(2,:),L(3,:),'Color',[1,0.4,0.8],'LineWidth',1.5);
                        hold on;
                    end
                    for j=1:length(avList)
                        L=fnplt(cscvn(transpose(Skel{1,avList(j)})));
                        plot3(L(1,:),L(2,:),L(3,:),'Color',[0.5,0.2,0.8],'LineWidth',1.5);
                        hold on;
                    end
                end
            case'vessel length'
                for i=1:size(spathStall,2)
                    paList=[];
                    avList=[];
                    if spathStall{2,i}.StalledVesselIndex==idxStalled
                        paList=[paList,spathStall{1,i}.Path2PAVesselIndex];
                        avList=[avList,spathStall{1,i}.Path2AVVesselIndex];
                    end
                    for j=1:length(paList)
                        L=fnplt(cscvn(transpose(Skel{1,paList(j)})));
                        plot3(L(1,:),L(2,:),L(3,:),'Color',[1,0.4,0.8],'LineWidth',1.5);
                        hold on;
                    end
                    for j=1:length(avList)
                        L=fnplt(cscvn(transpose(Skel{1,avList(j)})));
                        plot3(L(1,:),L(2,:),L(3,:),'Color',[0.5,0.2,0.8],'LineWidth',1.5);
                        hold on;
                    end
                end
        end
end

% axis vis3d; axis equal;
camproj perspective; rotate3d on; box on;
axis normal; axis tight;
set(gcf, 'Color', 'White');
set(gca,'zdir','reverse');

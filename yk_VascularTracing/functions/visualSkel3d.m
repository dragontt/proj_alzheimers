function visualSkel3d(Skel,Render)

% Plot blood vessel skeletons with xy slice image of chose stack number.
%
% Blood vessel render options:
% - Random Color Render
% - GoTracer Color Render
% 
% Color code:
% 1 - dark blue     - Surface Venule
% 2 - dark red      - Surface Arteriole
% 3 - light blue    - Ascending Venule
% 4 - light red     - Penetrating Arteriole
% 5 - green         - Capillary

if nargin<2
    Render='Random Color Render';
end 

daspect([1,1,1]); view(3);

switch (lower(Render))
    case 'random color render'
        for i=1:length(Skel)
            L=transpose(Skel{1,i});
            L2=fnplt(cscvn(L));
            plot3(L2(1,:),L2(2,:),L2(3,:),'Color',rand(1,3),'LineWidth',2.5);
            hold on;
        end
        hold off;
    case 'gotracer color render'
        for i=1:length(Skel)
            L=transpose(Skel{1,i});
            L2=fnplt(cscvn(L));
            if Skel{2,i}==1
                plot3(L2(1,:),L2(2,:),L2(3,:),'Color',[0,0,.4],'LineWidth',3);
            elseif Skel{2,i}==2
                plot3(L2(1,:),L2(2,:),L2(3,:),'Color',[.4,0,0],'LineWidth',3);
            elseif Skel{2,i}==3
                plot3(L2(1,:),L2(2,:),L2(3,:),'Color',[0,0,.8],'LineWidth',3);
            elseif Skel{2,i}==4
                plot3(L2(1,:),L2(2,:),L2(3,:),'Color',[.8,0,0],'LineWidth',3);
            else
                plot3(L2(1,:),L2(2,:),L2(3,:),'Color',[0,.5,0],'LineWidth',1.5);
            end
            hold on;
        end
        hold off;
end

% axis vis3d; axis equal;
camproj perspective; rotate3d on; box on;
axis normal; axis tight;
set(gcf, 'Color', 'White');
set(gca,'zdir','reverse');

function visual3d(V,S,color)

% This function is used to visualize the iso-surface of the vessels and
% plot vessel skeletons.
%
% Input V: vessel volume
%       S: traced skeleton via fast marching method
%       color: color of the skeleton, choose 'random' or 'mono'

if nargin<3
    color='random';
end

disp('Rendering in Progress ...');
V=smooth3(V,'gaussian',9);
for i=1:size(V,3)
    V(:,:,i)=flipud(V(:,:,i));
end

isoval = 0.5;
patch(isosurface(V,isoval),'FaceColor','red','EdgeColor','none');
patch(isocaps(V,isoval),'FaceColor','interp','EdgeColor','none');
daspect([1,1,1]); view(3); axis image;
camlight('headlight'); lighting gouraud;
set(gcf, 'Color', 'White'); %axis off;

if (nargin>1)
    alpha(0.3);
    hold on;
    switch (lower(color))
        case 'random'
            for i=1:length(S)
                L=transpose(S{1,i});
                L2=fnplt(cscvn(L));
                plot3(L2(1,:),L2(2,:),L2(3,:),'Color',rand(1,3),'LineWidth',2.5);
                hold on;
            end
            hold off;
        case 'mono'
            for i=1:length(S)
                L=transpose(S{1,i});
                L2=fnplt(cscvn(L));
                plot3(L2(1,:),L2(2,:),L2(3,:),'-k','LineWidth',2.5);
                hold on;
            end
            hold off;
        otherwise
            error('No Skeleton Color Specified');
    end
end

disp('Rendering Completed');
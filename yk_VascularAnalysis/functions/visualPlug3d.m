function visualPlug3d(V_vessel,V_plug)

disp('Rendering in Progress');
% V=smooth3(V,'gaussian',9);

isoval = 0.5;
patch(isosurface(V_vessel,isoval),'FaceColor','red','EdgeColor','none');
patch(isocaps(V_vessel,isoval),'FaceColor','interp','EdgeColor','none');
daspect([1,1,1]); view(3); axis equal;
camlight('headlight'); lighting gouraud;
set(gcf, 'Color', 'White'); 
alpha(0.5);
hold on;

patch(isosurface(V_plug,isoval),'FaceColor',[0,.75,0],'EdgeColor','none');

disp('Rendering Completed');
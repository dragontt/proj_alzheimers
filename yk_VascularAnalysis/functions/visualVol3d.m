function visualVol3d(V_path2PA,V_path2AV,V_stall,flipZ)
% This function visualizes tissue terriotory along linepathes of stall
% vessel and its branching vessel

% Color Code:
% 6 - magenta       - Shortest Path to PA
% 7 - cyan          - Shortest Path to AV
% 8 - black         - Stalled Vessel

if nargin<4
    flipZ=0;
end

daspect([1,1,1]); view(3);

if flipZ==1
    V_path2PA=flipdim(squeeze(V_path2PA),1);
    V_path2PA=flipdim(squeeze(V_path2PA),3);
    V_path2AV=flipdim(squeeze(V_path2AV),1);
    V_path2AV=flipdim(squeeze(V_path2AV),3);
    V_stall=flipdim(squeeze(V_stall),1);
    V_stall=flipdim(squeeze(V_stall),3);
else 
    V_path2PA=flipdim(squeeze(V_path2PA),1);
    V_path2AV=flipdim(squeeze(V_path2AV),1);
    V_stall=flipdim(squeeze(V_stall),1);
end

isoval = 0.5;
patch(isosurface(V_path2PA,isoval),'FaceColor',[.8,0,.8],'EdgeColor','none');
patch(isocaps(V_path2PA,isoval),'FaceColor','interp','EdgeColor','none'); hold on;
patch(isosurface(V_path2AV,isoval),'FaceColor',[0,.8,.8],'EdgeColor','none');
patch(isocaps(V_path2AV,isoval),'FaceColor','interp','EdgeColor','none'); hold on;
patch(isosurface(V_stall,isoval),'FaceColor',[1,1,0],'EdgeColor','none');
patch(isocaps(V_stall,isoval),'FaceColor','interp','EdgeColor','none'); hold off;
alpha(0.2);

camproj perspective; rotate3d on; box on;
axis normal; axis tight;
set(gcf, 'Color', 'White');
set(gca,'zdir','reverse');
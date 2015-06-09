function visualSlice3d(im,stackNum,color,flipZ)
% This function renders a single slice of image stack

if nargin<2
    stackNum=round(size(im,3)/2);
    color='gray';
    flipZ=0;
elseif nargin<3
    color='gray';
    flipZ=0;
elseif nargin<4
    flipZ=0;
end

daspect([1,1,1]); view(3);

dim=size(im);
if flipZ==1
    imSlice=im(:,:,dim(3)-stackNum);
else 
    imSlice=im(:,:,stackNum);
end

surface('XData',[0 dim(2);0 dim(2)],'YData',[0 0;dim(1) dim(1)],'ZData',...
    [stackNum stackNum;stackNum stackNum],'CData',imSlice,'FaceColor','texturemap');
colormap(color); alpha(0.8);

camproj perspective; rotate3d on; box on;
axis normal; axis tight;
set(gcf, 'Color', 'White');
set(gca,'zdir','reverse');
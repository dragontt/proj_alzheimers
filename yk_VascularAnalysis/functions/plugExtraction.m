function V=plugExtraction(im,thdWt,xScale,sizeCloseSE)

%{
% Make sure the image is 8-bit, 'importtif' function can only take 8-bit
im_vessel=importtif('JC_PlugsImage/RGB C (red).tif');
im_plug=importtif('JC_PlugsImage/(391C)placas_8bit.tif');

% Use 'plugExtraction' function to extract and preseve plug morpholgy, with
% proper parameters
% Parameters: im_plug - 3d image matrix of plugs
%             thdWt - weights to control thresholding in each image slice
%             xScale - times of pixelation scale used for background
%                      subtraction
%             sizeCloseSE - size of 'disk' structure used in image closing
V_plug=plugExtraction(im_plug,3,10,5);'

% Render plugs and vessels in 3d
figure; visualPlug3d(V_vessel,V_plug);
%}

if nargin==1
    thdWt=3;
    xScale=10;
    sizeCloseSE=5;
end

% create mask to extract plug features
mask=imthreshold(im,thdWt);
im2=im.*mask;

% background subraction for denoising
im2=ScaleSpace(im2,xScale);

% binarize image
V=imprep(im2,5,1.5);

% use morphological opening along z-direction to fill gaps and smooth edges
se=strel('disk',sizeCloseSE);
for i=1:size(V,3)
    V(:,:,i)=imclose(squeeze(V(:,:,i)),se);
end
disp('Image closing completed');

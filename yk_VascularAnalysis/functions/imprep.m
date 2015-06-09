function V=imprep(im,gauSize,windowSize,offset,numElim,isHoleFill,isBgSub,paramBgSub)

% This function preprocesses 3d image data via background subtraction,
% Gaussian filtering in 3d, adaptive thresholding method, hole filling,
% small connected component elimination. 
% 
% Input:
% im          - gray scale image
% gauSize     - size of 3d gaussian filtering, sigma = gauSize/2/2.354
% windowSize  - window size of mean filtering in adaptive thresholding 
% offset      - offset of adaptive thresholding
% numElim     - threshold of connected component
% isHoleFill  - (optional) 1 = turn on hole fill
%                          0 = turn off hole fill
% isBgSub     - (optional) 1 = turn on background subtraction using TopHat
%                          0 = turn off background subtraction
% numScale    - (optional) level of scale space
%                          default 3, if background subtraction is called

if nargin<6
    error('Not enough input!');
elseif nargin<7
    isHoleFill=1;
    isBgSub=0;
elseif nargin<8
    paramBgSub=40;
end

wb=waitbar(0,'Raw Image Preprocessing');

% Background subtraction using scale space method
waitbar(1/5,wb,'Raw Image Preprocessing (1/5)');
if isBgSub
    im=backgndsubtraction(im,'TopHat',paramBgSub);
end

% Blur image with 3d gaussian kernel
waitbar(2/5,wb,'Raw Image Preprocessing (2/5)');
h=fspecial3('gaussian',[gauSize gauSize gauSize]);
im=imfilter(im,h);

% Threshold image using adaptive thresholding method
waitbar(3/5,wb,'Raw Image Preprocessing (3/5)');
im=imthreshold3(im,windowSize,offset);

% Fill holes of thresholded image
waitbar(4/5,wb,'Raw Image Preprocessing (4/5)');
if isHoleFill
    sizeHoleFill=100;
    im=imholefill(im,sizeHoleFill);
end

% Eliminate small vessel objects
waitbar(5/5,wb,'Raw Image Preprocessing (5/5)');
im=elimsobj(im,26,numElim);

V=im;
delete(wb);

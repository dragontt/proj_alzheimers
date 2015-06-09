function V=imprep(im,gauSize,thdWt)

% This function preprocesses 3d image data via blurring, thresholding, hole
% filling, and small object eliminating in sequence.
% 
% Input im: image data
%       gauSize: size of gaussian filter
%       thdWt: weight of standard deviation on threshold value
% Output V: processed image data in logical class

if nargin==1
    gauSize=5;
    thdWt=0.5;
end

disp('Image Preprocessing in Progress:');

% Blur image with 3d gaussian kernel
h=fspecial3('gaussian',[gauSize gauSize gauSize]);
im=imfilter(im,h);
disp('  Gaussian Filtering Completed');

% Threshold image
im=imthreshold(im,thdWt);
disp('  Thresholding Completed');

% Fill holes of thresholded image
im=imfill(im,'holes');
disp('  Hole Filling Completed');

% Eliminate small vessel objects
im=elimsobj(im,26,1000);
disp('  Small Oject Elimination Completed');

V=im;
disp('Preprocessing Completed');

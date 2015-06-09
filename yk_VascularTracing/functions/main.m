close all; clear; clc;

% Start timer
tStart=tic;

% Compile c file msfm3d.c
files=dir('*.c');
clear msfm3d
mex('msfm3d.c');

% Read vessel image
%{
im=importtif('images/test_stack_0.5x.tif');
% im=imtrim(im,[256,256,86],[512,512,172]);
% im=imtrim(im,[340,80,60],[90,90,60]);
im=imtrim(im,[128,128,86],[256,256,172]);
%}
im=importtif('/Users/schafferlab/Documents/MATLAB/yk_Data/AD834/AD 834 d0/bw_512 a 575 645 2x pre003.tif');
im=im(:,:,1:end-15);

% Preprocess image
V=imprep(ScaleSpace(im,4),5,1.5);

% Use fast marching method to find the skeleton
S=skeleton(V,'simple');

% Build structure of blood vessel skeleton
SS=BuildStructure(S);

% Visualize the vessels and skeletons
% visual3d(V,S,'random');

% Display elapsed time
tElapsed = toc(tStart);
disp(['Program Elapsed Time : ',num2str(tElapsed),' sec']);

% save mat file
save /Users/schafferlab/Documents/MATLAB/yk_Data/AD834/AD 834 d0/bw_512 a 575 645 2x pre003.mat;

%{
% Export stl data
fv=isosurface(V, 0.99); % Create the patch object
stlwrite('testvolume.stl',fv) % Save to binary .stl
%}
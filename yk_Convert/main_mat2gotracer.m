% This script converts matlab structure file to gotracer file
clear;

% Import matlab structure file
fileIn=struct;
[fileIn.fn fileIn.pn]=uigetfile('*.mat','Browse');
load(strcat(fileIn.pn,fileIn.fn));

% Export setup
fileOut=struct;
[fileOut.fn,fileOut.pn]=uiputfile('*.gotrace');
dimX=size(im,1);
dimY=size(im,2);
micronPerPixel=1;

% Converts a structure exported from matlab into a vectorized structure,
% then convert the vectroized structure into gotracer format
SVectorized=goTrace_toVectorized(SS);
GOTracerReadableFile=ExportToGOTracer(SVectorized,dimX,dimY,micronPerPixel,fileOut.pn); 
output=structToXMLPlist(GOTracerReadableFile);
h=fopen(strcat(fileOut.pn,fileOut.fn),'w'); 
fwrite(h,output);
fclose(h);
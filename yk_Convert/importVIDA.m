function importVIDA(vectorizedStructure,fname)
%Creates a goTrace file from a vectorized structure with the name in fname.
dimX=512;
dimY=512;
micronperpixel=1;
imagePath='test';
fname=[fname,'.gotrace'];

GOTracerReadableFile=ExportToGOTracer(vectorizedStructure,dimX,dimY,micronperpixel,imagePath ); 
test=structToXMLPlist(GOTracerReadableFile);
%had to run 2x?  
%save: test is is mame 
h=fopen(fname,'w'); 
fwrite(h, test);
fclose(h);
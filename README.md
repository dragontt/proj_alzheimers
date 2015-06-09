# proj_alzheimers

This project serves as an automated parallelized solution for cerebral vascular network extraction and vasculature analysis. The ultimate goal is to understand the physiological process and disorder of Alzheimer's disease progression over time. Vascular network extraction is essential in identifying the axis of blood flow pathways and their connectivity, as well as characterizing the morpholgy of stalled vs normal vessel segments. Plug extraction and analysis serves as another set of automated tools to portray the relationship between beta-amyloid plaque and stalled location. 

### Vascular Extraction

- Performs a series of image preprocessing steps including: background substraction, object smoothing, hold filling, adaptive thresholding, and object denosing;
- Computes distance transform of the foreground object, served as the speed image;
- Split the volume into subdivision for parallelized axis tracing;
- Propogates the center axis tracing based on the neighbor's speed value, and forms a front of propogation;
- Iterates such propogation at the current front while freezes the visited voxels;
- Stops the propogation once reaches low speed voxel;
- Stiches the linepaths traced in subdivisions together;
- Outputs vessel segments containing the linepath of traced vessel axis in image stack volume and its connection to branch node; and outputs branch/end node containing the location and its connectvity to segment

### Vascular Analysis

- Fixes plist structure, skeleton alignment and shift to vasculature image stack;
- Segments vasculature; 
- Computes vascular morphology, and analyzes statistics;
- Computes the shortest path from stalled vessel to penetrating artery (PA) and ascending vein (AV) respectively, and analyzes statistics;
- Computes tissue volume corresponding to its nearest vasculature

Check Vascular Auto Tracing Manual.pdf for detailed instructions.
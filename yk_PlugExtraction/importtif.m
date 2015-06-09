function im = importtif(filename,verbose)

% This function imports tiff image stacks into Matlab matrix
%
% Input filename: file name of tiff image
% Output im: 3D volumetric image data

if nargin==1
    verbose=1;
end

infoim = imfinfo(filename);
him = infoim(1).Width;
wim = infoim(1).Height;
stackim = length(infoim);
chim = 3;

if strcmp(infoim(1).PhotometricInterpretation,'BlackIsZero') == 1  
    im = NaN(wim,him,stackim);
    for k = 1:stackim
        im(:,:,k) = imread(filename,'Index',stackim-k+1);
    end
    
elseif strcmp(infoim(1).PhotometricInterpretation,'RGB') == 1
    im = NaN(wim,him,stackim,chim);
    for k = 1:stackim
        im(:,:,k,:) = imread(filename, k, 'Info', infoim);
    end
else
    fprintf('Unexpected TIF image color type');
end

if verbose
    disp('Tiff Image Import Completed');
end
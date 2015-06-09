function im = importtif(filename)

% This function imports tiff image stacks into Matlab matrix
%
% Input filename: file name of tiff image
% Output im: 3D volumetric image data

infoim = imfinfo(filename);
him = infoim(1).Width;
wim = infoim(1).Height;
stackim = length(infoim);
chim = 3;

if strcmp(infoim(1).PhotometricInterpretation,'BlackIsZero') == 1  
    im = NaN(wim,him,stackim);
    for k = 1:stackim
        im(:,:,k) = imread(filename,'Index',k);
    end
    
elseif strcmp(infoim(1).PhotometricInterpretation,'RGB') == 1
    im = NaN(wim,him,stackim,chim);
    for k = 1:stackim
        im(:,:,k,:) = imread(filename, k, 'Info', infoim);
    end
else
    fprintf('Unexpected TIF image color type');
end

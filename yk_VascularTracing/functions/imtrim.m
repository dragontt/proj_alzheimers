function imOut = imtrim(im, imctr, imdim)

% Trim the original image by preserving desired volume
% im = origianl image
% imctr = center of trimed volume, in vector format
% imdim = size of trimed volume, in vector format

imOut = im((imctr(1)-floor((imdim(1)-1)/2)):(imctr(1)+floor(imdim(1)/2)),...
    (imctr(2)-floor((imdim(2)-1)/2)):(imctr(2)+floor(imdim(2)/2)),...
    (imctr(3)-floor((imdim(3)-1)/2)):(imctr(3)+floor(imdim(3)/2)));
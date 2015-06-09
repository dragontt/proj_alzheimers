function imOut=imthreshold3(im,windowSize,offset)
% This function uses adaptive thresholding algorithm.

if nargin<2
    windowSize=85;
    offset=-9;
elseif nargin<3
    offset=-9;
end

dim=size(im);
imOut=zeros(dim);
if length(dim)==2
    imOut=AdaptiveThresholding(im,windowSize,offset);
elseif length(dim)==3
    for n=1:dim(3)
        imOut(:,:,n)=AdaptiveThresholding(im(:,:,n),windowSize,offset);
    end
end
imOut=logical(imOut);
end

function im3=AdaptiveThresholding(im,windowSize,offset)
% im2=imfilter(im,fspecial('average',windowSize),'replicate');
im2=imfilter(im,fspecial('average',windowSize),255);
im3=im2bw(im2-im-offset);
im3=imcomplement(im3);
end
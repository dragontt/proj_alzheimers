function imOut=imthreshold2(im,weight,windowSize)
% This function uses local adaptive algorithm to threshold image pixel by
% pixel. For individual pixel, compute the mean intensity and standard
% deviation (std) of all neighbor pixels with in certain window.
% Then do math: threshold = mean + std * weight

if nargin<2
    windowSize=9;
    weight=1;
elseif nargin<3
    windowSize=9;
end

dim=size(im);
imOut=zeros(dim);
if length(dim)==2
    imOut=LocalAdaptiveThresholding(im,weight,windowSize);
elseif length(dim)==3
    for n=1:dim(3)
        imOut(:,:,n)=LocalAdaptiveThresholding(im(:,:,n),weight,windowSize);
    end
end
imOut=logical(imOut);
end

function im3=LocalAdaptiveThresholding(im,weight,windowSize)
nBoundary=floor(windowSize/2);
im2=NaN(size(im)+nBoundary*2);
im2(1+nBoundary:size(im,1)+nBoundary,1+nBoundary:size(im,2)+nBoundary)=im;
im3=zeros(size(im2));
for i=1+nBoundary:size(im,1)+nBoundary
    for j=1+nBoundary:size(im,2)+nBoundary
        imNeighbor=im2(i-nBoundary:i+nBoundary,j-nBoundary:j+nBoundary);
        imNeighbor2=imNeighbor(isfinite(imNeighbor));
        thld=mean(imNeighbor2)+std(imNeighbor2)*weight;
        if im2(i,j)>=thld
            im3(i,j)=1;
        else
            im3(i,j)=0;
        end
    end
end
im3=im3(1+nBoundary:size(im,1)+nBoundary,1+nBoundary:size(im,2)+nBoundary);
end
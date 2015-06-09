function imOut=ScaleSpace(im,xScale)

% This function (background subtraction) uses scale space approach to
% eliminate lumination variance of image background.
%
% Input: im = input image
%        xScale = times of scale needed
%        widthBoundary = width of the image boundary not to be subtracted
% Output: imOut = output image

if nargin==1
    xScale=3;
end

dim=size(im);
imOut=im-50;

% apply scale space for background subtraction
if length(dim)==2
    imOut=MathScaleSpace(im,dim,xScale);
else
    for i=1:dim(3)
        imOut(:,:,i)=MathScaleSpace(im(:,:,i),dim,xScale);
    end
end
end

function imOut=MathScaleSpace(im,dim,xScale)
bg=im;
for k=1:xScale
    bg=imresize(bg,0.5);
end
bg=imresize(bg,2^xScale);
bg=imresize(bg,[dim(1),dim(2)]);

imOut=im-bg;
imOut(imOut<0)=0;

end

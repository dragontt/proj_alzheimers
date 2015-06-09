function imOut=ScaleSpace(im,xScale,widthBoundary)

% This function (background subtraction) uses scale space approach to 
% eliminate lumination variance of image background.
%
% Input: im = input image
%        xScale = times of scale needed
%        widthBoundary = width of the image boundary not to be subtracted
% Output: imOut = output image

if nargin==1
    xScale=3;
    widthBoundary=10;
elseif nargin==2
    widthBoundary=10;
end

dim=size(im);
imOut=im-50;
hsize=[5,5]; sigma=1;
w=widthBoundary;

if length(dim)==2
    bg=im;
    for k=1:xScale
        h=fspecial('gaussian',hsize,sigma);
        bg=imfilter(bg,h,'same');
        bg=imresize(bg,0.5);
    end
    bg=imresize(bg,2^xScale);
    imOut(w+1:end-w,w+1:end-w)=im(w+1:end-w,w+1:end-w)-bg(w+1:dim(1)-w,w+1:dim(2)-w);
    
else
    for i=1:dim(3)
        bg=im(:,:,i);
        for k=1:xScale
            h=fspecial('gaussian',hsize,sigma);
            bg=imfilter(bg,h,'same');
            bg=imresize(bg,0.5);
        end
        bg=imresize(bg,2^xScale);
        imOut(w+1:end-w,w+1:end-w,i)=im(w+1:end-w,w+1:end-w,i)-bg(w+1:dim(1)-w,w+1:dim(2)-w);
    end
end

disp('Background subtraction completed');
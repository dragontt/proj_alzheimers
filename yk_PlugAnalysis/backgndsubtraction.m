function imOut=backgndsubtraction(im,method,param)

% This function (background subtraction) uses scale space approach to
% eliminate lumination variance of image background.
%
% Input: im     - input image
%        method - options are 'ScaleSpace' and 'TopHat' (default)
%        param  - if 'ScaleSpace', times of scale needed, default =3
%               - if 'TopHat', radius of SE, default =40
% Output: imOut - output image

if nargin<2
    method='tophat';
    param=40;
elseif nargin<3 && strcmpi(method,'scalespace')
    param=3;
elseif nargin<3 && strcmpi(method,'tophat')
    param=40;
end

dim=size(im);

switch lower(method)
    case 'scalespace'
        % apply scale space algorithm
        imOut=im-50;
        if length(dim)==2
            imOut=ScaleSpace(im,dim,param);
        else
            parfor i=1:dim(3)
                imOut(:,:,i)=ScaleSpace(im(:,:,i),dim,param);
            end
        end
        
    case 'tophat'
        % apply top hat transformation algorithm
        imOut=im;
        if length(dim)==2
            imOut=TopHat(im,param);
        else
            parfor i=1:dim(3)
                imOut(:,:,i)=TopHat(im(:,:,i),param);
            end
        end
end
end


function imOut=ScaleSpace(im,dim,param)
bg=im;
for k=1:param
    bg=imresize(bg,0.5);
end
bg=imresize(bg,2^param);
bg=imresize(bg,[dim(1),dim(2)]);

imOut=im-bg;
imOut(imOut<0)=0;
end

function imOut=TopHat(im,param)
SE=strel('disk',param,8);
bg=imopen(im,SE);
imOut=im-bg;
end


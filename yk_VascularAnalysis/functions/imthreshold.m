function imThd=imthreshold(im,method,val)

% This function threshold vessel image by setting up the threshold value of
% the median value and standard deviation multiplied by weight of each image
% slice.
%
% Input: im - 2d or 3d image matrix
%        method - choose either 'variance-weighted' threshold method,
%             'absolute' threshold method
%        val - in case of var-weighted, val is the weight applied on var;
%             in the other case, val is the absolute threshold value
% Output: imthd - thresholded image in logical class

if nargin<3
    val=1;
elseif nargin<2
    method='variance-weighted';
    val=1;
end

dim=size(im);
imThd=zeros(dim);

switch (lower(method))
    case 'variance-weighted'
        if length(dim)==2
            thd=median(im(:))+val*std(im(:));
            thdMask=thd*ones(dim(1),dim(2));
            imThd=im>thdMask;
        else
            imThd=zeros(dim);
            for i=1:dim(3)
                imSlice=im(:,:,i);
                thd=median(imSlice(:))+val*std(imSlice(:));
                thdMask=thd*ones(dim(1),dim(2));
                imThd(:,:,i)=imSlice>thdMask;
            end
        end
        
    case 'absolute'
        if length(dim)==2
            thd=val;
            thdMask=thd*ones(dim(1),dim(2));
            imThd=im>thdMask;
        else
            imThd=zeros(dim);
            for i=1:dim(3)
                imSlice=im(:,:,i);
                thd=val;
                thdMask=thd*ones(dim(1),dim(2));
                imThd(:,:,i)=imSlice>thdMask;
            end
        end
end

imThd=logical(imThd);


function imThd = imthreshold(im,alpha)

% This function threshold vessel image by setting up the threshold value of
% the median value and standard deviation multiplied by weight of each image
% slice. 
%
% Input im: image data
%       alpha: weight applied on standard deviation
% Output imthd: thresholded image in logical class

s = size(im);
imThd=zeros(s);
for k = 1:s(3)
    slice=im(:,:,k);
    thd=median(slice(:))+alpha*std(slice(:));
    for j=1:s(2)
        for i=1:s(1)
            if im(i,j,k) >= thd
                imThd(i,j,k)=1;
            end
        end
    end
end
imThd=logical(imThd);
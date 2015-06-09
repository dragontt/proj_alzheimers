function imElim=elimsobj(im,numconn,tol)

% This function eliminates small vessel object in which size of the
% connected component is smaller than tolerance value.
%
% Input im: image data
%       numconn: number of connected components
%       tol: tolerance value
% Output imElim: cleaned up version of the image in logical class

CC=bwconncomp(im,numconn);
for m=1:CC.NumObjects
    [I,J,K]=ind2sub(CC.ImageSize,CC.PixelIdxList{m});
    if (length(I)<tol)
        for n=1:length(I)
            im(I(n),J(n),K(n))=0;
        end
    end
end
imElim=logical(im);

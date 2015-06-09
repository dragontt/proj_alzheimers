function mask=GetBinaryMask(im,hasMask)

mask=logical(ones(size(im)));

if hasMask
    h=fspecial('gaussian',20,0.5);
    for i=1:size(im,3)
        im(:,:,i)=imfilter(im(:,:,i),h,'replicate');
    end
    mask(im==0)=0;
    mask=imcomplement(mask);
   
    CC=bwconncomp(mask,6);
    for i=1:CC.NumObjects
        if length(CC.PixelIdxList{i})<10000
            mask(CC.PixelIdxList{i})=0;
        end
    end
    
    mask=imcomplement(mask);
end


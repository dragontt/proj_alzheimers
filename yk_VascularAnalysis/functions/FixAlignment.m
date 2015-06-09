function im3=FixAlignment(im)
% This function aligns volumetric image and vessel ceterline by flip X
% dimension and rotating image by -90 degress, for the purpose of
% demonstration.

im2=[];
im3=[];
im2=im(end:-1:1,:,:);
for i=1:size(im,3)
    im3(:,:,i)=imrotate(im2(:,:,i),-90);
end


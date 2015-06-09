function V=getCCgpVolume(CCgp,idx)
% This function splits master volume into subvolumes.

[I,J,K]=ind2sub(CCgp{3,idx},CCgp{1,idx});
V=zeros(CCgp{3,idx});
for n=1:length(I)
    V(I(n),J(n),K(n))=1;
end
V=logical(V);
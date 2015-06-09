function ll=GetLineLength(L)
% Compute the Euclidean length of a line

dist=sqrt((L(2:end,1)-L(1:end-1,1)).^2+ ...
    (L(2:end,2)-L(1:end-1,2)).^2+ ...
    (L(2:end,3)-L(1:end-1,3)).^2);

ll=sum(dist);

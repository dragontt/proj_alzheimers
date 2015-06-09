function out=OrganizeSkeleton(SkeletonSegments)
% Rearrange the order of skeleton points

n=length(SkeletonSegments);
if n>0
    Endpoints=zeros(n*2,3);
    l=1;
    
    for w=1:n
        ss=SkeletonSegments{w};
        l=max(l,length(ss));
        Endpoints(w*2-1,:)=ss(1,:);
        Endpoints(w*2,:)=ss(end,:);
    end
    CutSkel=spalloc(size(Endpoints,1),l,10000);
    ConnectDistance=2^2;
    
    for w=1:n
        ss=SkeletonSegments{w};
        ex=repmat(Endpoints(:,1),1,size(ss,1));
        sx=repmat(ss(:,1)',size(Endpoints,1),1);
        ey=repmat(Endpoints(:,2),1,size(ss,1));
        sy=repmat(ss(:,2)',size(Endpoints,1),1);
        ez=repmat(Endpoints(:,3),1,size(ss,1));
        sz=repmat(ss(:,3)',size(Endpoints,1),1);
        
        D=(ex-sx).^2+(ey-sy).^2+(ez-sz).^2;
        
        check=min(D,[],2)<ConnectDistance;
        check(w*2-1)=false; check(w*2)=false;
        
        if (any(check))
            j=find(check);
            for i=1:length(j)
                line=D(j(i),:);
                [foo,k]=min(line);
                if ((k>2)&&(k<(length(line)-2)))
                    CutSkel(w,k)=1;
                end
            end
        end
    end
    
    pp=0;
    for w=1:n
        ss=SkeletonSegments{w};
        r=[1 find(CutSkel(w,:)) length(ss)];
        for i=1:length(r)-1
            try
                pp=pp+1;
                out{pp}=ss(r(i):r(i+1),:);
            end
        end
    end
else
    out=SkeletonSegments;
end
%     t = getCurrentTask(); 
%     disp([t.ID size(out)]);
%     disp(size(out));

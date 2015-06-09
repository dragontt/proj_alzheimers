function S=stitchCCSkel(S,mask,threshold)
% This function stitches skeletons in subvolume if they are in the same
% connect component group as adjuncted neighbors

if nargin<3
    threshold=10; % threshold to connect, in pixels
end

% build adjacency matrix of neighbor subvolumes
adjMtxNb=...
    [0,1,0,0,1,1,0,0,0,0,0,0,0,0,0,0;
    0,0,1,0,1,1,1,0,0,0,0,0,0,0,0,0;
    0,0,0,1,0,1,1,1,0,0,0,0,0,0,0,0;
    0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0;
    0,0,0,0,0,1,0,0,1,1,0,0,0,0,0,0;
    0,0,0,0,0,0,1,0,1,1,1,0,0,0,0,0;
    0,0,0,0,0,0,0,1,0,1,1,1,0,0,0,0;
    0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0;
    0,0,0,0,0,0,0,0,0,1,0,0,1,1,0,0;
    0,0,0,0,0,0,0,0,0,0,1,0,1,1,1,0;
    0,0,0,0,0,0,0,0,0,0,0,1,0,1,1,1;
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1;
    0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0;
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0;
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1;
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];

% build adjacency matrix (half diagonal)
adjMtxPairedS=zeros(length(S));
for i=1:length(S)-1
    for j=i+1:length(S)
        if adjMtxNb(mask(1,i),mask(1,j))==1
            adjMtxPairedS(i,j)=1;
        end
    end
end

% stitch the nodes of the skeleton segments
s2Add=cell(1,length(S));
parfor i=1:length(S)
    iConn2js=find(adjMtxPairedS(i,:));
    for j=1:length(iConn2js)
        d1=pdist([S{i}(1,:);S{iConn2js(j)}(1,:)]);
        d2=pdist([S{i}(1,:);S{iConn2js(j)}(end,:)]);
        d3=pdist([S{i}(end,:);S{iConn2js(j)}(1,:)]);
        d4=pdist([S{i}(end,:);S{iConn2js(j)}(end,:)]);
        % stitch segments by creating short fragment in between
        if d1<threshold
            pti=S{i}(1,:); ptj=S{iConn2js(j)}(1,:);
            sNew=fnplt(cscvn([pti(1),pti(2),pti(3);ptj(1),ptj(2),ptj(3)]'))';
            sNew=unique(round(sNew),'rows');
            s2Add{i}{length(s2Add{i})+1}=sNew;
        end
        if d2<threshold
            pti=S{i}(1,:); ptj=S{iConn2js(j)}(end,:);
            sNew=fnplt(cscvn([pti(1),pti(2),pti(3);ptj(1),ptj(2),ptj(3)]'))';
            sNew=unique(round(sNew),'rows');
            s2Add{i}{length(s2Add{i})+1}=sNew;
        end
        if d3<threshold
            pti=S{i}(end,:); ptj=S{iConn2js(j)}(1,:);
            sNew=fnplt(cscvn([pti(1),pti(2),pti(3);ptj(1),ptj(2),ptj(3)]'))';
            sNew=unique(round(sNew),'rows');
            s2Add{i}{length(s2Add{i})+1}=sNew;
        end
        if d4<threshold
            pti=S{i}(end,:); ptj=S{iConn2js(j)}(end,:);
            sNew=fnplt(cscvn([pti(1),pti(2),pti(3);ptj(1),ptj(2),ptj(3)]'))';
            sNew=unique(round(sNew),'rows');
            s2Add{i}{length(s2Add{i})+1}=sNew;
        end
    end
end
for i=1:length(s2Add)
    if ~isempty(s2Add{i})
        for j=1:length(s2Add{i})
            S=[S,s2Add{i}{j}];
        end
    end
end

%% Method 2

% % find the nonzeros in adjacency matrix
% labelLPBreakPt=cell(1,length(S));
% for i=1:length(S)
%     tmpConnectedS=find(adjMtxPairedS(i,:));
%     minDistList=[];
%     minPairedList=[];
%     minLPIdxiiList=[];
%     minLPIdxjjList=[];
%     for j=1:length(tmpConnectedS)
%         % find the shorest connection between two linepath points
%         distMtx=pdist2(S{i},S{tmpConnectedS(j)},'euclidean');
%         [localMinDist,localMinIdx]=min(distMtx(:));
%         if localMinDist<threshold
%             minDistList=[minDistList,localMinDist];
%             minPairedList=[minPairedList,tmpConnectedS(j)];
%             [tmpLPIdxii,tmpLPIdxjj]=ind2sub(size(distMtx),localMinIdx);
%             minLPIdxiiList=[minLPIdxiiList,tmpLPIdxii];
%             minLPIdxjjList=[minLPIdxjjList,tmpLPIdxjj];
%         end
%     end
%
%     if ~isempty(minPairedList)
%         % add interpolated segment
%         for j=1:length(minPairedList)
%             ptI=S{i}(minLPIdxiiList(j),:);
%             ptJ=S{minPairedList(j)}(minLPIdxjjList(j),:);
%             sNew=fnplt(cscvn([ptI(1),ptI(2),ptI(3);ptJ(1),ptJ(2),ptJ(3)]'))';
%             sNew=unique(round(sNew),'rows');
%             S=[S,sNew];
%             % add break index point to split j_th skeleton segment
%             labelLPBreakPt{minPairedList(j)}=[labelLPBreakPt{minPairedList(j)},minLPIdxjjList(j)];
%         end
%         % add break index point to split i_th skeleton segment
%         labelLPBreakPt{i}=minLPIdxiiList;
%     end
% end
%
% % split skeleton segment as labeled
% for i=1:length(labelLPBreakPt)
%     if ~isempty(labelLPBreakPt{i})
%         labelSorted=unique(sort(labelLPBreakPt{i}));
%         sNew1={S{i}(1:labelSorted(1),:)};
%         sNew2={S{i}(labelSorted(end):end,:)};
%         if length(sNew1)>threshold*1.5
%             S=[S,sNew1];
%         end
%         if length(sNew2)>threshold*1.5
%             S=[S,sNew2];
%         end
%         if length(labelSorted)>1
%             for j=1:length(labelSorted)-1
%                 S=[S,{S{i}(labelSorted(j):labelSorted(j+1),:)}];
%             end
%         end
%         S{i}={};
%     end
% end
%
% S=S(~cellfun('isempty',S));


%% Method 1
% % find the nonzeros in adjacency matrix
% SNew=cell(1,length(S));
% labelDelS=[];
% for i=1:length(S)
%     tmpConnectedS=find(adjMtxPairedS(i,:));
%     tmpArray=zeros(3,length(tmpConnectedS));
%     for j=1:length(tmpConnectedS)
%         % find the shorest connection between two linepath points
%         distMtx=pdist2(S{i},S{tmpConnectedS(j)},'euclidean');
%         [localMinDist,localMinIdx]=min(distMtx(:));
%         [localMinii,localMinjj]=ind2sub(size(distMtx),localMinIdx);
%         tmpArray(1,j)=localMinDist;
%         tmpArray(2,j)=localMinii;
%         tmpArray(3,j)=localMinjj;
%     end
%     [globalMinDist,arrayIdx]=min(tmpArray(1,:));
%     globalMinii=tmpArray(2,arrayIdx);
%     globalMinjj=tmpArray(3,arrayIdx);
%
%     if globalMinDist<threshold
%         ptI=S{i}(globalMinii,:);
%         ptJ=S{tmpConnectedS(arrayIdx)}(globalMinjj,:);
%         tmpSNew=fnplt(cscvn([ptI(1),ptI(2),ptI(3);ptJ(1),ptJ(2),ptJ(3)]'))';
%         tmpSNew=unique(round(tmpSNew),'rows');
%         SNew{i}{1}=[ptI;tmpSNew;ptJ];
%         % add split original skeleton segments
%         SNew{i}{2}=S{i}(1:globalMinii,:);
%         SNew{i}{3}=S{i}(globalMinii:end,:);
%         SNew{i}{4}=S{tmpConnectedS(arrayIdx)}(1:globalMinjj,:);
%         SNew{i}{5}=S{tmpConnectedS(arrayIdx)}(globalMinjj:end,:);
%         % black out the skeleton connected to
%         adjMtxPairedS(:,tmpConnectedS(arrayIdx))=0;
%         labelDelS=[labelDelS,i,tmpConnectedS(arrayIdx)];
%     end
% end
%
% % delete original skeletons that have been connected
% for i=1:length(labelDelS)
%     S{labelDelS(i)}={};
% end
%
% % add new segments to skeleton list
% for i=1:length(SNew)
%     if ~isempty(SNew{i})
%         tmpSNew=SNew{i};
%         for k=2:5
%             if size(SNew{i}{k},1)<=4
%                 tmpSNew{k}={};
%             end
%         end
%         tmpSNew=tmpSNew(~cellfun('isempty',tmpSNew));
%
%         if length(tmpSNew)==2
%             S12=ConnectTwoSegs(tmpSNew{1},tmpSNew{2});
%             S=[S,S12];
%         elseif length(tmpSNew)==3
%             tmpDist=pdist2([tmpSNew{2}(1,:);tmpSNew{2}(end,:)],...
%                 [tmpSNew{3}(1,:);tmpSNew{3}(end,:)]);
%             [minDist23,~]=min(tmpDist(:));
%             if minDist23<=sqrt(3)
%                 S23=ConnectTwoSegs(tmpSNew{2},tmpSNew{3});
%                 S=[S,S23];
%             else
%                 S12=ConnectTwoSegs(tmpSNew{1},tmpSNew{2});
%                 [minDist123,~]=min(pdist2([tmpSNew{3}(1,:);tmpSNew{3}(end,:)],[S12(1,:);S12(end,:)]));
%                 if minDist123==0
%                     S123=ConnectTwoSegs(tmpSNew{1},S23);
%                     S=[S,S123];
%                 else
%                     S23=ConnectTwoSegs(tmpSNew{2},tmpSNew{3});
%                     S=[S,S23];
%                 end
%             end
%         elseif length(tmpSNew)==4
%             tmpDist23=pdist2([tmpSNew{2}(1,:);tmpSNew{2}(end,:)],...
%                 [tmpSNew{3}(1,:);tmpSNew{3}(end,:)]);
%             tmpDist34=pdist2([tmpSNew{4}(1,:);tmpSNew{4}(end,:)],...
%                 [tmpSNew{3}(1,:);tmpSNew{3}(end,:)]);
%             tmpDist24=pdist2([tmpSNew{2}(1,:);tmpSNew{2}(end,:)],...
%                 [tmpSNew{4}(1,:);tmpSNew{4}(end,:)]);
%             [minDist23,~]=min(tmpDist23(:));
%             [minDist34,~]=min(tmpDist34(:));
%             [minDist24,~]=min(tmpDist24(:));
%             if minDist23==0
%                 S14=ConnectTwoSegs(tmpSNew{1},tmpSNew{4});
%                 S=[S,S14,tmpSNew{2},tmpSNew{3}];
%             elseif minDist34==0
%                 S12=ConnectTwoSegs(tmpSNew{1},tmpSNew{2});
%                 S=[S,S12,tmpSNew{3},tmpSNew{4}];
%             elseif minDist24==0
%                 S13=ConnectTwoSegs(tmpSNew{1},tmpSNew{3});
%                 S=[S,S13,tmpSNew{2},tmpSNew{4}];
%             end
%         elseif length(tmpSNew)==5
%             S12=ConnectTwoSegs(tmpSNew{1},tmpSNew{2});
%             S13=ConnectTwoSegs(tmpSNew{1},tmpSNew{3});
%             S=[S,S12,S13,tmpSNew{4},tmpSNew{5}];
%         end
%     end
% end
%
% for i=1:length(S)
%     if size(S{i})<=3
%         S{i}={};
%     end
% end
%
% S=S(~cellfun('isempty',S));
% end
%
%
% function S12=ConnectTwoSegs(S1,S2)
% tmpDist=pdist2([S1(1,:);S1(end,:)],[S2(1,:);S2(end,:)]);
% [~,idx]=min(tmpDist(:));
% if idx==1
%     S12=[flipud(S2);S1];
% elseif idx==2
%     S12=[S1;S2];
% elseif idx==3
%     S12=[S2;S1];
% elseif idx==4
%     S12=[S1;flipud(S2)];
% end
% end


% This scripts quantifies how well background subtraction using scale space
% method works, in terms of preservation of vessel diameter

%{
im=importtif('AD745a/a pre 51-360 moving.tif');

dim=size(im);
numSlice=100;
maxXScale=4;
optimXScale=3;
thdVal=0.5;
numCC=10000;

im2=cell(1,maxXScale);
for i=1:maxXScale
    im2{i}=zeros(dim(1),dim(2),dim(3));
end
im3=im2; im2{1}=im;

im3{1}=imthreshold(im2{1},thdVal);
im3{1}=elimsobj(im3{1},26,numCC);
figure(1); subplot(2,1,1); imagesc(squeeze(im2{1}(:,:,numSlice)));
axis image; colormap gray; axis off;
title('Original image');
subplot(2,1,2); imagesc(squeeze(im3{1}(:,:,numSlice)));
axis image; colormap gray; axis off;

im2{2}=ScaleSpace(im2{1},optimXScale);
im3{2}=imthreshold(im2{2},'variance-weighted',thdVal);
im3{2}=elimsobj(im3{2},26,numCC);
figure(2);
subplot(2,1,1); imagesc(im2{2}(:,:,numSlice));
axis image; colormap gray; axis off;
title(['Scale space at ',num2str(optimXScale),' times of pixelation']);
subplot(2,1,2); imagesc(im3{2}(:,:,numSlice));
axis image; colormap gray; axis off;

%{
for i=2:maxXScale
    im2{i}=ScaleSpace(im2{1},i+1);
    im3{i}=imthreshold(im2{i},'variance-weighted',thdVal);
    im3{i}=elimsobj(im3{i},26,numCC);
    figure(i);
    subplot(2,1,1); imagesc(im2{i}(:,:,numSlice));
    axis image; colormap gray; axis off;
    title(['Scale space at ',num2str(i+1),' times of pixelation']);
    subplot(2,1,2); imagesc(im3{i}(:,:,numSlice));
    axis image; colormap gray; axis off;
end
%}
%}

% create ground truth
im=importtif('/Users/schafferlab/Documents/MATLAB/yk_Data/AD834/AD 834 d0/bw_512 a 575 645 2x pre003.tif');
im=im(300:429,260:475,end-50:end-24);
V=imprep(im,10,1,20000);
dim=size(V);

Precision=zeros(1,5);
Recall=zeros(1,5);
F1=zeros(1,5);

pctNoisParam=[0.3,0.3;
              0.5,0.3;
              0.7,0.3;
              0.3,0.5;
              0.3,0.7];

for k=1:5
    % noise parameters
    pctSPNoise=pctNoisParam(k,1); 
    pctGrad=pctNoisParam(k,2);
    
    % add salt-pepper noise
    mask=ones(dim);
    mask(find(V))=-1;
    imSPNoise=255*V+round(255*pctSPNoise*mask.*rand(dim));
    
    % add background gradient
    imTmp=zeros(dim(1),dim(2));
    for i=1:dim(2)-1
        imTmp(:,i+1)=imTmp(:,i)+255/dim(2)*pctGrad;
    end
    imGrad=zeros(dim);
    for i=1:dim(3)
        imGrad(:,:,i)=imTmp;
    end
    imNOISE=imSPNoise+round(imGrad.*(~V));
    
    % Scale Space deonising
    im2=ScaleSpace(imNOISE,4,30);
    V2=imprep(im2,10,1,1000);
    
    
    % Evaluation Criterion: precision, recall, and F1
    
    % TP: true positive, correct detected foreground pixel
    % FP: false positive, false detected foreground pixel
    % TN: true negative, true detected background pixel
    % FN: false negative, not detected foreground pixel
    TP=intersect(find(V),find(V2));
    FP=intersect(find(~V),find(V2));
    TN=intersect(find(~V),find(~V2));
    FN=intersect(find(V),find(~V2));
    
    C_TP=length(TP);
    C_FP=length(FP);
    C_TN=length(TN);
    C_FN=length(FN);
    
    Precision(k)=C_TP/(C_TP+C_FP);
    Recall(k)=C_TP/(C_TP+C_FN);
    F1(k)=2*Precision(k)*Recall(k)/(Precision(k)+Recall(k));
end

figure; bar([Precision;Recall;F1]);
legend(['Salt-Pepper Noise Pct ',num2str(pctNoisParam(1,1)*100),'% | '...
    'Background Gradient Pct ',num2str(pctNoisParam(1,2)*100),'%'],...
    ['Salt-Pepper Noise Pct ',num2str(pctNoisParam(2,1)*100),'% | ',...
    'Background Gradient Pct ',num2str(pctNoisParam(2,2)*100),'%'],...
    ['Salt-Pepper Noise Pct ',num2str(pctNoisParam(3,1)*100),'% | ',...
    'Background Gradient Pct ',num2str(pctNoisParam(3,2)*100),'%'],...
    ['Salt-Pepper Noise Pct ',num2str(pctNoisParam(4,1)*100),'% | ',...
    'Background Gradient Pct ',num2str(pctNoisParam(4,2)*100),'%'],...
    ['Salt-Pepper Noise Pct ',num2str(pctNoisParam(5,1)*100),'% | ',...
    'Background Gradient Pct ',num2str(pctNoisParam(5,2)*100),'%'],...
    'Location','NorthOutside');
set(gca,'XTickLabel',{'Precision';'Recall';'F1'});


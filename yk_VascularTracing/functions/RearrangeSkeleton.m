function Skel=RearrangeSkeleton(S)

% This function rearranges the Skel of blood vessels, taking the plist
% structure data.
% Second row - color coded blood vessel type
%
% Color code:
% 1 - Surface Venule
% 2 - Surface Arteriole
% 3 - Ascending Venule
% 4 - Penetrating Arteriole
% 5 - Capillary
% 8 - Stalled Capillary

Skel=cell(2,length(S.Vessels));
for i=1:size(Skel,2)
    for j=1:length(S.Vessels{i}.linePathInMicrons)+4
        for k=1:3
            tmpStartPt(k)=S.Vessels{i}.micronStartPoint{k};
            tmpEndPt(k)=S.Vessels{i}.micronEndPoint{k};
            tmpNodeLoc(k)=S.Nodes{S.Vessels{i}.connections{1}}.locationInMicrons{k};
        end
        tmpDist1=sqrt((tmpStartPt(1)-tmpNodeLoc(1))^2+(tmpStartPt(2)-...
            tmpNodeLoc(2))^2+(tmpStartPt(3)-tmpNodeLoc(3))^2);
        tmpDist2=sqrt((tmpEndPt(1)-tmpNodeLoc(1))^2+(tmpEndPt(2)-...
            tmpNodeLoc(2))^2+(tmpEndPt(3)-tmpNodeLoc(3))^2);
        
        for k=1:3
            if j==1
                if tmpDist1<tmpDist2
                    if tmpDist1<100
                        Skel{1,i}(j,k)=S.Nodes{S.Vessels{i}.connections{1}}.locationInMicrons{k};
                    else
                        Skel{1,i}(j,k)=NaN;
                    end
                else
                    if tmpDist2<100
                        Skel{1,i}(j,k)=S.Nodes{S.Vessels{i}.connections{2}}.locationInMicrons{k};
                    else
                        Skel{1,i}(j,k)=NaN;
                    end
                end
            elseif j==2
                Skel{1,i}(j,k)=S.Vessels{i}.micronStartPoint{k};
            elseif j==length(S.Vessels{i}.linePathInMicrons)+3
                Skel{1,i}(j,k)=S.Vessels{i}.micronEndPoint{k};
            elseif j==length(S.Vessels{i}.linePathInMicrons)+4
                if tmpDist1<tmpDist2
                    if tmpDist2<100
                        Skel{1,i}(j,k)=S.Nodes{S.Vessels{i}.connections{2}}.locationInMicrons{k};
                    else
                        Skel{1,i}(j,k)=NaN;
                    end
                else
                    if tmpDist1<100
                        Skel{1,i}(j,k)=S.Nodes{S.Vessels{i}.connections{1}}.locationInMicrons{k};
                    else
                        Skel{1,i}(j,k)=NaN;
                    end
                end
            else
                tmpLoc=sscanf(S.Vessels{i}.linePathInMicrons{j-2},'%f%s');
                Skel{1,i}(j,k)=tmpLoc(k*2-1);
            end
        end
    end
    Skel{1,i}=Skel{1,i}(isfinite(Skel{1,i}(:, 1)),:);
    
    % switch x y coordinate
    tmp=Skel{1,i}(:,1);
    Skel{1,i}(:,1)=Skel{1,i}(:,2);
    Skel{1,i}(:,2)=tmp;
    
    % assgin vessel type with color code
    if strcmp(S.Vessels{i}.type,'Surface Venule')
        Skel{2,i}=1;
    elseif strcmp(S.Vessels{i}.type,'Surface Arteriole')
        Skel{2,i}=2;
    elseif strcmp(S.Vessels{i}.type,'Ascending Venule')
        Skel{2,i}=3;
    elseif strcmp(S.Vessels{i}.type,'Penetrating Arteriole')
        Skel{2,i}=4;
    else
        Skel{2,i}=5;
    end
    if strcmp(S.Vessels{i}.stalledState,'Stalled')
        Skel{2,i}=8;
    end
end


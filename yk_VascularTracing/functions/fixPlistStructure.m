function S=fixPlistStructure(S)

for i=1:S.VesselsCount
    charStart=[num2str(S.Vessels{i}.startPoint{1},'%10.6f'),', ',...
        num2str(S.Vessels{i}.startPoint{2},'%10.6f'),', ',...
        num2str(S.Vessels{i}.startPoint{3},'%10.6f')];
    charEnd=[num2str(S.Vessels{i}.endPoint{1},'%10.6f'),', ',...
        num2str(S.Vessels{i}.endPoint{2},'%10.6f'),', ',...
        num2str(S.Vessels{i}.endPoint{3},'%10.6f')];
    charLinePath=[charStart,S.Vessels{i}.linePath,charEnd];
    S.Vessels{i}.linePath=charLinePath;
    
    if (length(S.Vessels{i}.connections))>1
        tipPointsLoc=cell(1,2);
        for j=1:2
            tipPointsLoc{j}=S.Nodes{S.Vessels{i}.connections{j}}.location;
        end
        flag=getOrder(tipPointsLoc,S.Vessels{i}.startPoint);
        if (flag)
            S.Vessels{i}.startPoint=tipPointsLoc{1};
            S.Vessels{i}.endPoint=tipPointsLoc{2};
        else
            S.Vessels{i}.startPoint=tipPointsLoc{2};
            S.Vessels{i}.endPoint=tipPointsLoc{1};
        end
    else
        S.Vessels{i}.startPoint=S.Nodes{S.Vessels{i}.connections{1}}.location;
        S.Vessels{i}.endPoint=S.Nodes{S.Vessels{i}.connections{1}}.location;
    end
end
end

function flag=getOrder(tipLocs,startLoc)
dist=-1*ones(1,2);
for k=1:2
    dist(k)=sqrt((tipLocs{k}{1}-startLoc{1})^2+...
        (tipLocs{k}{2}-startLoc{2})^2+...
        (tipLocs{k}{3}-startLoc{3})^2);
end
if (dist(1)<dist(2)) flag=true;
else flag=false;
end
end
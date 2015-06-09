close all; clear; clc;

% load plist file
plistname = 'CXAD 19 WT a 2x 1 plist.plist';
S = loadPlist(plistname);

% write hand-traced point into 3 x n matrix
nodes = zeros(length(S.Nodes),3);
for i = 1:length(S.Nodes)
    for j = 1:3
        if ischar(S.Nodes{1,i}.location) == 1
            locChar = str2num(S.Nodes{1,i}.location);
            if j == 1 || j == 2
                nodes(i,j) = locChar(j)-5; % shift x and y coord to fit actual nodes
            else
                nodes(i,j) = locChar(j); % keep z coord
            end
        elseif iscell(S.Nodes{1,i}.location) == 1
            if j == 1 || j == 2
                nodes(i,j) = cell2mat(S.Nodes{1,i}.location(1,j))-5;
            else
                nodes(i,j) = cell2mat(S.Nodes{1,i}.location(1,j));
            end
        else 
            fprintf('Unexpected location data type');
        end
    end
end

% export as csv file
csvname = strcat(plistname,'.csv');
csvwrite(csvname,nodes);

% output first nodes on the first layer if their locations match GOTracer
% inspector information
nodesFiltered = NaN(length(nodes),3);
for i = 1:length(nodes)
    for j = 1:3
        if nodes(i,3) == 0
            nodesFiltered(i,j) = nodes(i,j);
        end
    end
end
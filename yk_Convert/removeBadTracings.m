function [VessLengths,newStruct]= removeBadTracings(badStruct,Openfile)
%remove all of the bad vessels and nodes in the vectorized structure bad
%Struct which is an output strucuture of an automated tracing code, namely
%VIDA, Openfile is the filename with which it is saved.
tic
[vertsI,dim]=size(badStruct.Vertices.AllVerts);
nodesToKeep=zeros(vertsI,1);
strandsToKeep=zeros(length(badStruct.Strands),1);
fprintf('Number of nodes before filtering %d\n',vertsI)

%% remove short vessels
[nodesToKeep,strandsToKeep, VessLengths]=...
    removeSmallVess(badStruct,nodesToKeep,strandsToKeep);
fprintf('Removed short vessels: %d nodes left\n', sum(nodesToKeep))
badStruct=reindexNodes(badStruct,nodesToKeep,strandsToKeep);

%% remove unconn vessels
[verts,dim]=size(badStruct.Vertices.AllVerts);
nodesToKeep=zeros(verts,1);
strandsToKeep=zeros(length(badStruct.Strands),1);
[nodesToKeep,strandsToKeep]=...
    removeUnconnVess(badStruct,nodesToKeep,strandsToKeep);
fprintf('Removed unconnected nodes: %d nodes left\n', sum(nodesToKeep))

fprintf('\nPercent nodes retained %f\n',sum(nodesToKeep)/vertsI)
if sum(nodesToKeep)~=verts
    badStruct=reindexNodes(badStruct,nodesToKeep,strandsToKeep);
end
newStruct=badStruct;

%% Create go tracer file
importVIDA(newStruct, Openfile)
toc

%% create go trace
function importVIDA(vectorizedStructure, Openfile)
dimX = 512;
dimY = 512;
micronperpixel = 1;
imagePath = 'test';

Savefile = [Openfile,'.gotrace'];


GOTracerReadableFile = ExportToGOTracer(vectorizedStructure,dimX,dimY,micronperpixel,imagePath ); 
test = structToXMLPlist(GOTracerReadableFile);
%had to run 2x?  
%save: test is is mame 
h = fopen(Savefile,'w') ;
fwrite(h, test)  ;
fclose(h);
end


%% Reindex the structure of the nodes
    function newStruct=reindexNodes(badStruct,nodesToKeep,strandsToKeep)
        newStruct= struct('maskSize',badStruct.maskSize);
        %Reindex all nodes
        totalCount=length(nodesToKeep);
        finalCount=sum(nodesToKeep);
        NconvMat=zeros(totalCount,1);
        ind=0;
        
        newStruct.Vertices.AllVerts=zeros(finalCount,3);
        newStruct.Vertices.AllRadii=zeros(finalCount,1);
        newStruct.Vertices.JunctionPoints=logical(false(finalCount,1));
        newStruct.Vertices.FreeEndPoints=logical(false(finalCount,1));
        newStruct.Vertices.StrandIndices=cell(finalCount,1);
        
        for n=1:totalCount
            if nodesToKeep(n)
                ind=ind+1;
                NconvMat(n)=ind;
                newStruct.Vertices.AllVerts(ind,:)=badStruct.Vertices.AllVerts(n,:);
                newStruct.Vertices.AllStrandEndPoints(ind,1)=badStruct.Vertices.AllStrandEndPoints(n);
                newStruct.Vertices.JunctionPoints(ind,1)=badStruct.Vertices.JunctionPoints(n);
                newStruct.Vertices.AllRadii(ind,1)=badStruct.Vertices.AllRadii(n);
                newStruct.Vertices.StrandIndices(ind,1)=badStruct.Vertices.StrandIndices(n);
            end
        end
        
        %Reindex all strands
        totalCount=length(strandsToKeep);
        ind=0;
        for n=1:totalCount
            if strandsToKeep(n)
                ind=ind+1;
                newStruct.Strands(ind).StartVertexIndex=NconvMat(badStruct.Strands(n).StartVertexIndex);
                newStruct.Strands(ind).EndVertexIndex=NconvMat(badStruct.Strands(n).EndVertexIndex);
                
                newStruct.Strands(ind).StartVertexNeighborStrands=badStruct.Strands(n).StartVertexNeighborStrands;
                newStruct.Strands(ind).EndVertexNeighborStrands=badStruct.Strands(n).EndVertexNeighborStrands;
                
                for allInd=1:length(badStruct.Strands(n).StartToEndIndices)
                    newStruct.Strands(ind).StartToEndIndices(allInd)=...
                        NconvMat(badStruct.Strands(n).StartToEndIndices(allInd));
                end
                newStruct.Strands(ind).InteriorVertices=newStruct.Strands(ind).StartToEndIndices(2:end-1);
            end
        end
    end

%% short node removal
%Go through the nodes in bad Struct and return a boolean array of which
%vessels are over a certain length.
    function [newNodes,newStrands,vessLengths]=removeSmallVess(badStruct,nodesToKeep,strandsToKeep)
        vessLengths=zeros(length(badStruct.Strands),1);
        %figure
        for v= 1:length(badStruct.Strands)
            vessVerts=badStruct.Strands(v).StartToEndIndices;
            for i= 2: length(vessVerts)
                segC=[badStruct.Vertices.AllVerts(vessVerts(i-1),:);badStruct.Vertices.AllVerts(vessVerts(i),:)];
                seg= pdist(segC,'euclidean');
                vessLengths(v)=vessLengths(v)+seg;
                %plot3(segC(:,1),segC(:,2),segC(:,3))
                %hold on
            end
            if vessLengths(v)>=30
                for n=1:length(vessVerts)
                    nodesToKeep(vessVerts(n))=1;
                end
                strandsToKeep(v)=1;
            end
        end
        newNodes=nodesToKeep; newStrands=strandsToKeep;
    end

%% unconn node removal
%Go through an array of badStruct and return a boolean array of which
%vessels are not connected to anything else.
    function [newNodes,newStrands]=removeUnconnVess(badStruct,nodesToKeep,strandsToKeep)
        for v=1:length(badStruct.Strands)
            vessVerts=badStruct.Strands(v).StartToEndIndices;
            connE=length(badStruct.Strands(v).EndVertexNeighborStrands);
            connS=length(badStruct.Strands(v).StartVertexNeighborStrands);
            totalConn= connE+connS;
            if totalConn~=0
                for n=1:length(vessVerts)
                    nodesToKeep(vessVerts(n))=1;
                end
                strandsToKeep(v)=1;
            end
        end
        newNodes=nodesToKeep;newStrands=strandsToKeep;
    end

end
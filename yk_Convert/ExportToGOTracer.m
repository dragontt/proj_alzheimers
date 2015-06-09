function GOTracerReadableFile = ExportToGOTracer(vectorizedStructures,dimX,dimY,micronperpixel,imagePath )

%ExportToGOTracer function converts the vectorizedStructures output from VIDA
%to the standard object-oriented structure Array "fullArray" that is
%outputted by GOTracer to MATLAB.  The output file from this function
%"GOTracerReadableFile" can be converted to a file format that can be read
%by GOTracer.

%BE SURE that the input for vectorizedStructures is not vectorProject, but
%vectorProject.vectorizedStructure

%imagePath holds the full path to the image file corresponding to the
%tracing.  i.e.: /Volumes/uluwatu drive2/AD 2010/AD 141/FinalFile.tif
%micronperpixel.


%Start by creating an empty output structure array:
fullArray = struct('graphics',{{}},'imagePath',imagePath,'micronperpixel',micronperpixel,'printInfo__DATA','','version',2,'zDepth',1);
%Get array with Vessel information.
strands=vectorizedStructures.Strands;
vertices=vectorizedStructures.Vertices;

counter=0;
for i=1:length(vertices.AllVerts) %Cycle through every strand.
    
    if ((vertices.AllStrandEndPoints(i,1)==1)||(vertices.JunctionPoints(i,1)==1))
        
        vertices.AllVerts(i,4)=counter;
        counter=counter+1;
    end
    
end



h=waitbar(0,'Export to GoTracer in Progress...');
maxLengthWaitBar=length(strands);
for i=1:length(strands) %Cycle through every strand.
%     disp(['Working on Vessel #',num2str(i)]);
    waitbar(i/maxLengthWaitBar);
    fullArray.graphics{i}=struct('beginPoint','','className','SKTLine','drawingStroke',true,'connections','','drawingFill',false,'edited',true,'endPoint','','fillColor__DATA','','firstNode','','firstPointIndex',0,'lastNode','','lastPointIndex',0,'leukocyte','Not Defined','lineLayers','','linePath','','name','','stalledState','Not Defined','strokeColor__DATA','','strokeWidth',2,'type','Not Defined','zIndex',0,'zIndex2',0);
    %beingPoint -> String
    %className -> String
    %drawingStroke -> boolean
    %connections -> string
    %drawingFille -> boolean.
    
    %%%Starting point is converted and separated:
    % {x, y} goes to beingPoint as a string.
    % z goes to zIndex as a Number.
    startX=num2str(vertices.AllVerts(strands(i).StartVertexIndex,1));
    startY=num2str(vertices.AllVerts(strands(i).StartVertexIndex,2));
    startZ=vertices.AllVerts(strands(i).StartVertexIndex,3);
    fullArray.graphics{i}.beginPoint=['{',startY, ', ',startX,'}'];
    fullArray.graphics{i}.firstNode=['{',startY, ', ',startX,'}'];
    fullArray.graphics{i}.zIndex=startZ;
    
    %%Similar thing for the end Point.
    endX=num2str(vertices.AllVerts(strands(i).EndVertexIndex,1));
    endY=num2str(vertices.AllVerts(strands(i).EndVertexIndex,2));
    endZ=vertices.AllVerts(strands(i).EndVertexIndex,3);
    fullArray.graphics{i}.endPoint=['{',endY, ', ',endX,'}'];
    fullArray.graphics{i}.lastNode=['{',endY, ', ',endX,'}'];
    fullArray.graphics{i}.zIndex2=endZ;
    
    
    fullArray.graphics{i}.firstPointIndex=strands(i).StartVertexIndex;
    fullArray.graphics{i}.lastPointIndex=strands(i).EndVertexIndex;
    
    
    fullArray.graphics{i}.name=['Line ',int2str(i-1)];
    
    
    
    for j=1:length(strands(i).InteriorVertices)
        
        tempX=num2str(vertices.AllVerts(strands(i).InteriorVertices(j),1));
        tempY=num2str(vertices.AllVerts(strands(i).InteriorVertices(j),2));
        tempZ=num2str(vertices.AllVerts(strands(i).InteriorVertices(j),3));
        
        if (strcmp(fullArray.graphics{i}.linePath,''))
            
            fullArray.graphics{i}.linePath=['{',tempY, ', ',tempX,'}'];
        else
            fullArray.graphics{i}.linePath=[fullArray.graphics{i}.linePath,',','*{',tempY, ', ',tempX,'}'];
            
        end
        
        if (strcmp(fullArray.graphics{i}.lineLayers,''))
            
            fullArray.graphics{i}.lineLayers=tempZ;
        else
            
            fullArray.graphics{i}.lineLayers=[fullArray.graphics{i}.lineLayers,',*',tempZ];
        end
        
        
        
    end
    
    if (length(strands(i).InteriorVertices)<=0)
        fullArray.graphics{i}.linePath='';
    end
    
    
    %     tempAdjConns=num2cell(strands(i).EndVertexNeighborStrands);
    %
    %
    %     if (length(tempAdjConns)>=1)
    %     for k=1:length(tempAdjConns)
    %         if (tempAdjConns{k}==i)
    %            tempAdjConns(:,k)=[];
    %
    %            break;
    %         end
    %     end
    %     end
    %
    %     fullArray.Vessels{i}.adjacentconnections=num2cell(tempAdjConns);
    %     if (size(fullArray.Vessels{i}.adjacentconnections)==0)
    %         fullArray.Vessels{i}.adjacentconnections='';
    %     end
    
    
    fullArray.graphics{i}.connections=['Node ',num2str(vertices.AllVerts(strands(i).StartVertexIndex,4)),', Node ',num2str(vertices.AllVerts(strands(i).EndVertexIndex,4))];
    fullArray.graphics{i}.firstPointIndex=num2str(vertices.AllVerts(strands(i).StartVertexIndex,4)+length(vertices.AllVerts));
    fullArray.graphics{i}.lastPointIndex=num2str(vertices.AllVerts(strands(i).EndVertexIndex,4)+length(vertices.AllVerts));
end
delete(h);
numOfVessels=length(strands);
counter=1;
h=waitbar(0,'Export to GoTracer in Progress...');
maxLengthWaitBar=length(vertices.AllVerts);
for i=1:length(vertices.AllVerts) %Cycle through every strand.    
%     disp(['Working on Node #',num2str(i)]);
    waitbar(i/maxLengthWaitBar);
    if ((vertices.AllStrandEndPoints(i,1)==1)||(vertices.JunctionPoints(i,1)==1))
        
        fullArray.graphics{counter+numOfVessels}=struct('bounds','','className','SKTCircle','connections','','drawingFill',false,'drawingStroke',true,'name','','fillColor__DATA','','strokeColor__DATA','','strokeWidth',2,'type','Not Defined','zIndex',0);
        
        
        fullArray.graphics{counter+numOfVessels}.name=['Node ',int2str(counter-1)];
        
        
        startY=num2str(vertices.AllVerts(i,1)-2.5);
        startX=num2str(vertices.AllVerts(i,2)-2.5);
        startZ=vertices.AllVerts(i,3);
        
        fullArray.graphics{counter+numOfVessels}.bounds=['{{',startX, ', ',startY,'}, ','{5, 5}}'];
        fullArray.graphics{counter+numOfVessels}.zIndex=startZ;
        
        vesselIndex=num2cell(vertices.StrandIndices{i});
        
        for j=1:length(vesselIndex)
            
            
            
            if (strcmp(fullArray.graphics{counter+numOfVessels}.connections,''))
                
                fullArray.graphics{counter+numOfVessels}.connections=['Line ',num2str(vesselIndex{j}-1)];
            else
                fullArray.graphics{counter+numOfVessels}.connections=[fullArray.graphics{counter+numOfVessels}.connections,', Line ',num2str(vesselIndex{j}-1)];
                
            end
        end
        
        %fullArray.graphics{i+numOfVessels}.connections=
        %fullArray.Nodes{i}.location=vertices.AllVerts(i,:);
        
        
        
        
        
        
        
        % end
        counter=counter+1;
    end
    
    
    % fullArray.Nodes{counter}.connections=tempConns;
    % fullArray.Nodes{counter}.adjacentconnections=tempConns;
    %fullArray.Nodes{i}.connections=vertices.StrandIndices(i);
    
    %fullArray.Nodes{i}.adjacentconnections=vertices.StrandIndices(i);
    %for j=1:length(fullArray.Nodes{i}.connections)
    %    disp(fullArray.Nodes{i}.connections{1});
    %    disp(fullArray.Vessels{fullArray.Nodes{i}.connections{j}});
    %   disp(fullArray.Vessels{fullArray.Nodes{i}.connections{j}}.connections);
    %    member=ismember(fullArray.Vessels{fullArray.Nodes(i).connections{j}}.connections,i);
    
    %    if (member{1}==1)
    %        fullArray.Nodes{i}.adjacentconnections(j)=fullArray.Vessels(fullArray.Nodes{i}.connections(j)).connections{2};
    %    else
    %         fullArray.Nodes{i}.adjacentconnections(j)=fullArray.Vessels(fullArray.Nodes{i}.connections(j)).connections{1};
    %    end
    %fullArray.Vessels(i).linePath(j)=vertices.AllVerts(strands.InteriorVertices(j),:);
    %fullArray.Vessels(i).linePathInMicrons(j)={fullArray.Vessels(i).linePath(j).{1,1}*micronsX,fullArray.Vessels(i).startPoint{1,2}*micronsY,fullArray.Vessels(i).startPoint{1,3}*micronsZ};
    
    %end
    
    % tempAdjConns=strands.EndVertexNeighborStrands;
    % tempAdjConns(:,1)=[];
    
    % fullArray.Vessels{i}.adjacentconnections=tempAdjConns;
    
    
    % fullArray.Vessels{i}.connections={strands.StartVertexIndex,strands.EndVertexIndex};
    
end
delete(h);



GOTracerReadableFile=fullArray;



end


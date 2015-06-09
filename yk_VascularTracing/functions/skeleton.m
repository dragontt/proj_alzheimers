function S=skeleton(V,Method,verbose)

% This function Skeleton will calculate an accurate skeleton (centerlines)
% of an object represented by an binary image / volume using the fastmarching
% distance transform.
%
% S=skeleton(I,verbose)
%
% inputs,
%	V : 3D binary image
%	verbose : Boolean, set to true (default) for debug information
%
% outputs
%   S : Cell array with the centerline coordinates of the skeleton branches
%
% Literature
%   Robert van Uitert and Ingmar Bitter : "Subvoxel precise skeletons of volumetric
%	data base on fast marching methods", 2007.
%
% Modified by Y. Kang (2013)

if (nargin<3)
    verbose=true;
end

% Group non-connected vessels
CC=bwconncomp(V,26);
if (verbose)
    disp(['Number of Connected Vessel Group : ' num2str(CC.NumObjects)]);
end
S={};

for i=1:CC.NumObjects
    [I,J,K]=ind2sub(CC.ImageSize,CC.PixelIdxList{i});
    VTmp=zeros(CC.ImageSize);
    for n=1:length(I)
        VTmp(I(n),J(n),K(n))=1;
    end
    VTmp=logical(VTmp);
    if (verbose)
        disp(['Find Skeleton in Vessel Group # ' num2str(i)]);
    end
    
    % Distance to vessel boundary
    % BoundaryDistance=getBoundaryDistance(VTmp);
    BoundaryDistance=double(bwdist(imcomplement(VTmp)));
    if (verbose)
        disp('  Distance Map Constructed');
    end
    
    % Get maximum distance value, which is used as starting point of the
    % first skeleton branch
    [SourcePoint,maxD]=maxDistancePoint(BoundaryDistance,VTmp);
    
    % Make a fastmarching speed image from the distance image
    SpeedImage=(BoundaryDistance/maxD).^4;
    SpeedImage(SpeedImage==0)=1e-10;
    
    % Skeleton segments found by fastmarching
    SkeletonSegments=cell(1,1000);
    
    % Number of skeleton iterations
    itt=0;
    while (true)
        if (verbose)
            disp(['  Find Branches Iterations : ' num2str(itt)]);
        end
        
        % Do fast marching using the maximum distance value in the image
        % and the points describing all found branches are sourcepoints.
        [T,Y] = msfm(SpeedImage, SourcePoint, false, false);
        
        % Trace a branch back to the used sourcepoints with Dijktra's shortest
        % path method
        StartPoint=maxDistancePoint(Y,VTmp);
        ShortestLine=shortestpath(T,StartPoint,SourcePoint,Method);
        
        % Get the length of the new skeleton segment
        linelength=GetLineLength(ShortestLine);
        
        % Stop finding branches, if the lenght of the new branch is smaller
        % then the diameter of the largest vessel
        if (linelength<maxD*1.5)
            break;
        end
        
        % Store the found branch skeleton
        itt=itt+1;
        SkeletonSegments{itt}=ShortestLine;
        
        % Add found branche to the list of fastmarching SourcePoints
        SourcePoint=[SourcePoint ShortestLine'];
    end
    
    % Organize skeleton
    SkeletonSegments(itt+1:end)=[];
    tmpS=OrganizeSkeleton(SkeletonSegments);
    
    % Eliminate short skeleton
    % STmp=ElimSSkel(VTmp,STmp,1);
    
    % Build skeleton info
    tmpS2=BuildTmpSkel(tmpS);
    % Merge skeletons with unessary branch
    [tmpS,tmpS2]=MergeSkel(tmpS,tmpS2);
    
    % Add new skeleton
    S=[S,tmpS];
    S=S(~cellfun('isempty',S));
    
end

if (verbose)
    disp(['Skeleton Branches Found : ' num2str(length(S))]);
    disp('Skeleton Information Built');
end




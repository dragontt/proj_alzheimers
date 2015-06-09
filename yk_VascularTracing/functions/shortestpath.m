function ShortestLine=shortestpath(DistanceMap,StartPoint,SourcePoint,Method)

% This function SHORTESTPATH traces the shortest path from start point to
% source point using simple method or Euler's method in 3D distance map.
%
% ShortestLine=shortestpath(DistanceMap,StartPoint,SourcePoint)
%
% inputs,
%   DistanceMap : A 3D distance map (from the functions msfm3d)
%   StartPoint : Start point of the shortest path
%   SourcePoint : (Optional), End point of the shortest path
% output,
%   ShortestLine: M x 3 array with the Shortest Path
%
% Function is written by D.Kroon University of Twente (June 2009)
% Modified by Y. Kang (2013)

% Process inputs
if (~exist('SourcePoint','var'))
    SourcePoint=[];
end
if (~exist('Method','var'))
    Method='simple';
end

% Calculate gradient of DistanceMap
[Fy,Fx,Fz] = pointmin(DistanceMap);
GradientVolume(:,:,:,1)=-Fx;
GradientVolume(:,:,:,2)=-Fy;
GradientVolume(:,:,:,3)=-Fz;

Stepsize=1;
i=0;
% Reserve a block of memory for the shortest line array
ifree=10000;
ShortestLine=zeros(ifree,ndims(DistanceMap));

% Iteratively trace the shortest line
while (true)
    % Calculate the next point using simple search or euler's method
    switch (lower(Method))
        case 'simple'
            EndPoint=s1(StartPoint,DistanceMap);
        case 'euler'
            EndPoint=e1(StartPoint,GradientVolume,Stepsize);
        otherwise
            error('shortestpath:input','unknown method');
    end
    
    % Calculate the distance to the end point
    if(~isempty(SourcePoint))
        [DistancetoEnd,ind]=min(sqrt(sum((SourcePoint-repmat(EndPoint,1,size(SourcePoint,2))).^2,1)));
    else
        DistancetoEnd=inf;
    end
    
    % Calculate the movement between current point and point 10 itterations back
    if (i>10)
        Movement=sqrt(sum((EndPoint(:)-ShortestLine(i-10,:)').^2));
    else
        Movement=Stepsize+1;
    end
    
    % Stop if out of boundary, distance to end smaller then a pixel or
    % if there was no movement for 10 itterations
    if ((EndPoint(1)==0)||(Movement<Stepsize))
        break;
    end
    
    % Count the number of itterations
    i=i+1;
    
    % Add a new block of memory if full
    if (i>ifree)
        ifree=ifree+10000;
        ShortestLine(ifree,:)=0;
    end
    
    % Add current point to the shortest line array
    ShortestLine(i,:)=EndPoint;
    
    if (DistancetoEnd<Stepsize)
        i=i+1;
        if (i>ifree)
            ifree=ifree+10000;
            ShortestLine(ifree,:)=0;
        end
        % Add (Last) Source point to the shortest line array
        ShortestLine(i,:)=SourcePoint(:,ind);
        break;
    end
    
    % Current point is next Starting Point
    StartPoint=EndPoint;
end

if((DistancetoEnd>1)&&(~isempty(SourcePoint)))
    disp('The shortest path trace did not finish at the source point');
end

% Remove unused memory from array
ShortestLine=ShortestLine(1:i,:);



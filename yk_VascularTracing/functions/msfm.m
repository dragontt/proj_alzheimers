function [T,Y]=msfm(F, SourcePoints, UseSecond, UseCross)

% This function MSFM calculates the shortest distance from a list of
% points to all other pixels in an image volume, using the
% Multistencil Fast Marching Method (MSFM). This method gives more accurate
% distances by using second order derivatives and cross neighbours.
%
%   [T,Y]=msfm(F, SourcePoints, UseSecond, UseCross)
%
% inputs,
%   F: The 3D speed image. The speed function must always be larger
%			than zero (min value 1e-8), otherwise some regions will
%			never be reached because the time will go to infinity.
%   SourcePoints : A list of starting points [3 x N] (distance zero)
%   UseSecond : Boolean Set to true if not only first but also second
%                order derivatives are used (default)
%   UseCross : Boolean Set to true if also cross neighbours
%                are used (default)
% outputs,
%   T : Image with distance from SourcePoints to all pixels
%   Y : Image for augmented fastmarching with, euclidian distance from
%       SourcePoints to all pixels. (Used by skeletonize method)
%
% Note:
%   Run compile_c_files.m to allow 3D fast marching and for cpu-effective
%	registration of 2D fast marching.
%
% Note(2):
%   Accuracy of this method is enhanced by just summing the coefficients
% 	of the cross and normal terms as suggested by Olivier Roy.
%
% Function is written by D.Kroon University of Twente (Oct 2010)
% Modified by Y. Kang (2013)

% add_function_paths();

if(nargin<3)
    UseSecond=false;
end
if(nargin<4)
    UseCross=false;
end

if(nargout>1)
    [T,Y]=msfm3d(F, SourcePoints, UseSecond, UseCross);
else
    T=msfm3d(F, SourcePoints, UseSecond, UseCross);
end

% function add_function_paths()
% try
%     functionname='msfm.m';
%     functiondir=which(functionname);
%     functiondir=functiondir(1:end-length(functionname));
%     addpath([functiondir '/functions'])
%     addpath([functiondir '/shortestpath'])
% catch me
%     disp(me.message);
% end

function S = loadPlist(fname)
% loadXMLPlist  Load and parse Mac OSX XML property list into a structure
%
%   S = loadPlist(filename)
%
%       Returns hierarchical structure S from property list in filename
%
%   See XMLPlistToStruct.m for details.
%

fid = fopen(fname,'r');
text = char(fread(fid,inf,'uchar'))'; %read as single string
fclose(fid);

S = XMLPlistToStruct(text);
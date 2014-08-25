function [vertex,face] = read_off(filename)

% read_off - read data from OFF file.
%
%   [vertex,face] = read_off(filename);
%
%   'vertex' is a 'nb.vert x 3' array specifying the position of the vertices.
%   'face' is a 'nb.face x 3' array specifying the connectivity of the mesh.
%
%   from the toolbox graph
%   Copyright (c) 2003 Gabriel Peyré, Modified by Frank Schmidt


fid = fopen(filename,'r');
if( fid==-1 )
    error('Can''t open the file.');
    return;
end

str = fgets(fid);   % -1 if eof
if ~strcmp(str(1:3), 'OFF')
    error('The file is not a valid OFF one.');    
end

str = fgets(fid);
[a,str] = strtok(str); nvert = str2num(a);
[a,str] = strtok(str); nface = str2num(a);



[A,cnt] = fscanf(fid,'%f %f %f', 3*nvert);
if cnt~=3*nvert
    warning('Problem in reading vertices.');
end
A = reshape(A, 3, cnt/3);
vertex = A;
% read Face 1  1088 480 1022
%have to check for files, where the faces do not have a vertexnumber prefixed
[A,cnt] = fscanf(fid,'%d %d %d %d\n', 4*nface);
if cnt==4*nface
	A = reshape(A, 4, cnt/4);
	face = A(2:4,:)+1;
else
    warning('Problem in reading faces. Probably not given by 4 but by 3 numbers');
	frewind(fid);
	%redo everything to get were we left off
	str = fgets(fid);   % -1 if eof
	str = fgets(fid);   % -1 if eof
	[A,cnt] = fscanf(fid,'%f %f %f', 3*nvert);
	%retry finding faces
	[A,cnt] = fscanf(fid,'%d %d %d\n', 3*nface);
	if cnt~=3*nface
		error('Problem reading faces, something is wrong with the file')
	end
	A = reshape(A, 3, cnt/3);
	%probably unneeded, since the offfile does not start at 0?
	face = A(:,:);%+1;
end


fclose(fid);


%%implementation of the farthest point sampling
function [indices] = fps_mat(n, M, name)
% FPS  Generate a farthest point sampling of M by using the distance d
%    n: needed number of points
%    M: Manifold, with X,Y,Z and/or vert and a set of triangles
%    name: specify the corresponding .mat file containing the
%          distancematrix d
%  returns a vector of indices of the selected points
indices = zeros(1,n);
dim = length(M.X); %todo: perhaps, only require a dimx3 matrix
dist = zeros(1,dim);
file = matfile(name);

%find first point
indices(1) = randi(dim);

dist = file.d(indices(1),:);
%maximise the minimal distanz to the set
for i = 1:n-1
    dist = min(dist,file.d(indices(i),:));
    [~, index] = max(dist);
    indices(i+1) = index;
end

end
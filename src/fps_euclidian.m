%%implementation of the farthest point sampling
function [indices] = fps_euclidian(n, M)
% FPS  Generate a farthest point sampling of M by using the distance d
%    n: needed number of points
%    M: Manifold, with X,Y,Z and/or vert and a set of triangles
%    d: function handle to distance function
%  returns a vector of indices of the selected points
indices = zeros(1,n);
dim = length(M.X);
d = zeros(1,dim);
maximum = zeros(1,dim);

%find first point (slowest part)
for i = 1:dim
    maximum(i) = max(sqrt((M.X-M.X(i)).^2 + (M.Y-M.Y(i)).^2 + (M.Z - M.Z(i)).^2));
end
[~, maxind] = max(maximum);
indices(1) = maxind;
% indices(1) = randi(dim);

%d(1,:) = sqrt((M.X-M.X(1)).^2 + (M.Y-M.Y(1)).^2 + (M.Z - M.Z(1)).^2);

%maximise the minimal distanz to the set
for i = 1:n-1
    dtmp = sqrt((M.X-M.X(indices(i))).^2 + (M.Y-M.Y(indices(i))).^2 + (M.Z - M.Z(indices(i))).^2)';
    %d(1:i,1:10)
    d = min(d,dtmp);
    %dmax(1:10)
    [~, index] = max(d);
    indices(i+1) = index;
end

end
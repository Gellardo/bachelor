%%implementation of the farthest point sampling
function [indices] = fps_general(n, M, eigenfunc, eigenval, type, start)
% FPS  Generate a farthest point sampling of M by using the distance d
%    n: needed number of points
%    M: Manifold, with X,Y,Z and/or vert and a set of triangles
%    d: function handle to distance function
%  returns a vector of indices of the selected points
indices = zeros(1,n);
dim = size(M.vert,2);
dist = zeros(1,dim);

if(strcmp(type, 'geodesic'))
	dfunc = @(M,ef,ev,i)distance_geodesic(M, i,'dijkstra'); %TODO
elseif(strcmp(type, 'diffusion'))
	opts.type = 'diffusion';
	opts.t = 0.1;
	dfunc = @(M,ef,ev,i)distance_laplace(ef, ev, i, opts);
elseif(strcmp(type, 'commute_time'))
	opts.type = 'commute_time';
	dfunc = @(M,ef,ev,i)distance_laplace(ef, ev, i, opts);
elseif(strcmp(type, 'biharmonic'))
	opts.type = 'biharmonic';
	dfunc = @(M,ef,ev,i)distance_laplace(ef, ev, i, opts);
end

%find first point
% for i = 1:dim
%     %probaly still a good idea, since it is fast, and should work for other
%     %stuff too. (for the first point)
%     %maximum(i) = max(sqrt((M.X-M.X(i)).^2 + (M.Y-M.Y(i)).^2 + (M.Z - M.Z(i)).^2));
%     for j = i:dim
%         tmp = dfunc(M.vert, i, j);
%         if tmp > maximum(i)
%             maximum(i) = tmp;
%         end
%     end
% end
% [~, maxind] = max(maximum);
%indices(1) = maxind;
if nargin < 6
    indices(1) = randi(dim);
else
    indices(1) = start;
end


for i = 1:n-1
	tmp = dfunc(M.vert, eigenfunc, eigenval, indices(i));
	dist = min(dist,tmp);
	[~, index] = max(dist);
end

end

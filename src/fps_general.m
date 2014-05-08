%%implementation of the farthest point sampling
function [indices] = fps2(n, M, dfunc)
% FPS  Generate a farthest point sampling of M by using the distance d
%    n: needed number of points
%    M: Manifold, with X,Y,Z and/or vert and a set of triangles
%    d: function handle to distance function
%  returns a vector of indices of the selected points
indices = zeros(1,n);
dim = length(M.X); %todo: perhaps, only require a dimx3 matrix
dist = zeros(1,dim);
maximum = zeros(1,dim);

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
indices(1) = randi(dim);

%d(1,:) = sqrt((M.X-M.X(1)).^2 + (M.Y-M.Y(1)).^2 + (M.Z - M.Z(1)).^2);
%maximise the minimal distanz to the set
%this might be general, but it is really slow...
for i = 1:n-1
    for j = 1:dim
       tmp = dfunc(M.vert, indices(i), j);
       if tmp < dist(j) || dist(j) == 0
           dist(j) = tmp;
       end
    end
    %d(i,:) = sqrt((M.X-M.X(indices(i))).^2 + (M.Y-M.Y(indices(i))).^2 + (M.Z - M.Z(indices(i))).^2);
    %dmax = min(d(1:i,:),[],1);
    dist(indices(1:i)) = 0;
    [~, index] = max(dist);
    indices(i+1) = index;
end

end
function [dist] = distance_euclidean(M, x, y)
% euclidean_distance compute the euclidian distance of the points x and y
%    M contains (only) rows representing the corresponding points
    dist = sqrt(sum((M(x,:)-M(y,:)).^2));
end
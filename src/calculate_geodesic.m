function [d, time] = calculate_geodesic(M, indices, name)
global geodesic_library;
geodesic_library = 'libgeodesic';

mesh = geodesic_new_mesh(M.vert,M.tri);
algorithm = geodesic_new_algorithm(mesh, 'exact');
time = clock();
for i = 1:length(indices)
source_points = {geodesic_create_surface_point('vertex', indices(i), M.vert(indices(i),:))};
geodesic_propagate(algorithm, source_points);   %propagation stage of the algorithm (the most time-consuming)
[source_id, distances] = geodesic_distance_and_source(algorithm);
d(i,:) = distances;
end
time = clock()-time;
geodesic_delete();
end
function [d, time] = distance_geodesic(M, start, type)
global geodesic_library;
geodesic_library = 'libgeodesic';

if(nargin > 2)
	if(~any(ismember({'exact','dijkstra','test'},type)))
		type = 'exact';
	end
else
	type = 'exact';
end

mesh = geodesic_new_mesh(M.vert,M.face);

%some of the meshes seem to be bad, especially the sampled ones
if(strcmp(type, 'test'))
	time = 0;
	d = 0;
	return
end

algorithm = geodesic_new_algorithm(mesh, type);

tic();
for i = 1:length(start)
	source_points = {geodesic_create_surface_point('vertex', start(i), M.vert(:,start(i)))};
	geodesic_propagate(algorithm, source_points);   %propagation stage of the algorithm (the most time-consuming)
	[source_id, distances] = geodesic_distance_and_source(algorithm);
	d(i,:) = distances;
end
time = toc();
geodesic_delete();

end

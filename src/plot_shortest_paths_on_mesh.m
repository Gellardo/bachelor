addpath('geodesic_matlab');
global geodesic_library;
geodesic_library = 'libgeodesic';

%% Load Shape
M.vert = load('../shapes/cat10.vert');
M.X = M.vert(:,1);
M.Y = M.vert(:,2);
M.Z = M.vert(:,3);
M.tri = load('../shapes/cat10.tri');

source = 10000;

%% calculate shortest paths
mesh = geodesic_new_mesh(M.vert,M.tri);
algorithm = geodesic_new_algorithm(mesh, 'exact');
time = clock();
source_points = {geodesic_create_surface_point('vertex', source, M.vert(source,:))};
geodesic_propagate(algorithm, source_points);   %propagation stage of the algorithm (the most time-consuming)
[source_id, distances] = geodesic_distance_and_source(algorithm);
time = clock()-time;

%% get paths
for i = (1:10:length(M.X))
    p = geodesic_create_surface_point('vertex', i, M.vert(i,:));
    path{i} = geodesic_trace_back(algorithm, p); %find a shortest path from source to destination
end
%geodesic_delete();

%% plot stuff
figure()
%for more red starting color
distances(1) = -100;
trisurf(M.tri,M.X,M.Y,M.Z,distances);
axis equal, shading interp, axis off
hold on;
for i = (1:10:length(M.X))
    [x,y,z] = extract_coordinates_from_path(path{i});
    plot3(x,y,z,'k','LineWidth',1);    %plot a sinlge path for this algorithm
end
hold off;

%%
drawisolines(M.vert,M.tri,distances,20);

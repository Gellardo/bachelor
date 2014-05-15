% basics of displaying shapes
addpath('toolbox_graph','geodesic_matlab');

%% Load Shape
M.vert = load('../shapes/cat10.vert');
M.X = M.vert(:,1);
M.Y = M.vert(:,2);
M.Z = M.vert(:,3);
M.tri = load('../shapes/cat10.tri');

%% create mat
time = create_mat(M, [], 'test_euclidian.mat'); %~15 min for euclidian

%% define a function on the (vertices of the) shape
%in this case, the euclidean distance
i=25601;
f = sqrt((M.X(i)-M.X).^2 + (M.Y(i)-M.Y).^2 + (M.Z(i)-M.Z).^2);
%f = zeros(length(M.X),1);
%for i = fpsindex
%    f(i) = 1000;
%end

%% try the fps sampling
tic();
%fpsindex = fps_euclidian(500, M); %500 in 0.2s ~9 sec for 1st index
%fpsindex2 = fps_general(100, M, @euclidian_distance); %100 in 52s
fpsindex3 = fps_mat(500, M, 'test_euclidian.mat'); %500 in 14s
toc();
%% isoline
drawisolines(M.vert, M.tri, f, 20)

%% Visualize the shape
figure()
trisurf(M.tri,M.X,M.Y,M.Z,f);
axis equal, shading interp, axis off
hold on;
scatter3(M.X(fpsindex),M.Y(fpsindex),M.Z(fpsindex),'fill');
hold off;

%% Geodesic distance, compute it
global geodesic_library;
geodesic_library = 'libgeodesic';      %"release" is faster and "debug" does additional checks

mesh = geodesic_new_mesh(M.vert,M.tri);         %initilize new mesh
algorithm = geodesic_new_algorithm(mesh, 'exact');      %initialize new geodesic algorithm

source_id = randi(length(M.X));                             %create a single source at vertex #1
source_points = {geodesic_create_surface_point('vertex', source_id, M.vert(source_id,:))};
geodesic_propagate(algorithm, source_points);   %propagation stage of the algorithm (the most time-consuming)
[source_id, distances] = geodesic_distance_and_source(algorithm);     %find distances to all vertices of the mesh; in this example we have a single source, so source_id is always equal to 1
geodesic_delete();
%% plot the geodesic
trisurf(M.tri,M.vert(:,1),M.vert(:,2),M.vert(:,3),distances, 'FaceColor', 'interp', 'EdgeColor', 'k'); 
axis equal, axis off
drawisolines(M.vert,M.tri,distances,50);

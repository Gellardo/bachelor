% basics of displaying shapes
addpath('toolbox_graph','toolbox_graph/toolbox','geodesic_matlab');

%% Load Shape
[M.vert,M.face] = read_off('~/Data/bachelor/shapes/tosca_cat10.off');
M.X = M.vert(1,:);
M.Y = M.vert(2,:);
M.Z = M.vert(3,:);

[N.vert,N.face] = read_off('~/Data/bachelor/shapes/tosca_cat3.off');
N.X = N.vert(1,:);
N.Y = N.vert(2,:);
N.Z = N.vert(3,:);

%% create mat
time = create_mat(M, [], 'test_euclidian.mat'); %~15 min for euclidian

%% look if vertices are same or not -> no
[M.vert,M.face] = read_off_mod('~/Data/bachelor/shapes/shrec2011_0001.null.0.off');
[N.vert,N.face] = read_off_mod('~/Data/bachelor/shapes/shrec2011_0001.noise.2.off');
p = 1000;
figure;
    subplot(1,2,1);
    hold on
    plot_mesh(M.vert,M.face);
    scatter3(M.vert(1,p),M.vert(2,p),M.vert(3,p),'r','fill');
    hold off
    subplot(1,2,2);
    hold on
    plot_mesh(N.vert,N.face);
    scatter3(N.vert(1,p),N.vert(2,p),N.vert(3,p),'r','fill');
    hold off; camlight; axis tight; % zoom(zoomf);
    
%% define a function on the (vertices of the) shape
%in this case, the euclidean distance
i=10;
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
drawisolines(M.vert, M.face, f, 20)

%% Visualize the shape
figure()
trisurf(M.face,M.X,M.Y,M.Z,f);
axis equal, shading interp, axis off
hold on;
%scatter3(M.X(fpsindex),M.Y(fpsindex),M.Z(fpsindex),'fill');
hold off;

%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%             GEODESIC
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Geodesic distance, compute it
[distances time] = distance_geodesic(M,[1,10000],'exact');

%% plot the geodesic
%trisurf(M.face,M.vert(:,1),M.vert(:,2),M.vert(:,3),distances, 'FaceColor', 'interp', 'EdgeColor', 'k'); 
%axis equal, axis off
drawisolines(M.vert,M.face,distances(2,:)',20);

%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%             LAPLACE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% compute the laplacian
nb = 10;
[eigenfunctions, eigenvalues] = mesh_get_laplacian_eigenfunctions(M.vert,M.face, nb);
%% draw the eigenfunctions
%drawisolines(M.vert,M.face,V(:,10),30);
%trisurf(M.face,M.X,M.Y,M.Z,V(:,2));
%axis equal, shading interp, axis off

eigenfunctions = real(eigenfunctions(:,end:-1:1));
% display them on the mesh
ilist = round(linspace(3,nb-3, 6));
tau=2.2; % saturation for display
clf;
for i=1:length(ilist)
    % subplot(1,length(ilist),i);
    v = real(eigenfunctions(:,ilist(i)));
    v = clamp( v/std(v),-tau,tau );
    options.face_vertex_color = v;
    subplot(2,3,i);
    plot_mesh(M.vert,M.face,options);
    shading interp; camlight; axis tight; % zoom(zoomf);
    colormap jet(256);
end

%% different plots of distances using the laplace
ilist = [1:4000: 27900];
opts.type = 'biharmonic';
%opts.t = 1;
dist = distance_laplace(eigenfunctions,eigenvalues,ilist,opts);
figure();
for i=1:length(ilist)
    v = dist(i,:)';
    options.face_vertex_color = v;
    subplot(2,ceil(length(ilist)/2),i);
    plot_mesh(M.vert,M.face,options);
    shading interp; axis off; %camlight; zoom(zoomf);
    colormap jet(256);
end

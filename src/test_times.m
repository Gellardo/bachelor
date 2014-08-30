%for the different meshes
addpath('toolbox_graph','toolbox_graph/toolbox','geodesic_matlab');
datadir = '~/Data/bachelor/shapes/';
%'shrec2010_0003.sampling.5'
meshes = {
		  'shrec2010_0003.sampling.5', 'shrec2010_0003.sampling.4' ... %1000, 4500
		  'shrec2010_0002_sampling.3', 'shrec2010_0002.sampling.1', ... %10000, 20000
		  'shrec2011_0001.null.0' %52000
		  };

fid = fopen('~/Data/bachelor/results/times','a+','n','UTF-8');
fprintf(fid,'\n---------------------%s----------------------------\n',date);
fprintf(fid,'\ttimes: laplacian geodesic diffusion commute_time biharmoinc\n\n');
for mesh = meshes
	[M.vert, M.face] = read_off_mod(strcat(datadir,mesh{1},'.off'));
	vertcount = size(M.vert,2);
	fprintf(fid,'%s:  %d verts\n', mesh{1}, vertcount);
	for i = 1:10
		%time Laplacian
		tic();
		[eigenfunctions, eigenvalues] = mesh_get_laplacian_eigenfunctions(M.vert,M.face, 200);
		time(i,1) = toc();
		[~, time(i,2)] = distance_geodesic(M, [1],'dijkstra');
		opts.type = 'diffusion';
		[~, time(i,3)] = distance_laplace(eigenfunctions, eigenvalues, [1], opts);
		opts.type = 'commute_time';
		[~, time(i,4)] = distance_laplace(eigenfunctions, eigenvalues, [1], opts);
		opts.type = 'biharmonic';
		[~, time(i,5)] = distance_laplace(eigenfunctions, eigenvalues, [1], opts);
	end

	%get an average
	result = mean(time);
	%print it to file
	fprintf(fid, '\ttimes: %f %f %f %f %f\n\n', result);
	fprintf('done with %s\n', mesh{1});
end

fclose(fid);
clear fid;

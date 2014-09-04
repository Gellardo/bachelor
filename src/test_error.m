%for the different meshes
addpath('toolbox_graph','toolbox_graph/toolbox','geodesic_matlab');
datadir = '~/Data/bachelor/shapes/';
corrdir = '~/Data/bachelor/corr_shrec2010/';
laplacedir = '~/Data/bachelor/laplacians/';

meshes = {
%% careful: porig is the reference on the first given shape
%% which has to be a the reference shape of the .label files
'shrec2010_0001.null.0',...
'shrec2010_0001.isometry.1',...
'shrec2010_0001.isometry.2',... %9245
'shrec2010_0001.holes.1',...
'shrec2010_0001.localscale.1',...
'shrec2010_0001.noise.1',...
'shrec2010_0001.scale.1',...
'shrec2010_0001.topology.1',...
'shrec2010_0001.shotnoise.1',...
};
porig = 910;

fid = fopen('~/Data/bachelor/results/error','a+','n','UTF-8');
fprintf(fid,'\n---------------------%s----------------------------\n',date);
fprintf(fid,'1 geodesic, 2 diffusion t=0.1, 3 diffusion t=1, 4 commute-time, 5 biharmonic\n');
fprintf(fid,'\tmax error, avg error for distances from point %d\n\n', porig);
%generate distances for all meshes
for i = 1:size(meshes,2)
	%for mesh = meshes
	[M.vert, M.face] = read_off_mod(strcat(datadir,meshes{i},'.off'));
	vertcount = size(M.vert,2);
	%find the right p from correspondences
	if(~strcmp(meshes{i}(end-5:end-2),'null') )
		corr = load([corrdir,meshes{i}(11:end),'.labels']);
		p = find(corr==porig);
		if(isempty(p))
			error(['test_error: porig has no correspondence in mesh ',meshes{i}]);
		else
			p = p(1);
		end
	else
		corr = [1:vertcount];
		p = porig;
	end

	%use precomputed laplacians
    if(exist([laplacedir,meshes{i},'.mat'], 'file'))
		%load precomputed laplacian
		matf = matfile([laplacedir,meshes{i},'.mat']);
		eigenfunctions = matf.eigenfunctions;
		eigenvalues = matf.eigenvalues;
		clear matf;
	else
		[eigenfunctions, eigenvalues] = mesh_get_laplacian_eigenfunctions(M.vert,M.face, 200);
    end
	
%	[d(1,:), ~] = distance_geodesic(M, p,'exact');
	opts.type = 'diffusion';
	opts.t = 0.1;
	[d(2,:), ~] = distance_laplace(eigenfunctions, eigenvalues, p, opts);
	opts.t = 1;
	[d(3,:), ~] = distance_laplace(eigenfunctions, eigenvalues, p, opts);
	opts.type = 'commute_time';
	[d(4,:), ~] = distance_laplace(eigenfunctions, eigenvalues, p, opts);
	opts.type = 'biharmonic';
	[d(5,:), ~] = distance_laplace(eigenfunctions, eigenvalues, p, opts);

	%save distances
	m{i} = {meshes{i}, d, corr};

	%print it to file
	fprintf('distances done for %s\n', meshes{i});
    clear d;
end

for i = 2:size(m,2)
	fprintf(fid,'%s:\n',m{i}{1});
	for j = 1:size(m{1}{2},1)
		corr = m{i}{3}(:);
		error = m{1}{2}(j, corr) - m{i}{2}(j,:);
		error = error./max(m{1}{2}(j,:));
		maxerror = max(error);
		meanerror = mean(error);

		%write stuff
		fprintf(fid,'\t%d: mean %f, max error %f\n', j, meanerror, maxerror);
	end
	fprintf(fid,'\n');
end

fclose(fid);
clear fid;

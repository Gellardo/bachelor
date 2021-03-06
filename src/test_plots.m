%plot_mesh: opt view_param: [1,2]
addpath('toolbox_graph','toolbox_graph/toolbox','geodesic_matlab');
datadir = '~/Data/bachelor/shapes/';
outdir = '~/Data/bachelor/results/pictures/';
corrdir = '~/Data/bachelor/corr_shrec2010/';
laplacedir = '~/Data/bachelor/laplacians/';
meshes = {
    {'shrec2010_0001.null.0', 910},...
    %{'shrec2010_0001.isometry.1',9245},...
    %{'shrec2010_0001.microholes.1',1},...
    %{'shrec2010_0001.microholes.2',1},...
    %{'shrec2010_0001.holes.2',1},...
    %{'shrec2010_0001.holes.3',1},...
	%{'shrec2010_0001.localscale.2',1},...
	%{'shrec2010_0001.noise.2',1},...
	%{'shrec2010_0001.scale.2',1},...
	%{'shrec2010_0001.topology.2',1},...
	%{'shrec2010_0001.shotnoise.2',1},...
};
porig = 910;

fid = fopen('~/Data/bachelor/results/plots','a+','n','UTF-8');
fprintf(fid,'\n---------------------%s----------------------------\n',date);
fprintf(fid,'1 geodesic, 2 diffusion t=0.1, 3 diffusion t=1, 4 commute-time, 5 biharmonic\n');
time = tic();
for mesh = meshes
	%find the right p from correspondences
	if(~strcmp(mesh{1}{1}(end-5:end-2),'null') )
		corr = load([corrdir,mesh{1}{1}(11:end),'.labels']);
		p = find(corr==porig);
		if(isempty(p))
			error(['test_plots: porig has no correspondence in mesh ',mesh{1}{1}])
		else
			p = p(1);
		end
	else
		p = porig;
    end
    
	if(exist([laplacedir,mesh{1}{1},'.mat'], 'file'))
		%load precomputed laplacian
		matf = matfile([laplacedir,mesh{1}{1},'.mat']);
		eigenfunctions = matf.eigenfunctions;
		eigenvalues = matf.eigenvalues;
		clear matf;
		laplace_loaded = 1;
	else
		laplace_loaded = 0;
    end

	[M.vert, M.face] = read_off_mod(strcat(datadir,mesh{1}{1},'.off'));

	if(~laplace_loaded)
		[eigenfunctions, eigenvalues] = mesh_get_laplacian_eigenfunctions(M.vert,M.face, 200);
	end

	[d(1,:), ~] = distance_geodesic(M, p,'exact');

	%%
	opts.type = 'diffusion';
	opts.t = 0.05;
	[d(2,:), ~] = distance_laplace(eigenfunctions, eigenvalues, p, opts);
	opts.t = 1;
	[d(3,:), ~] = distance_laplace(eigenfunctions, eigenvalues, p, opts);
	opts.type = 'commute_time';
	[d(4,:), ~] = distance_laplace(eigenfunctions, eigenvalues, p, opts);
	opts.type = 'biharmonic';
	[d(5,:), ~] = distance_laplace(eigenfunctions, eigenvalues, p, opts);

	%print it to file
	fprintf(fid,'done with %s\n', mesh{1}{1});
	fprintf('done with %s\n', mesh{1}{1});

	%% plot stuff
%       start at 1 
	for i = 1:size(d,1);
		tmp = d(i,:)';
		opt.face_vertex_color = tmp;
		opt.view_param = [0,0];
		fig = drawisolines(M.vert', M.face', tmp, 100, opt);
		%p=9245;
		%hold on
		%scatter3(M.vert(1,p),M.vert(2,p),M.vert(3,p),'r','fill');
		%hold off
%		print(fig, '-dtiff', '-r300', [outdir,mesh{1}{1},'_',num2str(i)]);
%		close(fig);
	end
	clear d;
end
fprintf(fid,'time needed: %f\n\n', toc(time));

fclose(fid);
clear fid;

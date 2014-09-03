%plot_mesh: opt view_param: [1,2]
addpath('toolbox_graph','toolbox_graph/toolbox','geodesic_matlab');
datadir = '~/Data/bachelor/shapes/';
outdir = '~/Data/bachelor/results/pictures/';
meshes = {
		  %{'shrec2010_0001.isometry.2',9245},... %9245
		  {'shrec2010_0001.null.0', 910}
		  };

fid = fopen('~/Data/bachelor/results/plots','a+','n','UTF-8');
fprintf(fid,'\n---------------------%s----------------------------\n',date);
fprintf(fid,'1 geodesic, 2 diffusion t=0.1, 3 diffusion t=1, 4 commute-time, 5 biharmonic\n');
for mesh = meshes
    %todo with corresponences
	p = mesh{1}{2};
	[M.vert, M.face] = read_off_mod(strcat(datadir,mesh{1}{1},'.off'));

	[eigenfunctions, eigenvalues] = mesh_get_laplacian_eigenfunctions(M.vert,M.face, 200);
    
	[d(1,:), ~] = distance_geodesic(M, p,'exact');
    %%
	opts.type = 'diffusion';
	opts.t = 0.1;
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
	for i = 1:size(d,1);
		tmp = d(i,:)';
		opt.face_vertex_color = tmp;
		opt.view_param = [0,0];
		fig = drawisolines(M.vert', M.face', tmp, 20, opt);
		%p=9245;
		%hold on
		%scatter3(M.vert(1,p),M.vert(2,p),M.vert(3,p),'r','fill');
		%hold off
		%print(fig, '-dtiff', '-r300', [outdir,mesh{1}{1},'_',num2str(i)]);
	end
end

fclose(fid);
clear fid;

%plot_mesh: opt view_param: [1,2]
addpath('toolbox_graph','toolbox_graph/toolbox','geodesic_matlab');
datadir = '~/Data/bachelor/shapes/';
outdir = '~/Data/bachelor/results/pictures/';
corrdir = '~/Data/bachelor/corr_shrec2010/';
laplacedir = '~/Data/bachelor/laplacians/';
meshes = {
	%{'shrec2010_0002.isometry.2',9245},... %9245
	{'shrec2010_0002.holes.5',1},...
    %{'shrec2010_0002.holes.4',1},...
    %{'shrec2010_0002.topology.2',1},...
    %{'shrec2010_0002.null.0', 910},...
    %{'shrec2010_0002.localscale.2',1},...
	%{'shrec2010_0002.noise.2',1},...
	%{'shrec2010_0002.scale.2',1},...
	%{'shrec2010_0002.shotnoise.2',1},...
};
porig = 910;

fid = fopen('~/Data/bachelor/results/fps','a+','n','UTF-8');
fprintf(fid,'\n---------------------%s----------------------------\n',date);
fprintf(fid,'1 geodesic, 2 diffusion t=0.1, 3 diffusion t=1, 4 commute-time, 5 biharmonic, 6 euclidean\n');
time = tic();
for mesh = meshes
	%find the right p from correspondences
	if(~strcmp(mesh{1}{1}(end-5:end-2),'null') )
		corr = load([corrdir,mesh{1}{1}(11:end),'.labels']);
		p = find(corr==porig);
		if(isempty(p))
			error(['test_fps: porig has no correspondence in mesh ',mesh{1}{1}])
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

	%%
    n = 150;
%    ind(1,:) = fps_general(n, M, eigenfunctions, eigenvalues, 'geodesic', p);
    ind(2,:) = fps_general(n, M, eigenfunctions, eigenvalues, 'diffusion', p);
    ind(3,:) = fps_general(n, M, eigenfunctions, eigenvalues, 'diffusion1', p);
    ind(4,:) = fps_general(n, M, eigenfunctions, eigenvalues, 'commute_time', p);
    ind(5,:) = fps_general(n, M, eigenfunctions, eigenvalues, 'biharmonic', p);
    ind(6,:) = fps_general(n, M, eigenfunctions, eigenvalues, 'euclidean', p);
    
	%print it to file
	fprintf(fid,'done with %s\n', mesh{1}{1});
	fprintf('done with %s\n', mesh{1}{1});

	%% plot stuff
%           start from 1
	for i = 2:size(ind,1);
		tmp = ind(i,:)';
		%opt.face_vertex_color = tmp;
		%opt.view_param = [0,0];
		%fig = drawisolines(M.vert', M.face', tmp, 20, opt);
		%p=9245;
		%hold on
        fig = figure();
        hold on;
        plot_mesh(M.vert,M.face);
		scatter3(M.vert(1,tmp),M.vert(2,tmp),M.vert(3,tmp),'r','fill');
        camproj('perspective');
        axis square; 
        axis off;
        view(60,0);
        axis tight;
        axis equal;
		hold off
		print(fig, '-dtiff', '-r300', [outdir,'fps_',mesh{1}{1},'_',num2str(i)]);
		close(fig);
	end
	clear ind;
end
fprintf(fid,'time needed: %f\n\n', toc(time));

fclose(fid);
clear fid;

%for the different meshes
addpath('toolbox_graph','toolbox_graph/toolbox','geodesic_matlab');
datadir = '~/Data/bachelor/shapes/';
corrdir = '~/Data/bachelor/corr_shrec2010/';
meshes = {
    %% careful: porig is the reference on the first given shape
    %% which has to be a the reference shape of the .label files
            'shrec2010_0001.null.0',...
            %'shrec2010_0001.null.0'
            'shrec2010_0001.holes.1'
		  };
porig = 910;

fid = fopen('~/Data/bachelor/results/error','a+','n','UTF-8');
fprintf(fid,'\n---------------------%s----------------------------\n',date);
fprintf(fid,'\tmax error, avg error\n\n');
%generate distances for all meshes
for i = 1:size(meshes,1)
%for mesh = meshes
	[M.vert, M.face] = read_off_mod(strcat(datadir,meshes{i},'.off'));
    vertcount = size(M.vert,2);
	%find the right p from correspondences
    if(~strcmp(meshes{i}(end-5:end-2),'null') )
        corr = load([corrdir,meshes{i}(11:end),'.labels']);
        p = find(corr==porig);
        if(isempty(p))
            error(['test_error: porig has no correspondence in mesh ',meshes{i}])
        else
            p = p(1);
        end
    else
        corr = [1:vertcount];
        p = porig;
    end
    
	[eigenfunctions, eigenvalues] = mesh_get_laplacian_eigenfunctions(M.vert,M.face, 200);
	[d(1,:), ~] = distance_geodesic(M, p,'dijkstra');
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
end

corr = m{2}{3}(:);
maxerror = max(m{1}{2}(1, corr) - m{2}{2}(1,:))/max(m{1}{2}(1,:));

fclose(fid);
clear fid;

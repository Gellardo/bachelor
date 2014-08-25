%% done: cat centaur david dog michael wolf victoria horse -> tosca done
%% todo: shrec
%% problems: gorilla
addpath('toolbox_graph','toolbox_graph/toolbox');
datadir = '~/Data/bachelor/shapes/';
outdir = '~/Data/bachelor/laplacians/';

convert = 0;

%% convert *.vert + *.tri into *.off
if convert
vertfiles = dir(strcat(datadir, '*.vert'));
trifiles = dir(strcat(datadir, '*.tri'));

for file = vertfiles'
	[filename ~] = strsplit(file.name, '.vert');
	filename = filename(1);
	%check for tri
	if(strncmp(filename, [trifiles.name],length(filename)))
		vert = load(strcat(datadir, filename{1},'.vert'));
		tri = load(strcat(datadir, filename{1},'.tri'));
		fprintf('loaded %s files to write them\n',filename{1});

		write_off(strcat(datadir, filename{1},'.off'),vert,tri);
	end
end

clear filename
clear file
clear vertfiles
clear trifiles
clear vert
clear tri
end
%% calculate the Laplacian for all of the shapes

%files = dir(strcat(datadir,'tosca_*.off'));
files = dir(strcat(datadir,'s*null*.off'));

for file = files'
	fprintf('start laplacian for %s: ',file.name);
	[filename, ~] = strsplit(file.name, '.off');
	filename = filename(1);
	[M.vert,M.face] = read_off_mod(strcat(datadir, file.name));
	[eigenfunctions, eigenvalues] = mesh_get_laplacian_eigenfunctions(M.vert,M.face, 200);
	matf = matfile(strcat(outdir, filename{1},'.mat'), 'Writable', true);
	matf.name = filename{1};
	matf.eigenfunctions = eigenfunctions;
	matf.eigenvalues = eigenvalues;

	fprintf('finished laplacian for %s\n',file.name);

end

clear all

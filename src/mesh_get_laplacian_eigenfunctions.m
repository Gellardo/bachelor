function [ V,D ] = mesh_get_laplacian_eigenfunctions( vert, face, k )
%MESH_GET_LAPLACIAN_EIGENFUNCTIONS compute eigenfunctions of a mesh
%   [vert, face] = representation of mesh as a n x 3 matrix of vertex
%                   positions and a m x 3 matrix of vertex indices of the
%                   triangles
%   k = number of eigenfunctions to compute
%   
%   V =  n x k matrix containing the values of the vertices for each
%        eigenfunction

%% compute laplacian
% options for the Laplacians
laplacian_type = 'conformal'; % slow to compute
%laplacian_type = 'combinatorial'; % fast, but inexact
%laplacian_type = 'distance'; % fast and more accurate
% compute a normalized Laplacian
options.symmetrize = 0;
options.normalize = 1;
L = compute_mesh_laplacian(vert,face,laplacian_type,options);

%% get eigenfunctions
opts.disp = 0;
[V,D] = eigs(L,k,'SM',opts); % warning : it takes lot of time
D = sum(D);
end


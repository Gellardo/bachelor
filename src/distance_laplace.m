function [d, time] = distance_laplace(phi, lambda, indices, opts)
% laplace_distance - compute a distance which depends on
%                    the eigenfunctions of the laplace operator.
%
%   laplace_distance(phi,lambda, indices, opts);
%       - phi : MxN matrix of eigenfunctions where one row represents the 
%               values of one vertex
%       - lambda : 1xN vector containing the eigenvalues corresponding to
%                  the eigenfunctions phi
%       - indices : indices of the vertices which distances need to be
%                   computed
%
%   'opts' is a structure that may contains:
%       - 'type' : the type of distance function; one of the following
%                  'diffusion','commute_time' or 'biharmonic'(default)
%       - 't' : necessary time parameter for the diffusion distance, not
%               needed for the others (default = 0)
%
    type = getoptions(opts, 'type', 'biharmonic');
    t    = getoptions(opts, 't', 1);
    
    %to make it scale-invariant according to the biharmoinc paper
	%WARNING: TAKE BIGGEST EIGENVALUE
	t = t*lambda(end);
    
    if strcmp(type, 'diffusion')
        dfunc = @(i,j,phi,lambda)d_diffusion(i,j,phi,lambda,t);
    elseif strcmp(type, 'commute_time')
        dfunc = @d_commute_time;
    else
        dfunc = @d_biharmonic;
    end

    d = zeros(length(indices),size(phi,1));
	tic();
    for i = 1:length(indices)
        for j = 1:size(phi,1)
            d(i,j) = sqrt(dfunc(indices(i),j,phi,lambda));
        end
    end
	time = toc();
end

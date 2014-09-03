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
    
    % take away lambda(1) because it is (close to) zero
    %to make it scale-invariant according to the biharmoinc paper
	%WARNING: TAKE BIGGEST EIGENVALUE
    phi = phi(:,2:end);
    lambda = lambda(2:end);
    t = t/(2*lambda(1));
    
    if strcmp(type, 'diffusion')
        dfunc = @(i,phi,lambda)d_diffusion(i,phi,lambda,t);
    elseif strcmp(type, 'commute_time')
        dfunc = @d_commute_time;
    else
        dfunc = @d_biharmonic;
    end

    d = zeros(length(indices),size(phi,1));
	tic();
    for i = 1:length(indices)
        d(i,:) = sqrt(dfunc(indices(i),phi,lambda));
    end
	time = toc();
end

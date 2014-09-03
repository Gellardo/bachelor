function [d] = d_diffusion(i,phi,lambda,t)
%phi, lambda coloumn vector for one eigenfunction
	px = phi(i,:);
    for j = 1:size(phi,1)
	py = phi(j,:);
	tmp = ((px-py).^2).*(exp(-2*t*lambda));
	d(j) = sum(tmp);
    end
end
%	px = phi(i,:);
%	py = phi(j,:);
%	d = ((px-py).^2).*(exp(-2*t*lambda));
%	d = sum(d);

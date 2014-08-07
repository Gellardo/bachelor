function [d] = diffusion_d(i,j,phi,lambda,t)
%phi, lambda coloumn vector for one eigenfunction
	px = phi(i,:);
	py = phi(j,:);
	d = ((px-py).^2).*(e^(-2*t*lambda));
	d = sum(d);
end

function [d] = biharmonic_d(i,j,phi,lambda)
%phi, lambda coloumn vector for one eigenfunction
	px = phi(i,:);
	py = phi(j,:);
	d = ((px-py).^2)./(lambda.^2);
	d = sum(d);
end

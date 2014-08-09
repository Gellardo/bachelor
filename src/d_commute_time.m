function [d] = d_commute_time(i,j,phi,lambda)
%phi, lambda coloumn vector for one eigenfunction
	px = phi(i,:);
	py = phi(j,:);
	d = ((px-py).^2)./lambda;
	d = sum(d);
end

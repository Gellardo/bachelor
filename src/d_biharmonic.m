function [d] = d_biharmonic(i,phi,lambda)
%phi, lambda coloumn vector for one eigenfunction
px = phi(i,:);
for j = 1:size(phi,1)
	py = phi(j,:);
	tmp = ((px-py).^2)./(lambda.^2);
	d(j) = sum(tmp);
end
end

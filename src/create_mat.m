function time = create_mat(M, func, name)
%manifold M, distance function func, name of file 'name'
dim = length(M.X);
file = matfile(name, 'Writable', true);
file.d(dim,dim) = 0;
time = clock();
for i = 1:dim
    file.d(i,:) = sqrt((M.X-M.X(i)).^2 + (M.Y-M.Y(i)).^2 + (M.Z - M.Z(i)).^2)';
end
time = clock() - time;
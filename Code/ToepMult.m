function z = ToepMult(e, r)
%
% The function calculate the result column z from the matrix-vector
% multiplication T*r, where T is an nxn symmetric Toeplitz matrix
%
% Input:  - e: the column vector containing all the eigenvalues of C, where
%               C is the circulant matrix of double the dimension of T
%         - r: the first column of the matrix T
% 
% Output: - z: the result column vector
n = length(r);
r = [r; zeros(n,1)];
z = ifft (e .* fft(r));
z = z(1:n,1);
end
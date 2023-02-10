function z = CircSolve(e, r)
%
% The function solve the nonsingular circulant systems of equations, Cz=r,
% where C is the circulant matrix, r is the result column vector, using the
% fft method
%
% Input:  - e : a column vector containing eigenvalues of matrix C
%         - r : a column vector we want to compute C*r
%
% Output: - z : the unknown vector

e = 1./e;

z = ifft (e .* fft(r));

end
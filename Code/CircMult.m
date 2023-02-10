function z = CircMult(e, r)
%
% The function calculate the matrix-vector multiplication z = C*r, where C
% is the circulant matrix
%
% Input:  - e : a column vector containing eigenvalues of matrix C
%         - r : a column vector we want to compute C*r
%
% Output: - z : the result vector
%
z = ifft (e .* fft(r));
    
end
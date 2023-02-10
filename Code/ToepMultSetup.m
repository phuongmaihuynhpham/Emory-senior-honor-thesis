function e = ToepMultSetup(t)
% 
% The function computes the eigenvalue of an 2nx2n circulant matrix, C,
% generated from a nxn symmetric Toeplizt matrix, T
%
% Input:  - t: the first column of matrix T
% Output: - e: the column vector containing all the eigenvalues of C
%

t_new = flip(t);
c = [t; 0; t_new(1:end-1,:)];
e = fft(c);
end
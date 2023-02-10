function e = CircEig(c)
% 
% The function calculates the eigenvalue of a circulant matrix C
%
% Input:  - c: the first column of matrix C
%
% Output: - e: the column vector containing all the eigenvalues of C
%

e = fft(c);

end
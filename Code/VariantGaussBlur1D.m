function A = VariantGaussBlur1D(n, s)
%
%
if nargin == 1
    % If Gaussian standard variation is not given, then generate
    % random values from a uniform distribution in [1, 3]. 
    % 
    s1 = sort(2*rand(n,1)+1,'ascend');
    s2 = sort(-2*rand(n,1)-1,'ascend');
    s = abs([s2;s1]);
end
A = zeros(2*n, 2*n);
for j = 1:2*n
    [PSF, center] = psfGauss1D(4*n, s(j));
    P = PSF(center-j+1:2*n+center-j);
    A(j,:) = P; 
end
    
function [Ar,Ac] = VariantGaussBlur2D(n, s)
% Explicitly build the row and column components of matrix A in the
% spatially variant Gaussian problem 
% A = kron(Ar,Ac)
if nargin == 1
    % If Gaussian standard variation is not given, then generate
    % random values from a uniform distribution in [1, 7]. 
    % 
    s1 = (6*rand(n,1)+1);
    s2 = (-6*rand(n,1)-1);
    s = abs([s2;s1]);
end

Ar = zeros(2*n, 2*n);
Ac = zeros(2*n, 2*n);

for j = 1:2*n
    [PSF, center] = psfGauss(4*n, s(j));
    [U, S, V] = svds(PSF, 2);

% r and c are computed from the largest singular value and its
% corresponding vector of P (page 49)

    minU = abs(min(U(:,1)));
    maxU = max(abs(U(:,1)));
    if minU == maxU
        U = -U;
        V = -V;
    end
    
    % Compute the row and column matrices
    r = sqrt(S(1,1))*V(:,1);
    c = sqrt(S(1,1))*U(:,1);
    
    % Shift the center of the row and column matrices
    R = r(center-j+1:2*n+center-j);
    C = c(center-j+1:2*n+center-j);
    
    % Build the matrix column by column since this is a spatially variant
    % problem, each column is created from a different psfGauss
    Ar(j,:) = R; 
    Ac(j,:) = C;
end
    
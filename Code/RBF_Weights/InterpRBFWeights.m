function d = InterpRBFWeights(n, nregions)
%
% Compute weights for RBF interpolation of regions (using Gaussian func).
% The weight should be 1 for the center of the region.
%
% Input: 
%        n = length of signal
% nregions = number of regions for interpolation
%
% Output:
%        d = weights
%
gamma = 0.05; 
% Anything below 0.1 is good for the approximation. (0.005 - 0.05 is ideal)

[~, ~, IdxCenter] = RegionPointers(n, nregions);
d = zeros(n, nregions);
%
% First region should be constant 1 to center, then a curve downward to
% center of second region:
d(1:IdxCenter(1),1) = 1;
x = IdxCenter(1)+1:IdxCenter(2);
d(x,1) = exp(-gamma*(x-IdxCenter(1)).^2); 
%
% Now do interior regions, curves sloped upward and downward, which are
% zero at IdxCenter(j-1) and IdxCenter(j+1), and
% one  at IdxCenter(j)
%
for j = 2:nregions-1
    x = IdxCenter(j-1):IdxCenter(j+1);
    d(x,j) = exp(-gamma*(x-IdxCenter(j)).^2); 
end
%
% Last region should be a curve from the center of region (n-1) to center
% of region n, then constant 1 to n:
x = IdxCenter(nregions-1):IdxCenter(nregions);
d(x,nregions) = exp(-gamma*(x-IdxCenter(nregions)).^2); 
d(IdxCenter(nregions)+1:n,nregions) = 1;
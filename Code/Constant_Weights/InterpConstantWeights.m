function d = InterpConstantWeights(n, nregions)
%
% Compute weights for simple constant interpolation of regions.
% The weight should be 1 for the center of the region.
%
% Input: 
%        n = length of signal
% nregions = number of regions for interpolation
%
% Output:
%        d = weights
%
[IdxStart, IdxEnd] = RegionPointers(n, nregions);
d = zeros(n, nregions);
for j = 1:nregions
    d(IdxStart(j):IdxEnd(j),j) = 1;
end
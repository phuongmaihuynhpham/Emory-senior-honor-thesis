function d = InterpLinearWeights(n, nregions)
%
% Compute weights for linear interpolation of regions.
% The weight should be 1 for the center of the region.
%
% Input: 
%        n = length of signal
% nregions = number of regions for interpolation
%
% Output:
%        d = weights
%
[~, ~, IdxCenter] = RegionPointers(n, nregions);
d = zeros(n, nregions);
%
% First region should be constant 1 to center, then a line down to
% center of second region:
d(1:IdxCenter(1),1) = 1;
x = IdxCenter(1)+1:IdxCenter(2);
m = 1/(IdxCenter(1)-IdxCenter(2)); % slope of line
d(x,1) = m*(x - IdxCenter(2));
%
% Now do interior regions, lines up and down, which are
% zero at IdxCenter(j-1) and IdxCenter(j+1), and
% one  at IdxCenter(j)
%
for j = 2:nregions-1
    x = IdxCenter(j-1):IdxCenter(j);
    m = 1/(IdxCenter(j)-IdxCenter(j-1)); % slope up
    d(x,j) = m*(x-IdxCenter(j-1));
    x = IdxCenter(j)+1:IdxCenter(j+1);
    m = 1/(IdxCenter(j)-IdxCenter(j+1)); % slope down
    d(x,j) = m*(x-IdxCenter(j+1)); 
end
%
% Last region should be a line from the center of region (n-1) to center
% of region n, then constant 1 to n:
x = IdxCenter(nregions-1):IdxCenter(nregions);
m = 1/(IdxCenter(nregions)-IdxCenter(nregions-1)); % slope of line
d(x,nregions) = m*(x - IdxCenter(nregions-1));
d(IdxCenter(nregions)+1:n,nregions) = 1;
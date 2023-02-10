function d = InterpRBFWeights_new(n, nregions)
%
% Compute weights for RBF interpolation of regions (using Gaussian func).
% The weight should be 1 for the center of the region.
%
% Input: 
%        n = length of signalew
% nregions = number of regions for interpolation
%
% Output:ew
%        d = weights
%

% JN Comment:
% I'm not sure we want to "choose" gamma. Instead, I think the spread of
% the Gaussian needs to be defined by the regions widths (see below).

% JN Comment:
% I think we need the region boundaries.
[IdxStart, IdxEnd, IdxCenter] = RegionPointers(n, nregions);
d = zeros(n, nregions);
%
% First region should be constant 1 to center, then a curve downward to
% center of second region:
d(1:IdxCenter(1),1) = 1;
x = IdxCenter(1)+1:IdxCenter(2)-1;
%
% JN Comment:
% I think we need to use the idea of full width-half-maximum, so that the 
% it corresponds with region boundaries.
%sqrt2pi = sqrt(2*pi);
FWHMc = 2*sqrt(2*log(2));
FWHM = IdxEnd(1)-IdxStart(1);
sigma = FWHM/FWHMc;
% 2 options to build d
%d(x,1) = exp(-((x-IdxCenter(1)).^2)/(sigma*sqrt2pi));
d(x,1) = exp(-((x-IdxCenter(1)).^2)/(2*sigma^2));
%
% Now do interior regions, curves sloped upward and downward, which are
% zero at IdxCenter(j-1) and IdxCenter(j+1), and
% one  at IdxCenter(j)
%
for j = 2:nregions-1
    x = IdxCenter(j-1)+1:IdxCenter(j+1)-1;
    IdxCenter(j);
    FWHM = IdxEnd(j)-IdxStart(j);
    sigma = FWHM/FWHMc;
    % 2 options to build d
    %d(x,j) = exp(-((x-IdxCenter(j)).^2)/(sigma*sqrt2pi));
    % sqrt2pi is for scaling
    d(x,j) = exp(-((x-IdxCenter(j)).^2)/(2*sigma^2));
end
%
% Last region should be a curve from the center of region (n-1) to center
% of region n, then constant 1 to n:
x = IdxCenter(nregions-1)+1:IdxCenter(nregions);
FWHM = IdxEnd(nregions)-IdxStart(nregions);
sigma = FWHM/FWHMc;
% 2 options to build d: use 2sigma^2
%d(x,nregions) = exp(-((x-IdxCenter(nregions)).^2)/(sigma*sqrt2pi));
d(x,nregions) = exp(-((x-IdxCenter(nregions)).^2)/(2*sigma^2));
d(IdxCenter(nregions)+1:n,nregions) = 1;
%
% Now let's normalize the weights so they sum to one:
s = sum(d,2);
d = diag(1./s)*d;
function [IdxStart, IdxEnd, IdxCenter] = RegionPointers(n, nregions)
%
% If a grid of "n" points is divided into "nregions" subintervals, 
% we want to find the startiing, center, and ending index of each
% subinterval.
%
% Input:
%        n        = number of grid points
%        nregions = number of subregions
%
% Output:
%       IdxStart  = vector of length nregions containing starting indices
%                   of each subinterval. Note that IdxStart(1) = 1.
%       IdxEnd    = vector of length nregions containing ending indices
%                   of each subinterval. Note that IdxStart(end) = n.
%       IdxCenter = vector of length nregions containing indices marking
%                   the "center" of each subinterval. Note that these
%                   must be integers, so these may not be actual center
%                   points.
%
h = (n-1)/nregions;
idx = 1:h:n;

IdxStart = round(idx(1:nregions));
IdxEnd = [IdxStart(2:nregions)-1, n];
IdxCenter = round(mean([IdxStart;IdxEnd]));



function [PSF, center] = psfGauss1D(n, s)
%PSFGAUSS1D Array with point spread function for Gaussian blur.
%
%function [PSF, center] = psfGauss(n, s, band)
%
%            PSF = psfGauss(n);
%            PSF = psfGauss(n, s);
%            PSF = psfGauss(n, s, band);
%  [PSF, center] = psfGauss(...)
%
%  Construct a Gaussian blur point spread function. 
%
%  Input:
%      n     Desired length of the PSF.  For example,
%             PSF = psfGauss(256) or
%      s     Standard deviations of the Gaussian along
%             Default is s = 2.0.
%
%  Output:
%      PSF  Vector containing the point spread function.
%   center  Scalar gives index of center of PSF

%
% Check number of inputs and set default parameters.
%
if (nargin < 1)
   error('dim must be given.')
end
if (nargin < 2)
  s = 2.0;
end

%
% Set up grid points to evaluate the Gaussian function.
%
x = (-fix(n/2):ceil(n/2)-1)';

%
% Compute the normalized Gaussian.
%
PSF = exp( -(x.^2)/(2*s^2) )/sqrt(2*pi*s^2);

%
% Get center ready for output.
%
if nargout == 2
  [~,center] = max(PSF(:));
end
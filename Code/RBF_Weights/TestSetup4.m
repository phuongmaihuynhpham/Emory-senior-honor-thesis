function [A, Aint, b, x, C, d] = TestSetup4(nregions)
%
% Set up a spatially variant 1D image deblurring problem.
%
if nargin == 0
    nregions = 4;
end
x = spectra2;
%x = [x;x;x;x;x;x];
disp('here')
n = size(x,1);
%
% x is a one-dimensional signal. We'll assume that it is zero
% outside the field of view. Note that we need n to be even.
%
x_big = padarray(x, [n/2,0],'both');
%
% VariantGaussBlur1D uses a random number generator. To make sure
% we can repeat this experiment with the same random numbers, we
% set the seed to a known value.
%
rng(0);
A_big = VariantGaussBlur1D(n);
b_big = A_big*x_big;
% extract out the boundaries
A = A_big(n/2+1:n/2+n,n/2+1:n/2+n);
b = b_big(n/2+1:n/2+n);
%
% Our problem will be that essentially we only know a few columns
% of matrix A. These columns represent point spread functions in 
% different regions. For example, if n = 64, and we assume we have 
% 4 regions partitioned as: [1,16],[17,32],[33,48],[49,64], then
% we will know columns 9, 25, 40, 56. Let's get these columns.
%
if nregions == n
    % It would be silly to use nregions = n ...
    IdxCenter = 1:n;
else
    % ... generally, nregions << n
    [~, ~, IdxCenter] = RegionPointers(n, nregions);
end
C = A(:,IdxCenter);

%
% If we use zero boundary conditions, and RBF
% interpolation, then we get an approximation for our matrix as
% follows:
%
if nregions == n
    % It would be silly to use nregions = n ...
    d = eye(n,n);
else
    % ... generally, nregions << n
    d = InterpRBFWeights(n, nregions);
end
Aint = zeros(n, n);
for k = 1:nregions
    D = diag(d(:,k));
    %
    % Note that here we are building T and D explicitly. This is very
    % inefficient. For not it is fine to do some testing. But eventually
    % we will just want to use the columns C and the vectors d to do
    % matrix-vector multiplies with FFTs, and use these in iterative
    % methods.
    %
    T = build_toep(C(:,k), IdxCenter(k), n);
    Aint = Aint + T*D;
end
function [A, Aint, b, x, Cr, Cc, d, ProbInfo] = TestSetup2D(nregions)
%
% Set up a spatially variant 2D image deblurring problem.
%
if nargin == 0
    nregions = 4;
end
% Can change n here, n = size of image
n=128;
[~,~,x,ProbInfo] = PRblur(n,struct('BC','zero'));
% x from the PRblur is a stack n^2x1 column vector -> need to reshape to 
% a nxn matrix
x = reshape(x,n,n);
%
% We'll assume that it is zero boundary condition (zero outside the field 
% of view). Note that we need n to be even. So we pad n/2 zeros columns and
% rows to all 4 sides of the "matrix" X (X now becomes 2nx2n matrix)
%
x_big = padarray(x, [n/2,n/2],'both');
%
% VariantGaussBlur2D uses a random number generator. To make sure
% we can repeat this experiment with the same random numbers, we
% set the seed to a known value.
%
rng(0);
[Ar_big,Ac_big] = VariantGaussBlur2D(n);
% use the property of Kronecker product: kron(Ar,Ac)vec(X) = vec(AcXAr') to
% avoid explicitly build A_big, which is HUGE
b_big = Ac_big*x_big*Ar_big';
% extract out the boundaries
Ar = Ar_big(n/2+1:n/2+n,n/2+1:n/2+n);
Ac = Ac_big(n/2+1:n/2+n,n/2+1:n/2+n);
A = kronMatrix(Ar,Ac);
b = b_big(n/2+1:n/2+n,n/2+1:n/2+n);
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
Cc = Ac(:,IdxCenter);
Cr = Ar(:,IdxCenter);

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
    d = InterpRBFWeights_new(n, nregions);
end
Ar_int = zeros(n, n);
Ac_int = zeros(n, n);
for i = 1:nregions % col
    Di = diag(d(:,i));
    Tc = build_toep(Cc(:,i), IdxCenter(i), n);
    Ac_int = Ac_int + Tc*Di;
    for j = 1:nregions % row
        Dj = diag(d(:,j));
    
    % Note that here we are building T and D explicitly. This is very
    % inefficient. For not it is fine to do some testing. But eventually
    % we will just want to use the columns C and the vectors d to do
    % matrix-vector multiplies with FFTs, and use these in iterative
    % methods.
    %
    % Apply RBF interpolation to Ar and Ac separately, then build A by
    % using the Kronecker product relation: A = kron(Ar,Ac)
    
    % AcDXDAr' 
        Tr = build_toep(Cr(:,j), IdxCenter(j), n);
        Ar_int = Ar_int + Tr*Dj;
    end
end
Aint = kronMatrix(Ac_int, Ar_int);
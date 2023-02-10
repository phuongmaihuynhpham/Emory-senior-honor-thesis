function [A, Aint, b, x, Cr, Cc, d, ProbInfo] = TestSetup2D_ref1(nregions, weight)
%
% Set up a spatially variant 2D image deblurring problem.
%

% Can change n here, n = size of image (however, we start with an image
% that is twice the size of the desired image)
n=128;
%x_big = load('Grain_large.mat');
%x_big = x_big.x_large_true;

% if nargin == 0
%     nregions = log2(n);
% end

% im2gray or rgb2gray does not seem to do well
image = imresize(double(imread('kids.tiff')), [2*n 2*n]);
options = PRset('phantomImage', image);
[~,~,x_big,ProbInfo] = PRtomo(2*n,options);
ProbInfo.problemType = 'deblurring';
ProbInfo.xType = 'image2D';
ProbInfo.xSize = [n n];
ProbInfo.bType = 'image2D';
ProbInfo.bSize = [n n];
% x from the PPtomo is a stack (2n)^2x1 column vector -> need to reshape to 
% a 2nx2n matrix
x_big = reshape(x_big,2*n,2*n);
%
% We'll assume that images are filled to the boundary. So we will extract 
% a smaller image with half the size
%
%x = x_big(101:100+n, 125:124+n);
x = x_big(n/4:n/4-1+n, n/4:n/4-1+n); 
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
b = b_big(101:100+n, 125:124+n);
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
    if weight == "RBF"
        d = InterpRBFWeights_new(n, nregions);
    elseif weight == "Constant"
        d = InterpConstantWeights(n, nregions);
    else
        d = InterpLinearWeights(n, nregions);
    end
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
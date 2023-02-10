function [w, y_new] = RBF_mini(f, x, x_full, mu, gamma)
%
% The function set up the Radial Basis Function in Gaussian form to solve
% for the weight (w), which is then used to calculate the predicted output
% given a certain input mu, which is sampled from the full input x's
% 
% Input:  - f      : true function we want to approximate
%         - x      : full input 
%         - x_full : new full input (used after w is found)
%         - mu     : input sampled from x
%         - gamma  : constant parameter of RBF, the smaller the gamma, the
%                    wider the graph
%
% Output: - w      : weight of RBF
%         - y_new  : approximated function, generated from the RBF function
%

n = length(x);
y = f(x);
y = y';
k = length(mu);
m = length(x_full);

% Construct matrix R
R = zeros(n,k);
for i = 1:n
    for j = 1:k
        R(i,j) = exp(-gamma*norm(x(i)-mu(j),2)^2);
    end
end

% Find w
w = R\y;

% Construct new matrix R
R_new = zeros(n,k);
for i = 1:m
    for j = 1:k
        R_new(i,j) = exp(-gamma*norm(x_full(i)-mu(j),2)^2);
    end
end

y_new = R_new*w;
end
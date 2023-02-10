%
% Test for RBF_mini.m
%

% Initialize parameters
f = @(x) x.*sin(x) + 4;
x = linspace(0,9,10);
mu= x(2:1:9);
x_full = linspace(0,9,100);
gamma  = 0.3; % try with new gamma's

[w, y_new] = RBF_mini(f, x, x_full, mu, gamma);

% plot
figure(1), clf
plot(x_full, f(x_full), 'LineWidth', 2), hold on
plot(x_full, y_new, 'LineWidth', 2)
legend('Real func', 'Solved by RBF')


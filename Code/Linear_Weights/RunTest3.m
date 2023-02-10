%
% Here we do a simple 1-dimensional "image" (i.e., a signal) example.
%
% We illustrate what we want to do with interpolation using
% linear interpolation.
%
% Most of the work to setup up the test problem is done in
% TestSetup3.m
%
% Pick a number of regions to partition the "image". 
% Here I am using 4.
% You might want to try changing this to see what happens.
% 
nregions = 4;
[A_true, A_int, b_true, x_true, C, d] = TestSetup3(nregions);
%
% First look at the "true" solution (signal/image) and the noise free
% right hand side vector:
%
FS = 18; LW = 2; xaxis = [1,64,-1,15];
figure(1), clf, axes('FontSize',FS), hold on
plot(x_true,'LineWidth', LW), axis(xaxis)
title('True solution')
figure(2), clf, axes('FontSize',FS), hold on
plot(b_true,'LineWidth', LW), axis(xaxis)
title('Noise free right hand side')

%
% Now let's visualize how we interoplate the regions. 
% The interplation weights are in d. 
%    d(:,k) are weights for region k
%    In case of piecewise constant these should be one in the region,
%    zero outside the reigion.
%
figure(3), clf
for k = 1:nregions
    subplot(nregions,1,k)
    plot(d(:,k), 'LineWidth', LW)
end
title('Interplation weights')
%
% Now we can try to solve using backslash.
%   * If we use the true A (A_true) and noise free b (b_true)
%     we can get a good solution.
figure(4), clf, axes('FontSize',FS), hold on
plot(A_true\b_true,'LineWidth', LW), axis(xaxis)
title('Backslash solution, true A, noise free b')

%   * However, if we use the interpolated form of A (A_int), then we
%     get a poor solution (the problem is very ill-conditioned)
figure(5), clf, axes('FontSize',FS), hold on
plot(A_int\b_true,'LineWidth', LW), axis(xaxis)
title('Backslash solution, constant approx of A, noise free b')

%   * We also get a poor solution if we use the true A and a noisy
%     version of b.
b = PRnoise(b_true);
figure(6), clf, axes('FontSize',FS), hold on
plot(A_true\b,'LineWidth', LW), axis(xaxis)
title('Backslash solution, true A, noisy b')

%   * We can try one of my iterative solvers, such as IRhybrid_lsqr,
%     and this should give a much better approximation in most cases.

% First try A_true and noisy b:
[x1, ~] = IRhybrid_lsqr(A_true, b);
figure(7), clf, axes('FontSize',FS), hold on
plot(x1,'LineWidth', LW), axis(xaxis)
title('Hybrid LSQR sol, true A, noisy b')

% Now try A_int and noisy b:
[x2, ~] = IRhybrid_lsqr(A_int, b);
figure(8), clf, axes('FontSize',FS), hold on
plot(x2,'LineWidth', LW), axis(xaxis)
title('Hybrid LSQR sol, constant approx of A, noisy b')
%
% Here we do a simple 2-dimensional image example.
%
% We illustrate what we want to do with interpolation using
% RBF interpolation.
%
% Most of the work to setup up the test problem is done in
% TestSetup2D.m
%
% Pick a number of regions to partition the "image". 
% Here I am using 4.
% You might want to try changing this to see what happens.
% 
%%%%%%%%%%%%%%%%%%%%%%%% try diff nregions, n, set seed for the noise
%%%%%%%%%%%%%%%%%%%%%%%% perturbation for b, and compare the performance
%%%%%%%%%%%%%%%%%%%%%%%% with other type of weights interp (linear, const)
nregions = 4;

%%%% error norm increases as nregions increase

[A_true, A_int_RBF, b_true, x_true, ~, ~, d_RBF, ProbInfo] = TestSetup2D_ref1(nregions, "RBF");
[~, A_int_Const, ~, ~, ~, ~, d_Const, ~] = TestSetup2D_ref1(nregions, "Constant");
[~, A_int_Linear, ~, ~, ~, ~,d_Linear, ~] = TestSetup2D_ref1(nregions, "Linear");

%
% First look at the "true" solution (image) and the noise free
% right hand side vector:
%
FS = 18; LW = 2; xaxis = [1,size(x_true,1),-1,15];
figure(1), clf, axes('FontSize',FS), hold on
PRshowx(x_true,ProbInfo)
title('True solution')
figure(2), clf, axes('FontSize',FS), hold on
PRshowx(b_true,ProbInfo)
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
    plot(d_Const(:,k), 'LineWidth', LW)
end
title('Interplation weights (Constant)')

figure(4), clf
for k = 1:nregions
    subplot(nregions,1,k)
    plot(d_Linear(:,k), 'LineWidth', LW)
end
title('Interplation weights (Linear)')

figure(5), clf
for k = 1:nregions
    subplot(nregions,1,k)
    plot(d_RBF(:,k), 'LineWidth', LW)
end
title('Interplation weights (RBF)')
%
% Now we can try to solve using backslash.
%   * If we use the true A (A_true) and noise free b (b_true)
%     we can get a good solution.
b_true = reshape(b_true,[],1);
figure(6), clf, axes('FontSize',FS), hold on
PRshowx(A_true\b_true,ProbInfo)
title('Backslash solution, true A, noise free b')

%   * However, if we use the interpolated form of A (A_int), then we
%     get a poor solution (the problem is very ill-conditioned)
figure(7), clf, axes('FontSize',FS), hold on
PRshowx(A_int_Const\b_true, ProbInfo)
title('Backslash solution, Constant approx of A, noise free b')

figure(8), clf, axes('FontSize',FS), hold on
PRshowx(A_int_Linear\b_true, ProbInfo)
title('Backslash solution, Linear approx of A, noise free b')

figure(9), clf, axes('FontSize',FS), hold on
PRshowx(A_int_RBF\b_true, ProbInfo)
title('Backslash solution, RBF approx of A, noise free b')

rng(293)
%   * We also get a poor solution if we use the true A and a noisy
%     version of b.
b = PRnoise(b_true);
figure(10), clf, axes('FontSize',FS), hold on
PRshowx(A_true\b,ProbInfo)
title('Backslash solution, true A, noisy b')

%   * We can try one of my iterative solvers, such as IRhybrid_lsqr,
%     and this should give a much better approximation in most cases.

% First try A_true and noisy b:
[x1, ~] = IRhybrid_lsqr(A_true, b);
figure(11), clf, axes('FontSize',FS), hold on
PRshowx(x1,ProbInfo)
title('Hybrid LSQR sol, true A, noisy b')

option.x_true = x_true;
% Now try A_int and noisy b:
[x2_Const, info_Const] = IRhybrid_lsqr(A_int_Const, b, option);
[x2_Linear, info_Linear] = IRhybrid_lsqr(A_int_Linear, b, option);
[x2_RBF, info_RBF] = IRhybrid_lsqr(A_int_RBF, b, option);

figure(12), clf, axes('FontSize',FS), hold on
PRshowx(x2_Const,ProbInfo)
title('Hybrid LSQR sol, Constant approx of A, noisy b')

figure(13), clf, axes('FontSize',FS), hold on
PRshowx(x2_Linear,ProbInfo)
title('Hybrid LSQR sol, Linear approx of A, noisy b')

figure(14), clf, axes('FontSize',FS), hold on
PRshowx(x2_RBF,ProbInfo)
title('Hybrid LSQR sol, RBF approx of A, noisy b')

% Compare relative residual norm per iteration
figure(15), clf, axes('FontSize',FS), hold on
plot(info_Const.Rnrm, 'LineWidth', 2), hold on
plot(info_Linear.Rnrm, 'LineWidth', 2), hold on
plot(info_RBF.Rnrm, 'LineWidth', 2), hold on
legend('Constant', 'Linear', 'RBF', 'FontSize', FS)
title('Relative residual norm')
% Constant almost equals to RBF

% Compare error norm per iteration
figure(16), clf, axes('FontSize',FS), hold on
plot(info_Const.Enrm, 'LineWidth', 2), hold on
plot(info_Linear.Enrm, 'LineWidth', 2), hold on
plot(info_RBF.Enrm, 'LineWidth', 2), hold on
legend('Constant', 'Linear', 'RBF', 'FontSize', FS)
title('Error norm when nregions = ', nregions)

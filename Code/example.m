coin_8r = matfile('coin_8nr_1dr_quad.mat');
coin_err_8r = coin_8r.vec_err_RBF;
min(coin_err_8r)

coin_32r = matfile('coin_32nr_1dr_quad.mat');
coin_err_32r = coin_32r.vec_err_RBF;
min(coin_err_32r)

coin_64r = matfile('coin_64nr_1dr.mat');
coin_err_64r = coin_64r.vec_err_RBF;
min(coin_err_64r)

cam_8r = matfile('cam_8nr_1dr.mat');
cam_err_8r = cam_8r.vec_err_RBF;
min(cam_err_8r)

cam_32r = matfile('cam_32nr_1dr_quad.mat');
cam_err_32r = cam_32r.vec_err_RBF;
min(cam_err_32r)

cam_64r_1dr = matfile('cam_64nr_1dr.mat');
cam_err_64r_1dr = cam_64r_1dr.vec_err_RBF;
min(cam_err_64r_1dr)

cam_64r_3dr = matfile('cam_64nr_3dr.mat');
cam_err_64r_3dr = cam_64r_3dr.vec_err_RBF;
min(cam_err_64r_3dr)

cam_64r_5dr = matfile('cam_64nr_5dr.mat');
cam_err_64r_5dr = cam_64r_5dr.vec_err_RBF;
min(cam_err_64r_5dr)

figure(100), clf, axes('FontSize', 18), hold on
plot(cam_64r_5dr.vec_err,'LineWidth',2), hold on
plot(cam_err_32r,'LineWidth',2), hold on
plot(cam_err_64r_1dr,'LineWidth',2), hold on
plot(cam_err_64r_3dr,'LineWidth',2), hold on
plot(cam_err_64r_5dr,'LineWidth',2), hold on
legend('True A', '32 regions, dR=1', '64 regions, dR = 1', ...
    '64 regions, dR = 3', '64 regions, dR = 5', 'FontSize', 18)
title('Error norm with different dR')

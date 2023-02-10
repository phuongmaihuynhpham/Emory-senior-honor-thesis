figure(1000), clf
x1 = 0;
x2 = 1;
y1 = 0;
y2 = 1;
x = [x1,x2,x2,x1,x1];
y = [y1,y1,y2,y2,y1];

a1 = 0;
b1 = 1/4;
a2 = 1;
b2 = 1/4;
a = [a1 a2];
b = [b1 b2];

n1 = 1/2;
n2 = 1/2;
n = [n1 n2];

m1 = 3/4;
m2 = 3/4;
m = [m1 m2];

plot(x,y,'b-','LineWidth',3), hold on
plot(a,b,'r--','LineWidth',3),hold on
plot(a,n,'r--','LineWidth',3),hold on
plot(a,m,'r--','LineWidth',3),hold on
plot(b,a,'r--','LineWidth',3),hold on
plot(n,a,'r--','LineWidth',3),hold on
plot(m,a,'r--','LineWidth',3),hold on

axis off
xlim([0,1]);
ylim([0,1]);

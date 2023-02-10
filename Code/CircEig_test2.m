n = 10:10:100;
nruns = 50;

t_f = zeros(length(n),1);
t_m = zeros(length(n),1);

for i = 1:length(n)
    C = gallery('circul',n(i));
    c = C(:,1);
    
    t1 = 0;
    for j = 1:nruns
        tic
        e_f = CircEig(c);
        t1 = t1 + toc;
    end
    t_f(i,1) = t1 / nruns;
    
    t2 = 0;
    for j = 1:nruns
        tic
        e_m = eig(C);
        t2 = t2 + toc;
    end
    t_m(i,1) = t2 / nruns;
end

figure(2), clf
plot(n, t_f, 'LineWidth', 2), hold on
plot(n, t_m, 'LineWidth', 2), hold on
legend('Using fft', 'Using eig')
hold off
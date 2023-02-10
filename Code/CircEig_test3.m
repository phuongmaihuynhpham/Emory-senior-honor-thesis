n = [512, 729, 1024, 1049, 2048, 2029, 2187, 4096, 6561, 7919, 8192, 16384, 19683, 32768]';
t = zeros(length(n),1);
nruns = 50;

for i = 1:length(n)
    C = gallery('circul',n(i));
    c = C(:,1);
    
    t_f = 0;
    for j = 1:nruns
        tic
        e_f = CircEig(c);
        t_f = t_f + toc;
    end
    t(i,1) = t_f / nruns;
end

figure(3), clf
plot(n, t, 'LineWidth', 2), hold on
plot(n, t, 'ro', 'MarkerSize', 8)
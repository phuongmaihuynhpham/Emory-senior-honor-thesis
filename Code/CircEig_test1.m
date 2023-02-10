n = 10:10:100;
diff = zeros(length(n),1);

for i = 1:length(n)
    C = gallery('circul',n(i));
    c = C(:,1);

    e_f = CircEig(c);
    e_m = eig(C);

    e_f = sort(e_f,'ComparisonMethod','real');
    e_m = sort(e_m,'ComparisonMethod','real');

    diff(i) = norm(e_f-e_m)/norm(e_m);
end

figure(1), clf
plot(n, diff, 'LineWidth', 2)
xlabel('Size of matrix C', 'FontSize', 15)
ylabel('Difference in eig', 'FontSize', 15)
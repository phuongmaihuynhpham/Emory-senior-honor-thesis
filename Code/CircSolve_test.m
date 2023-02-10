C = gallery('circul',5);
z = rand(5,1);
r = C*z;

e = CircEig(C(:,1));

z_new = CircSolve(e, r);

error = norm(z_new - z)/norm(z);
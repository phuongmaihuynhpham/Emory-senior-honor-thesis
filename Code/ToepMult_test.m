T = toeplitz(rand(3,1));
r = rand(3,1);
z = T*r;

e = ToepMultSetup(T(:,1));
z_new = ToepMult(e, r);

error = norm(z_new - z)/norm(z);


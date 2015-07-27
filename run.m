function run(filename, name,r,sigma,alpha,beta,step)
	% for a=0.1:0.1:1
	% 	for b=0.1:0.1:0.5
	% 		fprintf('running nvpp(%s, %s, %d, %d, %g, %g, %d)\n', filename,name,r,sigma,a,b,step);
	% 		nvpp(filename, name, r, sigma, a, b, step)
	% 		fprintf('finish\n');
	% 	end
	% end
	for s=0.1:0.3:3.1
		fprintf('running nvpp(%s, %s, %d, %g, %g, %g, %d)\n', filename,name,r,s,alpha,beta,step);
		nvpp(filename, name, r, s, alpha, beta, step)
		fprintf('finish\n');
	end
end
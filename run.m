function run(filename,name,r,sigma,alpha,beta,edge)
	a=0.1;
	b=0.04;
	for e=1:2:25
		fprintf('running nvpp(%s, %s, %d, %d, %g, %g, %g)\n', filename,name,r,sigma,a,b,e);
		nvpp(filename, name, r, sigma, a, b, e)
		fprintf('finish\n');
	end
	% for s=0.1:0.3:3.1
	% 	fprintf('running nvpp(%s, %s, %d, %g, %g, %g, %d)\n', filename,name,r,s,alpha,beta,edge);
	% 	nvpp(filename, name, r, s, alpha, beta,edge)
	% 	fprintf('finish\n');
	% end
end
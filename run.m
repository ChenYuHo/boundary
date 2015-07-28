function run(filename,name,r,sigma,alpha,beta,edge)
	for a=0.1:0.1:0.1
		for b=0.005:0.015:a
			for e=25:25:75
				fprintf('running nvpp(%s, %s, %d, %d, %g, %g, %g)\n', filename,name,r,sigma,a,b,e);
				nvpp(filename, name, r, sigma, a, b, e)
				fprintf('finish\n');
			end
		end
	end
	% for s=0.1:0.3:3.1
	% 	fprintf('running nvpp(%s, %s, %d, %g, %g, %g, %d)\n', filename,name,r,s,alpha,beta,edge);
	% 	nvpp(filename, name, r, s, alpha, beta,edge)
	% 	fprintf('finish\n');
	% end
end
function [gx,gy]=gwmask(r,sigma)
	% this program produces directional difference mask
	% INPUT
	%   r: processing radius
	%   sigma: spread constant of gaussian weighted image moment vector
	% OUTPUT
	%	gx, gy: directional difference mask
	gx=zeros(2*r+1,2*r+1);
	gy=zeros(2*r+1,2*r+1);
	for row=1:2*r+1
	    for col=1:2*r+1
	        x=col-r-1;
	        y=r+1-row;
	        if x~=0||y~=0
	        co=(1/((sqrt(2*pi))*sigma*sigma))*(exp(-(x^2+y^2)/2/sigma/sigma))/(sqrt(x^2+y^2));
	        gx(row,col)=co*x;
	        gy(row,col)=co*y;
	        end
	    end
	end
end
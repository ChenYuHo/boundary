function [nvp, k]=nlg(r,gx,gy,gwimv)
	[m,n,~]=size(gwimv);
	nvp=zeros(m,n,2);
	% nvp(:,:,1)=gwimv(:,:,2);
	% nvp(:,:,2)=-gwimv(:,:,1);
	k=0;
	nvxo=conv2(gx, gwimv(:,:,2));							%Laplacian-gradient vector field	Gx * (Gx * I(i,j)) + Gy * (Gy * I(i,j))
	nvyo=conv2(gy, gwimv(:,:,1));
	[m1,n1]=size(nvxo);
	nvx_and_nvy_o=nvxo+nvyo;
	% gra=zeros(m,nvp);
	for row=r+1:m-r											%correct convolution matrix
		for col=r+1:n-r
			laplace = nvx_and_nvy_o(row+(m1-m)/2, col+(n1-n)/2);
			nvp(row,col,1)=laplace*-gwimv(row,col,2);
			nvp(row,col,2)=laplace*gwimv(row,col,1);
			% nvy(row,col)=nvyo(row+(m1-m)/2,col+(n1-n)/2);
			% gra(row,col)=nvx(row,col)^2+nvy(row,col)^2;
			temp=nvp(row,col,1)^2+nvp(row,col,2)^2;
			% if gra(row,col)>k
			% 	k=gra(row,col);
			if temp>k
				k=temp;
			end
		end
	end														%correct convolution matrix
	k=sqrt(k);												%normalization factor
	nvp=nvp./k;
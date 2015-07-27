function sig(filename,r,sigma)
	img=imread(filename);
	array=double(img);
	[~,~,gwimv,k]=gwimv_conv2(array,r,sigma);
	% [x,y,z]=size(gwimv);
	% e=zeros(x,y,2);
	% k=max(max(max(e)));
	% e(:,:,1)=gwimv(:,:,1);
	% e(:,:,2)=gwimv(:,:,2);


	% [m,n]=size(array);
	% [gx,gy]=gwmask(r,sigma);
	eabs=sqrt((gwimv(:,:,1)).^2+(gwimv(:,:,2)).^2)
	% x=uint8(round(eabs*255));
	% imshow(x);
	imshow(eabs, [min(eabs(:)),max(eabs(:))]);
	% hold on
	% quiver(gwimv(:,:,2), gwimv(:,:,1));
end
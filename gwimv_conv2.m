function [gx, gy, gwimv, k] = gwimv_conv2(array,r,sigma)
    % this program produces gaussian weighted image moment vector
    % and its normalization factor
    % INPUT
    %   array: grayscale image array
    %   r: processing radius
    %   sigma: spread constant of gaussian weighted image moment vector
    % OUTPUT
    %   gwimv: gaussian weighted image moment vector
    %   k: normalization factor
    [m,n]=size(array);
    gwimv=zeros(m,n,2);
    [gx,gy]=gwmask(r,sigma);        %directional difference mask
    imvxo=conv2(gy,array);         %Mx(i,j) = -Gy * I(x,y)
    imvyo=conv2(gx,array);          %My(i,j) =  Gx * I(x,y)
    [m1,n1]=size(imvxo);
    imvx=zeros(m,n);
    imvy=zeros(m,n);
    k=0;
    for row=r+1:m-r                 %delete redundant rows and columns
        for col=r+1:n-r
            imvx(row,col)=imvxo(row+(m1-m)/2,col+(m1-m)/2);
            imvy(row,col)=imvyo(row+(m1-m)/2,col+(m1-m)/2);
            ka=imvx(row,col)^2+imvy(row,col)^2;
            if ka>k                     %find biggest element for normalization
                k=ka;
            end
        end
    end
    k=sqrt(k);                      %normalization factor
    gwimv(:,:,1)=imvx;              %convert coordinate
    gwimv(:,:,2)=imvy;
end
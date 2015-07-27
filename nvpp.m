function nvpp(filename,name,r,sigma,alpha,beta)
	% this program uses simulation of particle motion in vector image field to
	% portrait the boundary of objects in input image
	% INPUT
	%	filename: path of image to be processed
	%	name: 
	%	r: processing radius
	%	sigma: spread constant of gaussian weighted image moment vector
	%	alpha: tangential stepping factor (-1 <= alpha <= 1, alpha != 0)
	%	beta: normal stepping factor (0 < beta <= 1)
tic;	%record process time
	img=imread(filename);
	array=double(img);
	[m,n]=size(array);
	[gx, gy, gwimv, k]=gwimv_conv2(array,r,sigma);			%gaussian weighted image moment vector and its normalization factor
	[nvp,~]=nlg(r,gx,gy,gwimv);
	gwimv(:,:,2)=gwimv(:,:,2)./k;							%Normalized vector image field
	gwimv(:,:,1)=gwimv(:,:,1)./k;
	eabs=sqrt(gwimv(:,:,2).^2+gwimv(:,:,1).^2);
	combine = zeros(m,n,2);
	combine(:,:,1) = (gwimv(:,:,1).*alpha) + (nvp(:,:,1).*beta);
	combine(:,:,2) = (gwimv(:,:,2).*alpha) + (nvp(:,:,2).*beta);
	[~,pos]=sort(eabs(:), 'descend');						%sort edge strength as initial points
	record=false(m,n);
	pos_size=size(pos);
	imshow(img);	 
	hold on
	reason='normal';
	A=[1;1];
	es=0.1;
	esr=1;
	[~,X]=hist(eabs, 3);
	limit=X(1);
	for count=1:1:pos_size							%pick starting point
        col=ceil(pos(count)/m);								%convert to x,y coordinate
	    row=mod(pos(count),m);
	    if row==0
	    	row=m;
	    end
	    if eabs(row,col)<limit
	    	continue
	    end
	    if record(row,col)
	    	continue
	    end	%assure being localmax
	    record(row,col)=true;								%mark as visited
	    A(1)=row;
	    A(2)=col;
	    % fprintf('pick (%d, %d)\n', A(1), A(2));
	    try
	    	while(true)
		    	move = direction(combine(:,:,1), combine(:,:,2), A);
		    	B=A+move;
	            if eabs(B(1), B(2)) < limit
	            	break
	            end
	            line([A(2), B(2)],[A(1),B(1)],'Color','g','LineWidth',1);
	            if record(B(1), B(2))
	            	% disp('break')
	            	break
	            else
	            	record(B(1), B(2)) = true;
	            end
	            A=B;
	        end	%step for
        catch err
	        if (strcmp(err.identifier,'MATLAB:badsubscript'))
	    	%Do Nothing
	    	else            
	    		rethrow(err);	% rethrow any other errors
	    	end
    	end
    end	%pick starting point for
    hold off
e=toc;
	fprintf('done processing, %g seconds used\n', e);
 	fileType = 'tif';
	imageFolder = 'O:\desktop\Boundary\result\';
    filenameIntactHist = [imageFolder name '_' num2str(sigma) '_' num2str(alpha) '_' num2str(beta) '_' num2str(e) '.' fileType];
    % Save the current figure.
	saveas(gcf, filenameIntactHist, fileType);
	% Close the figure.
	close(gcf);
end	%function

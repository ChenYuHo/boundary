function nvpp(filename,name,r,sigma,alpha,beta,edge)
	% this program uses simulation of particle motion in vector image field to
	% portrait the boundary of objects in input image
	% INPUT
	%	filename: path of image to be processed
	%	name: 
	%	r: processing radius
	%	sigma: spread constant of gaussian weighted image moment vector
	%	alpha: tangential stepping factor (-1 <= alpha <= 1, alpha != 0)
	%	beta: normal stepping factor (0 < beta <= 1)
	%	edge: the dropping percent (0 < edge < 100), will drop the point if the intensity of which is smaller than specified percent
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
	localmax= eabs > imdilate(eabs, [1 1 1; 1 0 1; 1 1 1]);
	[~,pos]=sort(eabs(:), 'descend');						%sort edge strength for choosing initial points
	record=false(m,n);
	% figure('Visible','off');
	% figure('Visible', 'on');
	imshow(img);	 
	hold on
	A=[1;1];
	[~,X]=hist(eabs, 1000);
	limit=X(edge*10);
	for count=1:1:size(pos)									%pick starting point
        col=ceil(pos(count)/m);								%convert to x,y coordinate
	    row=mod(pos(count),m);
	    if row==0
	    	row=m;
	    end
	    if eabs(row,col)<limit
	    	break
	    end
	    if record(row,col)
	    	continue
	    end	%assure being localmax
	    % if ~localmax(row,col)
	    % 	continue
	    % end
	    % if ~isLocalKing(eabs, row, col, 1, 0.1)
	    % 	continue
	    % end
	    record(row,col)=true;								%mark as visited
	    A(1)=row;
	    A(2)=col;
	    % fprintf('pick (%d, %d)\n', A(1), A(2));
	    % plot(A(2),A(1),'sg');
	    try
	    	while(true)
		    	move = direction(combine(:,:,1), combine(:,:,2), A);
		    	B=A+move;
	            if eabs(B(1), B(2)) < limit
	            	found=false;
	            	for index=1:1:jumpCount
						[nextPoint, found]=checkLimit(eabs, B, move, limit);
						if found
							break
						end
					end
	            	% [point, next] = findNext(eabs, B, move, limit, count); 
	            	if found
	            		record(nextPoint(1), nextPoint(2)) = true;
	            		A=nextPoint;
	            		continue
	            	else
	            		break
	            	end
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
	imageFolder = 'O:\desktop\Boundary\result\0728\';
    filenameIntactHist = [imageFolder name '_' num2str(sigma) '_' num2str(alpha) '_' num2str(beta) '_' num2str(edge) '_' num2str(e) '.' fileType];
	% saveas(gcf, filenameIntactHist, fileType);	    % Save the current figure.
	% close(gcf);		% Close the figure.
end	%function



	% % [grax,gray]=gradient(array);
	% % nvpx= grax.*(nvx+nvy)./c;								%Normalized Laplacian-gradient vector field
	% % nvpy= gray.*(nvx+nvy)./c;

	% % eabs=sqrt((gwimv(:,:,1)).^2+(gwimv(:,:,2)).^2);			%edge strength
	
	% % localmax= gra > imdilate(gra, [1 1 1; 1 0 1; 1 1 1]);   %specify if (x,y) is local maximum
	% % localmax= eabs > imdilate(eabs, [1 1 1; 1 0 1; 1 1 1]);
	% % numoflocalmax = sum(localmax(:));						%amount of local maximum
	% % display(numoflocalmax);
	% % localmaxcount=0;
	% % [~,pos]=sort(gra(:), 'descend');						%sort gradient
	% [~,pos]=sort(eabs(:), 'descend');						%sort edge strength as initial points
	% record=false(m,n);
	% pos_size=size(pos);
	% imshow(eabs);
	% hold on
	% % quiver(nvp(:,:,1),nvp(:,:,2));
	% % quiver(gwimv(:,:,1), gwimv(:,:,2));
	% quiver(combine(:,:,1), combine(:,:,2));
	% % imshow(eabs, [min(eabs(:)),max(eabs(:))]);
	% reason='normal';
	% A=[1;1];
	% es=0.1;
	% esr=1;
	% [~,X]=hist(eabs, 2);
	% limit=X(1);
	% pickcount = 0;
	% % for count=1:1:pos_size*0.01								%pick starting point
	% for count=1:1:0
	% 	% if localmaxcount==numoflocalmax
 %  %   		reason='end';
	%  %    	break
	%  %    end
	%  	% if pickcount == 20
	%  	% 	break
	%  	% end
 %        col=ceil(pos(count)/m);								%convert to x,y coordinate
	%     row=mod(pos(count),m);
	%     if row==0
	%     	row=m;
	%     end
	%     if eabs(row,col)<limit
	%     	continue
	%     end
	%     % if ~localmax(row,col)
	%     % 	continue
	%     % else
	%     % 	localmaxcount=localmaxcount+1;
	%     % end
	%     if ~isLocalKing(eabs, row, col, esr, es)
	%  %    % if ~isLocalKing(gra, row, col, esr, es)
	% 		% continue
	% 	% else
	% 	% 	plot(col,row,'dg');
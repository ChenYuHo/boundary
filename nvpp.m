function nvpp(filename,name,r,sigma,alpha,beta,step)
	% this program uses simulation of particle motion in vector image field to
	% portrait the boundary of objects in input image
	% INPUT
	%	filename: path of image to be processed
	%	name: 
	%	r: processing radius
	%	sigma: spread constant of gaussian weighted image moment vector
	%	alpha: tangential stepping factor (-1 <= alpha <= 1, alpha != 0)
	%	beta: normal stepping factor (0 < beta <= 1)
	%	step: step times
% tic;	%record process time
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
	combined = combine(:,:,1).^2 + combine(:,:,2).^2;
	% [grax,gray]=gradient(array);
	% nvpx= grax.*(nvx+nvy)./c;								%Normalized Laplacian-gradient vector field
	% nvpy= gray.*(nvx+nvy)./c;

	% eabs=sqrt((gwimv(:,:,1)).^2+(gwimv(:,:,2)).^2);			%edge strength
	
	% localmax= gra > imdilate(gra, [1 1 1; 1 0 1; 1 1 1]);   %specify if (x,y) is local maximum
	% localmax= eabs > imdilate(eabs, [1 1 1; 1 0 1; 1 1 1]);
	% numoflocalmax = sum(localmax(:));						%amount of local maximum
	% display(numoflocalmax);
	% localmaxcount=0;
	% [~,pos]=sort(gra(:), 'descend');						%sort gradient
	[~,pos]=sort(eabs(:), 'descend');						%sort edge strength as initial points
	record=false(m,n);
	pos_size=size(pos);
	imshow(img);	 
	% imshow(eabs);
	hold on
	% quiver(nvp(:,:,1),nvp(:,:,2));
	% quiver(gwimv(:,:,1), gwimv(:,:,2));
	% quiver(combine(:,:,1), combine(:,:,2));
	% imshow(eabs, [min(eabs(:)),max(eabs(:))]);
	reason='normal';
	A=[1;1];
	es=0.1;
	esr=1;
	[~,X]=hist(eabs, 3);
	[~,Y]=hist(combined, 2);
	limit=X(1);
	climit=Y(1);
	% pickcount = 0;
	for count=1:1:pos_size							%pick starting point
	% for count=1:1:1
		% if localmaxcount==numoflocalmax
  %   		reason='end';
	 %    	break
	 %    end
	 	% if pickcount == 20
	 	% 	break
	 	% end
        col=ceil(pos(count)/m);								%convert to x,y coordinate
	    row=mod(pos(count),m);
	    if row==0
	    	row=m;
	    end
	    if eabs(row,col)<limit
	    	continue
	    end
	    % if ~localmax(row,col)
	    % 	continue
	    % else
	    % 	localmaxcount=localmaxcount+1;
	    % end
	    % if ~isLocalKing(eabs, row, col, esr, es)
	 %    % if ~isLocalKing(gra, row, col, esr, es)
			% continue
		% else
		% 	plot(col,row,'dg');
		% end

	    if record(row,col)
	    	continue
	    end	%assure being localmax
	    record(row,col)=true;								%mark as visited
	    A(1)=row;
	    A(2)=col;
	    % A_2 = A;
	    fprintf('pick (%d, %d)\n', A(1), A(2));
	    % repeated=0;
	    % pickcount = pickcount + 1;
	    try
		    % for t=1:1:10	%start loop
		    while(true)
		    	% plot(round(A(2)),round(A(1)),'dg');
		    	move = direction(combine(:,:,1), combine(:,:,2), A);
		    	% B_2 = A_2 + move;
		    	% ealpha=Ftest(gwimv(:,:,1),gwimv(:,:,2),A);
	            % ebeta=Ftest(nvp(:,:,1),nvp(:,:,2),A);
	            % B=A+alpha*ealpha+beta*ebeta;
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
	            % line([A_2(2), B_2(2)],[A_2(1),B_2(1)],'Color','r','LineWidth',1);
	            % tmp=round(B);
	            % if round(A(2))~=tmp(2) || round(A(1))~=tmp(1)	%goes to different point
					% % line([round(A(2)), tmp(2)],[round(A(1)),tmp(1)],'Color','r','LineWidth',1);
	            	% if record(tmp(1),tmp(2))
	            		% break;
	            	% else
	            		% record(tmp(1),tmp(2))=true;
	            	% end
	            % else
            		% repeated=repeated+1;
	                % if repeated > 1000
	                	% display('point blocked');
	                    % break
	                % end	%block if
	            % end	%point if
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
% e=toc;
	display(reason);
 	% fileType = 'tif';
	% imageFolder = 'E:\Dropbox\NTUspace\ntucourse\Project\BoundaryDetection\result\';
    % filenameIntactHist = [imageFolder name '_' num2str(sigma) '_' num2str(alpha) '_' num2str(beta) '_' num2str(e) '_' reason '.' fileType];
    % Save the current figure.
	% saveas(gcf, filenameIntactHist, fileType);
	% Close the figure.
	% close(gcf);
end	%function

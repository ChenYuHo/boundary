function eabs=pickPoints(filename,r,sigma,es,drop)
	img=imread(filename);
	array=double(img);
	[m,n]=size(array);
	[gx, gy, gwimv, k]=gwimv_conv2(array,r,sigma);			%gaussian weighted image moment vector and its normalization factor
	gwimv(:,:,2)=gwimv(:,:,2)./k;							%Normalized vector image field
	gwimv(:,:,1)=gwimv(:,:,1)./k;
	eabs=sqrt(gwimv(:,:,2).^2+gwimv(:,:,1).^2);

	% localmax= gra > imdilate(gra, [1 1 1; 1 0 1; 1 1 1]);   %specify if (x,y) is local maximum
	% localmax= eabs > imdilate(eabs, [1 1 1; 1 0 1; 1 1 1]);
	% numoflocalmax = sum(localmax(:));						%amount of local maximum
	% display(numoflocalmax);
	% localmaxcount=0;
	% [~,pos]=sort(gra(:), 'descend');						%sort gradient
	[~,pos]=sort(eabs(:), 'descend');						%sort edge strength as initial points
	% record=false(m,n);
	pos_size=size(pos);
	% record=false(m,n);	
	% imshow(img);
	% imshow(eabs, [min(eabs(:)),max(eabs(:))]);
	imshow(eabs);
	hold on
	% reason='normal';
	% A=[1;1];
	% es=0.3;
	esr=1;
	[~,X]=hist(eabs, 100/drop)
	limit=X(1)
	pickcount = 0;
	for count=1:1:pos_size									%pick starting point

		% if localmaxcount==numoflocalmax
  %   		% reason='end';
	 %    	break
	 %    end
	 	if pickcount==10
	 		break
	 	end
        col=ceil(pos(count)/m);								%convert to x,y coordinate
	    row=mod(pos(count),m);

	    if row==0
	    	row=m;
	    end
	    if eabs(row,col)<limit
	    	% fprintf('array(%g, %g)=%g < %g\n', row, col, array(row,col), limit);
	    	continue
	    end

	    % if ~localmax(row,col)
	    % 	continue
	    % else
	    % 	% fprintf('eabs(%g, %g)=%g is local maximum\n', row, col, eabs(row,col));
	    % 	localmaxcount=localmaxcount+1;
	    % end

	    if ~isLocalKing(eabs, row, col, esr, es)
	 %    	% fprintf('eabs(%g, %g)=%g is local king\n', row, col, eabs(row,col));
	 %    % if ~isLocalKing(gra, row, col, esr, es)
			continue
		end
		plot(col,row,'dg');
		pickcount=pickcount+1;
    end	%pick starting point for
    hold off
% e=toc;
	% display(reason);
end	%function

function result = isLocalKing(array,row,col,r,es)
	result=false;
	for dx =-r:1:r
		for dy =-r:1:r
			if (dx==0 && dy==0)
				continue
			else
				try
					if ((array(row,col)-array(row+dx, col+dy))/array(row,col) <= es )
						result=false;
						return
					end
				catch err
					if (strcmp(err.identifier,'MATLAB:badsubscript'))
					else
						rethrow(err);	% rethrow any other errors
					end
				end
			end
		end
	end
	result=true;
end
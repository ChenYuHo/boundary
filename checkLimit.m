function [next, found]=checkLimit(eabs, B, fxy, limit)
	found=false;
	checkFirst = B+fxy;
	next=B;
	if(eabs(checkFirst(1), checkFirst(2)) < limit)
		for x = -1:1:1
			for y = -1:1:1
				check = B+[x;y];
				if (eabs(check(1), check(2)) < limit)
				else
					next=check;
					found=true;
					return
				end
			end
		end
	else
		next=checkFirst;
		found=true;
	end
end
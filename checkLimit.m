function [next, found]=checkLimit(eabs, B, move, limit)
	found=false;
	checkFirst = B+move;
	while (round(checkFirst(1))==B(1) && round(checkFirst(2))==(B(2)))
		checkFirst = checkFirst+move;
	end
	checkFirst = round(checkFirst);
	next = checkFirst;
	if(eabs(checkFirst(1), checkFirst(2)) < limit)
		% for x = -1:1:1
		% 	for y = -1:1:1
		% 		check = B+[x;y];
		% 		if (eabs(check(1), check(2)) < limit)
		% 		else
		% 			next=check;
		% 			found=true;
		% 			return
		% 		end
		% 	end
		% end
	else
		next=checkFirst;
		found=true;
	end
end
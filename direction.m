function fxy=direction(dirx,diry,A)
% 	disp(dirx(A(1), A(2)))
% 	disp(diry(A(1), A(2)))
% 	disp(atan(dirx(A(1), A(2))/diry(A(1), A(2)))*180/pi)
	x=dirx(A(1), A(2));
	y=diry(A(1), A(2));
	if x==0 && y ==0
		fxy=[0;0];
	elseif x>0 && y>0
		arc = 90-atan(x/y)*180/pi;
		if arc<22.5
			fxy=[1;0]
		elseif arc>=22.5 && arc<=67.5
			fxy=[1;1]
		else
			fxy=[0;1]
		end
	elseif x>0 && y<0
		arc = 90+atan(x/y)*180/pi;
		if arc<22.5
			fxy=[1;0]
		elseif arc>=22.5 && arc<=67.5
			fxy=[1;-1]
		else
			fxy=[0;-1]
		end
	elseif x<0 && y>0
		arc = 90+atan(x/y)*180/pi;
		if arc<22.5
			fxy=[-1;0]
		elseif arc>=22.5 && arc<=67.5
			fxy=[-1;1]
		else
			fxy=[0;1]
		end
	else
		arc = 90-atan(x/y)*180/pi;
		if arc<22.5
			fxy=[-1;0]
		elseif arc>=22.5 && arc<=67.5
			fxy=[-1;-1]
		else
			fxy=[0;-1]
		end
	end
end
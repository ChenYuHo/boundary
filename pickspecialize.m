function fxy=pickspecialize(e1,e2,A)
    x=ceil(A(1));
    y=ceil(A(2));
    e(:,:,1)=e2;
    e(:,:,2)=e1;
    f=e(x,y,:)*(x+1-A(1))*(y+1-A(2)) + e(x,y+1,:)*(x+1-A(1))*(A(2)-y) + e(x+1,y,:)*(A(1)-x)*(y+1-A(2)) + e(x+1,y+1,:)*(A(1)-x)*(A(2)-y);
    fxy=[0;0];
    fxy(1)=f(1,1,1);
    fxy(2)=f(1,1,2);
end
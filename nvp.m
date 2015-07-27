function nvp(filename,r,sigma,alpha,beta,step,loop)

switch nargin
    case 1
        r=1;
        sigma=0.5;
        alpha=0.1;
        beta=0.005;
        step=3000;
        loop=0;
    case 2
        sigma=0.5;
        alpha=0.1;
        beta=0.005;
        step=3000;
        loop=0;
    case 3
        alpha=0.1;
        beta=0.005;
        step=3000;
        loop=0;
    case 4
        beta=0.005;
        step=3000;
        loop=0;
    case 5
        step=3000;
        loop=0;
    case 6
        loop=0;
end
torecord=10;
img=imread(filename);
array=double(img);
A=[1;1];
[gwimv,A, gx, gy, k]=gwimv_conv2(array,r,sigma);
[x,y,z]=size(gwimv);
e=zeros(x,y,2);
% k=max(max(max(e)));
e(:,:,1)=gwimv(:,:,1)/k;
e(:,:,2)=gwimv(:,:,2)/k;
% e(:,:,1)=gwimv(:,:,1);
% e(:,:,2)=gwimv(:,:,2);


[m,n]=size(array);
eabs=sqrt(e(:,:,1).^2+e(:,:,2).^2);

x=uint8(round(eabs*255));
% imshow(x);
% imshow(eabs);

% ngvfxo=conv2(-gx,array);
% ngvfyo=conv2(-gy,array);
% % [ngvfxo, ngvfyo]=gradient(eabs);

% [m1,n1]=size(ngvfxo);
% ngvfx=zeros(m,n);
% ngvfy=zeros(m,n);



% for row=r+1:m-r
%     for col=r+1:n-r
%     ngvfx(row,col)=ngvfxo(row+(m1-m)/2,col+(m1-m)/2);
%     ngvfy(row,col)=ngvfyo(row+(m1-m)/2,col+(m1-m)/2);
% %     if ngvfx(row,col)^2+ngvfy(row,col)^2 > ngvfx(A(1),A(2))^2 + ngvfy(A(1),A(2))^2
% %        A(1)=row;
% %        A(2)=col;
% %     end
%     end
% end



c=0;
nvxo=conv2(-gx, gwimv(:,:,1));
nvyo=conv2(-gy, gwimv(:,:,2));
[m1,n1]=size(nvxo);
nvx=zeros(m,n);
nvy=zeros(m,n);
gra=zeros(m,n);
for row=r+1:m-r
    for col=r+1:n-r
        nvx(row,col)=nvxo(row+(m1-m)/2,col+(n1-n)/2);
        nvy(row,col)=nvyo(row+(m1-m)/2,col+(n1-n)/2);
        gra(row,col)=nvx(row,col)^2+nvy(row,col)^2;
        if gra(row,col)>c
            c=gra(row,col);
        end
    end
end
localmax= gra > imdilate(gra, [1 1 1; 1 0 1; 1 1 1]);   %specify if (x,y) is local maximum
[~,pos]=sort(gra(:), 'descend');    %sort for gradient
% [gx,gy]=gradient(array);
% l=del2(array);
nvpx=nvx.*gwimv(:,:,1)/c;
nvpy=nvy.*gwimv(:,:,2)/c;
% nvp2x=l.*gx/c;
% nvp2y=l.*gy/c;
imshow(img);
hold on
% quiver(e(:,:,2),e(:,:,1));
% quiver(ngvfx,-ngvfy);
% quiver(nvpx, -nvpy);
% quiver(gx, gy);
% quiver(nvx,-nvy);
% quiver(nvp2x, nvp2y);
% nvx
% ngvfx
% O=A;
record=false(m,n);
if loop==0
    loop=size(pos);
end
% loops=0;
obj=0;
pos_size=size(pos);
for count=1:1:pos_size
        if obj>=loop
        break
        end
    col=ceil(pos(count)/m);
    row=mod(pos(count),m);
    if row==0
        row=m;
    end
    if ~localmax(row,col)
        continue
    end
    %     loops=loops+1;
    %     if loops>loop
    %         break
    %     end
    A(1)=row;
    A(2)=col;
    R=A;
    repeated=0;
    %     plot(A(2),A(1),'sg');
    %     record(A(1),A(2))=true;
    a=1;
    %     toshow=zeros(500);
    toplot=zeros(step, 2);
    toplot(1,1)=A(1);
    toplot(1,2)=A(2);
    visited=zeros(torecord,2);
    pointrecorded=1;
    visited(pointrecorded,1)=A(1);
    visited(pointrecorded,2)=A(2);
    try
        for t=1:1:step
            % if record(ceil(A(2)),ceil(A(1)))
            %     t
            %     break
            % else
            %     record(ceil(A(2)),ceil(A(1)))=true;
            % end
            ealpha=Ftest(e(:,:,2),e(:,:,1),A);
            %   ebeta=Ftest(ngvfx,-ngvfy,A);
            ebeta=Ftest(nvpx,-nvpy,A);
            %   ebeta=Ftest(nvp2x,nvp2y,A);
            B=A+alpha*ealpha+beta*ebeta;
            
            if ceil(A(2))~=ceil(B(2)) || ceil(A(1))~=ceil(B(1))
                if pointrecorded<=torecord
                    visited(pointrecorded,1)=ceil(B(1));
                    visited(pointrecorded,2)=ceil(B(2));
                    pointrecorded=pointrecorded+1;
                else
                    for i=1:1:torecord
                        if ceil(B(1))==visited(i,1) && ceil(B(2))==visited(i,2)
                            
                            plot(ceil(B(2)),ceil(B(1)),'dg');
                            display('reached previous point');
                            t
                            obj=obj+1
                            for k=1:1:a-1
                                line([ceil(toplot(k,2)), ceil(toplot(k+1,2))],[ceil(toplot(k,1)), ceil(toplot(k+1,1))],'Color','r','LineWidth',1);
                                % record(ceil(toplot(k,1)),ceil(toplot(k,2)))=true;
                                %                                 a=a+1;
                            end
                            % record(ceil(toplot(a-1,1)),ceil(toplot(a-1,2)))=true;
                            % record(ceil(toplot(a,1)),ceil(toplot(a,2)))=true;
                            line([ceil(B(2)), ceil(toplot(k+1,2))],[ceil(B(1)), ceil(toplot(k+1,1))],'Color','r','LineWidth',1);
                            break
                            %                 else
                            %                     record(ceil(B(1)),ceil(B(2)))=true;
                        end
                    end
                end
                
                
                % if record(ceil(B(1)),ceil(B(2)))
                %     %                     plot(ceil(B(2)),ceil(B(1)),'dg');
                %     display('reached previous point');
                %     t
                %     obj=obj+1;
                %     for k=1:1:a-1
                %         line([ceil(toplot(k,2)), ceil(toplot(k+1,2))],[ceil(toplot(k,1)), ceil(toplot(k+1,1))],'Color','r','LineWidth',1);
                %         record(ceil(toplot(k,1)),ceil(toplot(k,2)))=true;
                %         a=a+1;
                %     end
                %     record(ceil(toplot(a-1,1)),ceil(toplot(a-1,2)))=true;
                %     record(ceil(toplot(a,1)),ceil(toplot(a,2)))=true;
                %     line([ceil(B(2)), ceil(toplot(k+1,2))],[ceil(B(1)), ceil(toplot(k+1,1))],'Color','r','LineWidth',1);
                %     break
                %     %                 else
                %     %                     record(ceil(B(1)),ceil(B(2)))=true;
                % end
                a=a+1;
                toplot(a,1)=B(1);
                toplot(a,2)=B(2);
                %                 h(t)=line([ceil(A(2)),ceil(B(2))],[ceil(A(1)),ceil(B(1))],'Color','r','LineWidth',1);
                %                 set(h(t),'Visible','off');
                
                
                
            else
                if ceil(B(1))==R(1) && ceil(B(2))==R(2);
                    repeated=repeated+1;
                    if repeated > 10000
                        plot(ceil(B(2)),ceil(B(1)),'*g');
                        display('point blocked');
                        t
                        if t>=1000
                            for k=1:1:a-1
                                line([ceil(toplot(k,2)), ceil(toplot(k+1,2))],[ceil(toplot(k,1)), ceil(toplot(k+1,1))],'Color','r','LineWidth',1);
                            end
                            
                        end
                        
                        %                         for k=1:1:a-1
                        %                             line([ceil(toplot(k,2)), ceil(toplot(k+1,2))],[ceil(toplot(k,1)), ceil(toplot(k+1,1))],'Color','r','LineWidth',1);
                        %                             % record(ceil(toplot(k,1)),ceil(toplot(k,2)))=true;
                        %                             a=a+1;
                        %                         end
                        %                         % record(ceil(toplot(a-1,1)),ceil(toplot(a-1,2)))=true;
                        %                         % record(ceil(toplot(a,1)),ceil(toplot(a,2)))=true;
                        %                         line([ceil(B(2)), ceil(toplot(k+1,2))],[ceil(B(1)), ceil(toplot(k+1,1))],'Color','r','LineWidth',1);
                        %                         for k=1:1:t
                        %                             if h(k)~=0
                        %                                 try
                        %                                     set(h(k),'Visible','off');
                        %                                 catch
                        %                                 end
                        %                             end
                        %                         end
                        break
                    end
                else
                    R=ceil(B);
                end
                
                
            end
            
            
            % if ceil(A(2))~=ceil(B(2)) || ceil(A(1))~=ceil(B(1)) %check record and draw only if coordinate changed
            %     line([ceil(A(2)),ceil(B(2))],[ceil(A(1)),ceil(B(1))],'Color','r','LineWidth',2);
            %     if record(ceil(A(1)),ceil(A(2)))
            %         plot(ceil(A(2)),ceil(A(1)),'dg');
            %         t
            %         break
            %     else
            %         record(ceil(A(1)),ceil(A(2)))=true;
            %     end
            % % elseif ceil(A(2))==ceil(B(2)) && ceil(A(1))==ceil(B(1)) %if samej, record repeated
            % %     repeated=repeated+1;
            % end
            % if repeated>10  %if a point blocks more than 10 times, break
            %     break
            % end
            %   B(1)=round(B(1));
            %   B(2)=round(B(2));
            % line([ceil(A(2)),ceil(B(2))],[ceil(A(1)),ceil(B(1))],'Color','r','LineWidth',2);
            % plot(B(2),B(1),'dg');
            A=B;
            if t==step
                display('reach step');
                %                 obj=obj+1;
                %             plot(ceil(B(2)),ceil(B(1)),'sg');
                t
                for k=1:1:a-1
                    line([ceil(toplot(k,2)), ceil(toplot(k+1,2))],[ceil(toplot(k,1)), ceil(toplot(k+1,1))],'Color','r','LineWidth',1);
                    % record(ceil(toplot(k,1)),ceil(toplot(k,2)))=true;
                    %                     a=a+1;
                end
                % record(ceil(toplot(a-1,1)),ceil(toplot(a-1,2)))=true;
                % record(ceil(toplot(a,1)),ceil(toplot(a,2)))=true;
                line([ceil(B(2)), ceil(toplot(k+1,2))],[ceil(B(1)), ceil(toplot(k+1,1))],'Color','r','LineWidth',1);
            end
            
            
        end
        
    catch err
        if (strcmp(err.identifier,'MATLAB:badsubscript'))
        else            % Display any other errors as usual.
            rethrow(err);
        end
    end
end
% for k=1:1:a-1
%     set(toshow(k),'Visible','on');
% end


% for t=1:1:step
%     A
%     gwimv(A(1), A(2), :)/k
%     nvpx(A(1), A(2))/c
%     nvpy(A(1), A(2))/c
%     B(2)=A(2)+alpha*gwimv(A(1),A(2),1)/k+beta*-nvpy(A(1),A(2));
%     B(1)=A(1)+alpha*gwimv(A(1),A(2),2)/k+beta*nvpx(A(1),A(2));
%     % B=A+alpha*ealpha+beta*ebeta;
%     B(1)=round(B(1));
%     B(2)=round(B(2));
%     line([A(2),B(2)],[A(1),B(1)],'Color','r','LineWidth',1);
%     A=B;
% end


% plot(B(2),B(1),'dg');
% plot(O(2),O(1),'*g');
hold off
end
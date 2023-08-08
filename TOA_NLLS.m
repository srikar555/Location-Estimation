
clc
clear
close all
c = 3e8;
N=8; % #BS
bias = 5/100; %percentage
error_thres = 1e-9;
grid_boun = 20000;
cell_rad = grid_boun/N;
X=zeros(1,N);
Y=zeros(1,N);
X(1)=0;
Y(1)=0;
X(2)=200;
Y(2)=200;
num_iter = 5e5;
disp('init BS');
for ii= 2:N
   temp_x = randsrc(1,1,0:grid_boun);
   temp_y = randsrc(1,1,0:grid_boun);
   
   while(sqrt((temp_y)-Y(ii-1))^2 + (temp_x-X(ii-1))^2)<2*cell_rad
          temp_x = randsrc(1,1,0:grid_boun);
          temp_y = randsrc(1,1,0:grid_boun);
   end
   
   X(ii) = temp_x; % x coordinates of BS
   Y(ii) = temp_y; % y coordinates of BS
end
disp('init BS done');
TOA = zeros(1,N);
MS_x = randsrc(1,1,0:grid_boun);
MS_y = randsrc(1,1,0:grid_boun);
MS_tau = 5; 
del_F = 1000;
x = randsrc(1,1,0:grid_boun);%MS_x*(1+bias*rand);
y = randsrc(1,1,0:grid_boun);%MS_y*(1+bias*rand);
tau = MS_tau*(1+bias*rand);
X_next = zeros(1,3);
X_curr = [x;y;tau];
X_actual = [MS_x;MS_y;MS_tau];
for ii=1:N
    TOA(ii) = tau+(1+bias*rand)*sqrt((MS_x-X(ii))^2 + (MS_y-Y(ii))^2)/c;
end
learn_rate = [1e-2 0 0;0 1e-2 0;0 0 1.3e-18];
plot(MS_x,MS_y,"*");
hold on 
plot(X,Y,"O");
iter = 0;

while norm(del_F) > error_thres && iter <= num_iter
    iter = iter+1;
    del_F = F(c,N,X,Y,TOA,X_curr(1),X_curr(2),X_curr(3));
    %learn_rate = [1e-2/del_F(1) 0 0;0 1e-2/del_F(2) 0;0 0 0];    
    delf_f(iter) = norm(del_F); 
    X_next = X_curr - learn_rate*del_F;
    X_curr = X_next;
    pos_est_x(iter) = X_curr(1);
    pos_est_y(iter) = X_curr(2);

    if mod(iter,100000)==0
        fprintf('gradient = [%d  %d  %d]  \n',del_F);
        fprintf('step = [%d  %d  %d]  \n', learn_rate*del_F);     
    end
end
plot(X_curr(1),X_curr(2),"d");
plot(pos_est_x,pos_est_y,'r');
hold off
xlabel('x-coordinates (mtr)');
ylabel('y-coordinates (mtr)');
title('MAP');
legend('true MS pos','BS pos','estimated MS pos','estimate trace path');
fprintf('gradient = [%d  %d  %d]  \n',del_F);
fprintf('X_actual = [%d  %d  %d]  \n',X_actual);
fprintf('X_curr = [%d  %d  %d]  \n',X_curr);
fprintf('current iterataion = %d \n',iter);
figure
plot(delf_f)
xlabel('iteration');
ylabel('||gradient||');
title('gradient');
pos_err = rmse(X_curr,X_actual);
fprintf('position error = %d \n',pos_err);

function del_F = F(c,N,X,Y,TOA,x,y,tau)
% overall cost function
% x, y and tau are current iteration estimates 
    f = @(ii,x,y,tau)(c*(TOA(ii)-tau)-sqrt((X(ii)-x)^2 + (Y(ii)-y)^2)); % cost function for one BS
    row1 = 0;
    row2=0;
    row3=0;
    alpha = ones(1,N);
    for ii=1:N
        row1 = row1+2*(alpha(ii)^2)*f(ii,x,y,tau)*((X(ii)-x))/sqrt((X(ii)-x)^2 + (Y(ii)-y)^2);
        row2 = row2+2*(alpha(ii)^2)*f(ii,x,y,tau)*((Y(ii)-y))/sqrt((X(ii)-x)^2 + (Y(ii)-y)^2);
        row3 = row3-2*c*f(ii,x,y,tau)*(alpha(ii)^2);
    end
    del_F = [row1;row2;row3];
    
end

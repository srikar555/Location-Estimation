clc
close all
%% rectangular grid
u = 1;
c=1;
var = 0.009;
grid_x=0:1:15;
grid_y=0:1:15;
BS_x = 5:u:8;
BS_y = zeros(1,length(BS_x));
%% Plotting the grid, MS, BS
figure
scatter(BS_x,BS_y,LineWidth=5,Color='b');
hold on
for x = 1:u:length(grid_x)
    for y = 1:u:length(grid_y)
         plot(grid_x(x),grid_y(y),'*',Color='r');
    end
end
MS_x = randsrc(1,1,grid_x);
MS_y = randsrc(1,1,grid_y);
plot(MS_x,MS_y,'O',LineWidth=5,Color='m');
     %% signal and noise 
    t1 = sqrt((MS_x-BS_x(1))^2 + (MS_y-BS_y(1))^2);
    t2 = sqrt((MS_x-BS_x(2))^2 + (MS_y-BS_y(2))^2);
    t3 = sqrt((MS_x-BS_x(3))^2 + (MS_y-BS_y(3))^2);
    t4 = sqrt((MS_x-BS_x(4))^2 + (MS_y-BS_y(4))^2);
    tau_1 = (t1-t1)/c;
    tau_2 = (t2-t1)/c;
    tau_3 = (t3-t1)/c;
    tau_4 = (t4-t1)/c;
    s = @(t)(exp(-t)); 
    %[0.1117    0.1363    0.6787    0.4952    0.1897    0.4950    0.1476    0.0550    0.8507    0.5606    0.9296 0.6967    0.5828    0.8154    0.8790    0.9889    0.0005    0.8654    0.6126    0.9900    0.5277    0.4795 0.8013    0.2278    0.4981    0.9009    0.5747    0.8452    0.7386    0.5860    0.2467    0.6664];%rand(1,2*ceil(length(grid_y)/c));
    n1 = sqrt(var)*randn(1,1);
    n2 = sqrt(var)*randn(1,1);
    n3 = sqrt(var)*randn(1,1);
    n4 = sqrt(var)*randn(1,1);
    %% received signal
    s_len = length(s);
    r1 = s(tau_1)+n1;
    r2 = s(tau_2)+n2;
    r3 = s(tau_3)+n3;
    r4 = s(tau_4)+n4;


min_llf = 100000;
est_x = 0;
est_y = 0;
for x = 1:u:length(grid_x)
    for y = 1:u:length(grid_y)
        temp =  sqrt((x-BS_x(1))^2 + (y-BS_y(1))^2);
        tau_11 = -(temp- sqrt((x-BS_x(1))^2 + (y-BS_y(1))^2))/c;
        tau_12 = -(temp - sqrt((x-BS_x(2))^2 + (y-BS_y(2))^2))/c;
        tau_13 = -(temp - sqrt((x-BS_x(3))^2 + (y-BS_y(3))^2))/c;
        tau_14 = -(temp - sqrt((x-BS_x(4))^2 + (y-BS_y(4))^2))/c;
        llf =  (r1 - s(tau_11))^2 +...
        (r2 - s(tau_12))^2 +...
        (r3 - s(tau_13))^2 + ...
        (r4 - s(tau_14))^2; 
         if(llf<min_llf)
             min_llf = llf;
             est_x = x;
             est_y = y;
         end
    end
end
plot(est_x,est_y,'d',LineWidth=2)
hold off











function [dq_x,xi_dq] = extract_average(file,dx,dy,plot_fn)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
delimiterIn=' ';
dq_arr=importdata(file,delimiterIn,8);
data_dq=dq_arr.data;

x=data_dq(:,1)*1e-9;
y=data_dq(:,2)*1e-9;
dq=data_dq(:,3);
%dx=0.01*1e-9;
%dy=0.01*1e-9;
%width=46e-9;

[xi,yi]=meshgrid(min(x):dx:max(x),min(y):dy:max(y));
dqi=griddata(x,y,dq,xi,yi);

if plot_fn==1
figure;
surf(xi,yi,dqi, 'EdgeColor','none')
xlabel('x(nm');
ylabel('y(nm');
title('\DeltaQ(x,y) (C/m^3)');
colorbar;
view(2);
end
%set(gca,'ColorScale','log')

%2:end for y direction is used here in case of any NaN during extraction
dq_x_avg_temp=mean(dqi(2:end-1,:),1);

xi_dq=xi(1,:);

if plot_fn==1
figure;
hold on;
xlabel('x(nm');
ylabel('\DeltaQ(x) (C/m)');
plot(xi_dq,dq_x_avg_temp);
end

dq_x=dq_x_avg_temp;
end


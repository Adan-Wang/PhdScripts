function [out,xi_out] = extract_2term_dy(file_v1,file_v2,dx,dy,width,plot_fn)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
delimiterIn=' ';
v1_arr=importdata(file_v1,delimiterIn,8);
data_v1=v1_arr.data;

delimiterIn=' ';
v2_arr=importdata(file_v2,delimiterIn,8);
data_v2=v2_arr.data;


v1_x=data_v1(:,1)*1e-9;
v1_y=data_v1(:,2)*1e-9;
v1=data_v1(:,3);

v2_x=data_v2(:,1)*1e-9;
v2_y=data_v2(:,2)*1e-9;
v2=data_v2(:,3);


%dx=0.01*1e-9;
%dy=0.01*1e-9;
%width=46e-9;

[xi,yi]=meshgrid(min(v1_x):dx:max(v1_x),min(v1_y):dy:max(v1_y));
v1_i=griddata(v1_x,v1_y,v1,xi,yi);
v2_i=griddata(v2_x,v2_y,v2,xi,yi);

if plot_fn==1
figure;
surf(xi,yi,v1_i, 'EdgeColor','none')
xlabel('x(nm');
ylabel('y(nm');
title('v1 (C/m^3)');
colorbar;
view(2);
end
%set(gca,'ColorScale','log')

integrand_width=width*v1_i(2:end-1,2:end-1).*v2_i(2:end-1,2:end-1);

termII_x_temp=trapz(dy,integrand_width,1);

xi_out=xi(1,2:end-1);

if plot_fn==1
figure;
hold on;
xlabel('x(nm');
ylabel('v1 (C/m)');
plot(xi_out,termII_x_temp);
end

out=termII_x_temp;
end


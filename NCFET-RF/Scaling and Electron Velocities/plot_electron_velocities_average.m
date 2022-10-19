clear all; close all; clc;
dx=0.05*1e-9;
dy=0.05*1e-9;
dV=0.02;
%Hfin=46e-9;
vT=0.025;


file_MOS_v_10nm="DeviceA_10nm_HP_Vg400mV_v_vs_xy.txt";
file_NC_v_10nm="DeviceNC2_10nm_HP_Vg400mV_v_vs_xy.txt";

file_MOS_v_7nm="DeviceA_7nm_Vg400mV_v_xy.txt";
file_NC_v_7nm="DeviceNC2_7nm_IsoIdVg400mV_v_xy.txt";

file_MOS_v_5nm="DeviceA_5nm_Vg400mV_v_xy.txt";
file_NC_v_5nm="DeviceNC2_5nm_IsoIdVg400mV_v_xy.txt";

%Average Velocity
[v_avg_MOS_10nm,xi_v_avg_MOS_10nm]=extract_average(file_MOS_v_10nm,dx,dy,0);
[v_avg_NC_10nm,xi_v_avg_NC_10nm]=extract_average(file_NC_v_10nm,dx,dy,0);

[v_avg_MOS_7nm,xi_v_avg_MOS_7nm]=extract_average(file_MOS_v_7nm,dx,dy,0);
[v_avg_NC_7nm,xi_v_avg_NC_7nm]=extract_average(file_NC_v_7nm,dx,dy,0);

[v_avg_MOS_5nm,xi_v_avg_MOS_5nm]=extract_average(file_MOS_v_5nm,dx,dy,0);
[v_avg_NC_5nm,xi_v_avg_NC_5nm]=extract_average(file_NC_v_5nm,dx,dy,0);

%Plot v for MOS and NC on same axis
figure;
hold on;
plot(xi_v_avg_MOS_10nm./max(xi_v_avg_MOS_10nm),v_avg_MOS_10nm,'k-','DisplayName','MOSFET - v','LineWidth',2);
plot(xi_v_avg_NC_10nm./max(xi_v_avg_NC_10nm),v_avg_NC_10nm,'r-','DisplayName','NCFET - v','LineWidth',2);

set(gca, 'Box', 'on');
set(gca, 'FontName', 'Helvetica');
set(gca, 'FontSize', 15);
set(gcf, 'Position', [200 300 700 500]);
set(gca, 'TickLength',[0.02 0.01]);
xlabel('POSITION [m]');
ylabel('MEAN ELECTRON VELOCITY [m/s]');
legend('show','location','southeast');
title('10-nm');

figure;
hold on;
plot(xi_v_avg_MOS_7nm./max(xi_v_avg_MOS_7nm),v_avg_MOS_7nm,'k-','DisplayName','MOSFET - v','LineWidth',2);
plot(xi_v_avg_NC_7nm./max(xi_v_avg_NC_7nm),v_avg_NC_7nm,'r-','DisplayName','NCFET - v','LineWidth',2);

set(gca, 'Box', 'on');
set(gca, 'FontName', 'Helvetica');
set(gca, 'FontSize', 15);
set(gcf, 'Position', [200 300 700 500]);
set(gca, 'TickLength',[0.02 0.01]);
xlabel('POSITION [m]');
ylabel('MEAN ELECTRON VELOCITY [m/s]');
legend('show','location','southeast');
title('7-nm');

figure;
hold on;
plot(xi_v_avg_MOS_5nm./max(xi_v_avg_MOS_5nm),v_avg_MOS_5nm,'k-','DisplayName','MOSFET - v','LineWidth',2);
plot(xi_v_avg_NC_5nm./max(xi_v_avg_NC_5nm),v_avg_NC_5nm,'r-','DisplayName','NCFET - v','LineWidth',2);

set(gca, 'Box', 'on');
set(gca, 'FontName', 'Helvetica');
set(gca, 'FontSize', 15);
set(gcf, 'Position', [200 300 700 500]);
set(gca, 'TickLength',[0.02 0.01]);
xlabel('POSITION [m]');
ylabel('MEAN ELECTRON VELOCITY [m/s]');
legend('show','location','southeast');
title('5-nm');
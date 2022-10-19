clear all; close all;

dx=0.05e-9;
dy=0.05e-9;

A_Ec_file='DeviceA_Ec_Vg700mVVd700mV_Id1200uAum.txt';
A_EX_file='DeviceA_EX_Vg700mVVd700mV_Id1200uAum.txt';
A_vel_file='DeviceA_velocity_Vg700mVVd700mV_Id1200uAum.txt';

A3_Ec_file='DeviceA3_Ec_Id1200uAum.txt';
A3_EX_file='DeviceA3_EX_Id1200uAum.txt';
A3_vel_file='DeviceA3_velocity_Id1200uAum.txt';

NC2_Ec_file='DeviceNC2_Ec_Id1200uAum.txt';
NC2_EX_file='DeviceNC2_EX_Id1200uAum.txt';
NC2_vel_file='DeviceNC2_velocity_Id1200uAum.txt';

[A_Avg_Ec,xi_A_Avg_Ec]=extract_average(A_Ec_file,dx,dy,0);
[A_Avg_EX,xi_A_Avg_EX]=extract_average(A_EX_file,dx,dy,0);
[A_Avg_vel,xi_A_Avg_vel]=extract_average(A_vel_file,dx,dy,0);

[A3_Avg_Ec,xi_A3_Avg_Ec]=extract_average(A3_Ec_file,dx,dy,0);
[A3_Avg_EX,xi_A3_Avg_EX]=extract_average(A3_EX_file,dx,dy,0);
[A3_Avg_vel,xi_A3_Avg_vel]=extract_average(A3_vel_file,dx,dy,0);

[NC2_Avg_Ec,xi_NC2_Avg_Ec]=extract_average(NC2_Ec_file,dx,dy,0);
[NC2_Avg_EX,xi_NC2_Avg_EX]=extract_average(NC2_EX_file,dx,dy,0);
[NC2_Avg_vel,xi_NC2_Avg_vel]=extract_average(NC2_vel_file,dx,dy,0);

figure;
plot(xi_A_Avg_Ec,A_Avg_Ec,'LineWidth',3,'DisplayName','Baseline');
hold on;
plot(xi_A3_Avg_Ec,A3_Avg_Ec,'LineWidth',3,'DisplayName','A3 - 3.3x Cox');
plot(xi_NC2_Avg_Ec,NC2_Avg_Ec,'LineWidth',3,'DisplayName','NC2 - 70% Match NCFET');
set(gca, 'FontName', 'Helvetica');
set(gca, 'FontSize', 20);
set(gcf, 'Position', [200 300 700 500]);
set(gca, 'TickLength',[0.02 0.01]);
xlabel('POSITION [m]');
ylabel('Ec/q - Conduction Band [V]');
legend('show','location','southeast');

figure;
plot(xi_A_Avg_Ec,A_Avg_Ec-A_Avg_Ec(1),'LineWidth',3,'DisplayName','Baseline');
hold on;
plot(xi_A3_Avg_Ec,A3_Avg_Ec-A3_Avg_Ec(1),'LineWidth',3,'DisplayName','A3 - 3.3x Cox');
plot(xi_NC2_Avg_Ec,NC2_Avg_Ec-NC2_Avg_Ec(1),'LineWidth',3,'DisplayName','NC2 - 70% Match NCFET');
set(gca, 'FontName', 'Helvetica');
set(gca, 'FontSize', 20);
set(gcf, 'Position', [200 300 700 500]);
set(gca, 'TickLength',[0.02 0.01]);
xlabel('POSITION [m]');
ylabel('Source Ref Ec/q - Conduction Band [V]');
legend('show','location','southeast');

figure;
plot(xi_A_Avg_EX,A_Avg_EX,'LineWidth',3,'DisplayName','Baseline');
hold on;
plot(xi_A3_Avg_EX,A3_Avg_EX,'LineWidth',3,'DisplayName','A3 - 3.3x Cox');
plot(xi_NC2_Avg_EX,NC2_Avg_EX,'LineWidth',3,'DisplayName','NC2 - 70% Match NCFET');
set(gca, 'FontName', 'Helvetica');
set(gca, 'FontSize', 20);
set(gcf, 'Position', [200 300 700 500]);
set(gca, 'TickLength',[0.02 0.01]);
xlabel('POSITION [m]');
ylabel('EX - X-Direction E-Field [V/m]');
legend('show','location','southeast');

figure;
plot(xi_A_Avg_vel,A_Avg_vel,'LineWidth',3,'DisplayName','Baseline');
hold on;
plot(xi_A3_Avg_vel,A3_Avg_vel,'LineWidth',3,'DisplayName','A3 - 3.3x Cox');
plot(xi_NC2_Avg_vel,NC2_Avg_vel,'LineWidth',3,'DisplayName','NC2 - 70% Match NCFET');
plot(xi_NC2_Avg_vel,2.1e5*ones(1,length(xi_NC2_Avg_vel)),'--','LineWidth',3,'DisplayName','vsat');
set(gca, 'FontName', 'Helvetica');
set(gca, 'FontSize', 20);
set(gcf, 'Position', [200 300 700 500]);
set(gca, 'TickLength',[0.02 0.01]);
xlabel('POSITION [m]');
ylabel('Electron Velocity [m/s]');
legend('show','location','southeast');
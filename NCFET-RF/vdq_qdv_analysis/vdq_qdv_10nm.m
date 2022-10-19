clear all; close all; clc;
dx=0.05*1e-9;
dy=0.05*1e-9;
dV=0.02;
Hfin=46e-9;
vT=0.025;

file_MOS_drho="DeviceA_10nm_HP_Ion_drho_vs_xy.txt";
file_MOS_rho="DeviceA_10nm_HP_Ion_rho_vs_xy.txt";
file_MOS_v="DeviceA_10nm_HP_Ion_v_vs_xy.txt";
file_MOS_dv="DeviceA_10nm_HP_Ion_dv_vs_xy.txt";
file_MOS_Ec="DeviceA_10nm_HP_Ion_Ec_vs_xy.txt";


file_MOS_Jn="DeviceA_10nm_HP_Ion_dJn_vs_xy.txt";

file_NC_drho="DeviceNC2_10nm_HP_Ion_drho_vs_xy.txt";
file_NC_rho="DeviceNC2_10nm_HP_Ion_rho_vs_xy.txt";
file_NC_v="DeviceNC2_10nm_HP_Ion_v_vs_xy.txt";
file_NC_dv="DeviceNC2_10nm_HP_Ion_dv_vs_xy.txt";
file_NC_Ec="DeviceNC2_10nm_HP_Ion_Ec_vs_xy.txt";

file_NC_Jn="DeviceNC2_10nm_HP_Ion_dJn_vs_xy.txt";




%Extract vdq term information
[vdq_mos,xi_vdq_mos]=extract_2term_dy(file_MOS_v,file_MOS_drho,dx,dy,Hfin,0);
[vdq_nc,xi_vdq_nc]=extract_2term_dy(file_NC_v,file_NC_drho,dx,dy,Hfin,0);

%Extract qdv term information
[qdv_mos,xi_qdv_mos]=extract_2term_dy(file_MOS_dv,file_MOS_rho,dx,dy,Hfin,0);
[qdv_nc,xi_qdv_nc]=extract_2term_dy(file_NC_dv,file_NC_rho,dx,dy,Hfin,0);

%Integrate Jn
[I_bias_MOS,xi_bias_MOS]=extract_dqx(file_MOS_Jn,dx,dy,Hfin,0);
[I_bias_NC,xi_bias_NC]=extract_dqx(file_NC_Jn,dx,dy,Hfin,0);

%Extract Average velocity and average delta velocity
%Average Velocity
[v_avg_MOS,xi_v_avg_MOS]=extract_average(file_MOS_v,dx,dy,0);
[v_avg_NC,xi_v_avg_NC]=extract_average(file_NC_v,dx,dy,0);

%Average delta velocity
[dv_avg_MOS,xi_dv_avg_MOS]=extract_average(file_MOS_dv,dx,dy,0);
[dv_avg_NC,xi_dv_avg_NC]=extract_average(file_NC_dv,dx,dy,0);

%Extract drho(x) function from drho (x,y) by integrating out the y direction
[dq_x_MOS,xi_dq_MOS]=extract_dqx(file_MOS_drho,dx,dy,Hfin,0);
[dq_x_NC,xi_dq_NC]=extract_dqx(file_NC_drho,dx,dy,Hfin,0);

%Extract rho(x) info by integrating rho(x,y)
[q_x_MOS,xi_q_MOS]=extract_dqx(file_MOS_rho,dx,dy,Hfin,0);
[q_x_NC,xi_q_NC]=extract_dqx(file_NC_rho,dx,dy,Hfin,0);

%Extract average Ec
[Ec_avg_MOS,xi_Ec_avg_MOS]=extract_average(file_MOS_Ec,dx,dy,0);
[Ec_avg_NC,xi_Ec_avg_NC]=extract_average(file_NC_Ec,dx,dy,0);

%plot everything
%Plot qdv+vdq for NCFET and MOSFET
figure;
hold on;
plot(xi_vdq_mos,vdq_mos,'DisplayName','MOSFET - vdq','LineWidth',2);
plot(xi_qdv_mos,qdv_mos,'DisplayName','MOSFET - qdv','LineWidth',2);
plot(xi_qdv_mos,qdv_mos+vdq_mos,'DisplayName','MOSFET-qdv+vdq','LineWidth',2);
plot(xi_bias_MOS,-I_bias_MOS,'DisplayName','MOSFET - dI','LineWidth',2);


set(gca, 'FontName', 'Helvetica');
set(gca, 'FontSize', 20);
set(gcf, 'Position', [200 300 700 500]);
set(gca, 'TickLength',[0.02 0.01]);
xlabel('POSITION [m]');
ylabel('VARIOUS TERMS [A]');
legend('show','location','southeast');


figure;
hold on;
plot(xi_vdq_nc,vdq_nc,'DisplayName','NCFET - vdq','LineWidth',2);
plot(xi_qdv_nc,qdv_nc,'DisplayName','NCFET - qdv','LineWidth',2);
plot(xi_qdv_nc,qdv_nc+vdq_nc,'DisplayName','NCFET-qdv+vdq','LineWidth',2);
plot(xi_bias_NC,-I_bias_NC,'DisplayName','NCFET - dI','LineWidth',2);


set(gca, 'FontName', 'Helvetica');
set(gca, 'FontSize', 20);
set(gcf, 'Position', [200 300 700 500]);
set(gca, 'TickLength',[0.02 0.01]);
xlabel('POSITION [m]');
ylabel('VARIOUS TERMS [A]');
legend('show','location','southeast');

%Plot v for MOS and NC on same axis
figure;
hold on;
plot(xi_v_avg_MOS,v_avg_MOS,'k-','DisplayName','MOSFET - v','LineWidth',2);
plot(xi_v_avg_NC,v_avg_NC,'r-','DisplayName','NCFET - v','LineWidth',2);

set(gca, 'FontName', 'Helvetica');
set(gca, 'FontSize', 20);
set(gcf, 'Position', [200 300 700 500]);
set(gca, 'TickLength',[0.02 0.01]);
xlabel('POSITION [m]');
ylabel('MEAN ELECTRON VELOCITY [m/s]');
legend('show','location','southeast');


%Plot dv for MOS and NC on same axis
figure;
hold on;
plot(xi_dv_avg_MOS,dv_avg_MOS,'DisplayName','MOSFET - dv','LineWidth',2);
plot(xi_dv_avg_NC,dv_avg_NC,'DisplayName','NCFET - dv','LineWidth',2);

set(gca, 'FontName', 'Helvetica');
set(gca, 'FontSize', 20);
set(gcf, 'Position', [200 300 700 500]);
set(gca, 'TickLength',[0.02 0.01]);
xlabel('POSITION [m]');
ylabel('MEAN CHANGE IN ELECTRON VELOCITY [m/s]');
legend('show','location','southeast');

%Plot dq for MOS and NC on same axis
figure;
hold on;
plot(xi_dq_MOS,dq_x_MOS,'DisplayName','MOSFET - dq','LineWidth',2);
plot(xi_dq_NC,dq_x_NC,'DisplayName','NCFET - dq','LineWidth',2);

set(gca, 'FontName', 'Helvetica');
set(gca, 'FontSize', 20);
set(gcf, 'Position', [200 300 700 500]);
set(gca, 'TickLength',[0.02 0.01]);
xlabel('POSITION [m]');
ylabel('Delta W*rho*dy [C/m]');
legend('show','location','southeast');

%Plot q for MOS and NC on same axis
figure;
hold on;
plot(xi_q_MOS,q_x_MOS,'DisplayName','MOSFET - q','LineWidth',2);
plot(xi_q_NC,q_x_NC,'DisplayName','NCFET - q','LineWidth',2);

set(gca, 'FontName', 'Helvetica');
set(gca, 'FontSize', 20);
set(gcf, 'Position', [200 300 700 500]);
set(gca, 'TickLength',[0.02 0.01]);
xlabel('POSITION [m]');
ylabel('W*rho*dy [C/m]');
legend('show','location','southeast');

%Plot Conduction band diagrams on same axis, referencing to source voltage
figure;
hold on;
plot(xi_Ec_avg_MOS,Ec_avg_MOS-Ec_avg_MOS(1),'k-','DisplayName','MOSFET - Ec','LineWidth',2);
plot(xi_Ec_avg_NC,Ec_avg_NC-Ec_avg_NC(1),'r-','DisplayName','NCFET - Ec','LineWidth',2);

set(gca, 'FontName', 'Helvetica');
set(gca, 'FontSize', 20);
set(gcf, 'Position', [200 300 700 500]);
set(gca, 'TickLength',[0.02 0.01]);
xlabel('POSITION [m]');
ylabel('CONDUCTION BAND WRT SOURCE [eV]');
legend('show','location','southeast');


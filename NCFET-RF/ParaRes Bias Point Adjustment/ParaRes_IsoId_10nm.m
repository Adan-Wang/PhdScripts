clear all; clc; close all;

%Define variables
Rd=1170.96;
Rs=1170.96;
Vd_app=0.7;
Vg_app=0:0.1:0.7;
W=0.046*2;

%Import NCFET data and MOSFET data
mosfet_arr=ArrayExtract(8,4,'DeviceA_HP_IdVd_HalfVd.txt');
ncfet_arr=ArrayExtract(8,4,'DeviceNC2_HP_IdVd_HalfVd.txt');

%Define info structs
%NCFET info struct
ncfet_info_struct.Vg_array=[0:0.1:0.7];
ncfet_info_struct.Vd_array=[0.4:0.1:0.7];

% ncfet_info_struct.Vg_min=0;
% ncfet_info_struct.Vg_max=0.6;
% 
% ncfet_info_struct.Vd_min=0.3;
% ncfet_info_struct.Vd_max=0.6;
% 
% ncfet_info_struct.step=0.1;

%MSOFET info struct
mosfet_info_struct.Vg_array=[0:0.1:0.7];
mosfet_info_struct.Vd_array=[0.4:0.1:0.7];

% mosfet_info_struct.Vg_min=0;
% mosfet_info_struct.Vg_max=0.6;
% 
% mosfet_info_struct.Vd_min=0.3;
% mosfet_info_struct.Vd_max=0.6;
% 
% mosfet_info_struct.step=0.1;

%Obtain Id-Vg for both devices


[Id_MOSFET,Vd_prime_MOSFET,Vs_prime_MOSFET]=bsearch_vgvd(Vd_app,Vg_app,Rd,Rs,mosfet_arr,mosfet_info_struct);
[Id_NCFET,Vd_prime_NCFET,Vs_prime_NCFET]=bsearch_vgvd(Vd_app,Vg_app,Rd,Rs,ncfet_arr,ncfet_info_struct);

%Plot intermediate data

figure;
yyaxis left
semilogy(Vg_app,1e3*Id_MOSFET(end,:)/W,'DisplayName','MOSFET - Log','LineWidth',3);
hold on;
semilogy(Vg_app,1e3*Id_NCFET(end,:)/W,'DisplayName','NCFET - Log','LineWidth',3);
ylabel('DRAIN CURRENT[mA/\mum]');

yyaxis right
plot(Vg_app,1e3*Id_MOSFET(end,:)/W,'DisplayName','MOSFET - Lin','LineWidth',3);
hold on;
plot(Vg_app,1e3*Id_NCFET(end,:)/W,'DisplayName','NCFET - Lin','LineWidth',3);
ylabel('DRAIN CURRENT[mA/\mum]');



xlabel('GATE VOLTAGE [V]');
title(sprintf('On-current characteristics with Rext'));
grid on;
legend('show');

set(gca, 'Box', 'on');
set(gca, 'FontName', 'Helvetica');
set(gca,'ycolor','k');
set(gca, 'FontSize', 18);
set(gca,'TickLength',[0.02 0.01]);
yyaxis left
set(gca, 'Box', 'on');
set(gca, 'FontName', 'Helvetica');
set(gca,'ycolor','k');
set(gca, 'FontSize', 18);
set(gca,'TickLength',[0.02 0.01]);
set(gcf, 'Position', [200 300 700 500]);
legend('show');



%Interpolate Id-Vg for devices to get Vg for NCFET for different currents
%in MOSFET
%The element correspond to the lowest voltage I want to test
MOS_Element_Start=2;

for i=MOS_Element_Start:length(Id_MOSFET)
    Id_target=Id_MOSFET(i);
    Vg_NCFET_Interp(i)=interp1(Id_NCFET,Vg_app,Id_target);
end
Vg_NCFET_Interp=Vg_NCFET_Interp(MOS_Element_Start:length(Id_MOSFET));
Vg_MOSFET_Check=Vg_app(MOS_Element_Start:end);

%Use new Vg to find Vg' using the same idea as above
for i=1:length(Vg_NCFET_Interp)
    [Id_NCFET_Interp,Vd_prime_NCFET_Interp,Vs_prime_NCFET_Interp]=bsearch_vgvd(Vd_app,Vg_NCFET_Interp(i),Rd,Rs,ncfet_arr,ncfet_info_struct);
    [Id_MOSFET_Check,Vd_prime_MOSFET_Check,Vs_prime_MOSFET_Check]=bsearch_vgvd(Vd_app,Vg_MOSFET_Check(i),Rd,Rs,mosfet_arr,mosfet_info_struct);
    fprintf('Target MOS Vg: %0.2f V',Vg_MOSFET_Check(i));
    fprintf('Target Current: %0.3f mA/um \n',1e3*Id_MOSFET(i+MOS_Element_Start-1)/(W));
    fprintf("NCFET Results: Vg: %0.3f V, Vd: %0.3f V, Vgs'%0.3f V, Vds': %0.3f V, Id_NCFET: %0.3f mA/um \n",Vg_NCFET_Interp(i),Vd_app,Vg_NCFET_Interp(i)-Vs_prime_NCFET_Interp,Vd_prime_NCFET_Interp-Vs_prime_NCFET_Interp,1e3*Id_NCFET_Interp/W);
    fprintf("MOSFET Check Results: Vg: %0.3f V, Vd: %0.3f V, Vgs'%0.3f V, Vds': %0.3f V, Id_MOSFET: %0.3f mA/um \n",Vg_MOSFET_Check(i),Vd_app,Vg_MOSFET_Check(i)-Vs_prime_MOSFET_Check,Vd_prime_MOSFET_Check-Vs_prime_MOSFET_Check,1e3*Id_MOSFET_Check/W);
    fprintf('\n');

    
end


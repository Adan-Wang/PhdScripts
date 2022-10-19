clear all; close all;

%Vth is I at 1e-13/Lg in units of A/um (Thomas's first paper, IRDS 2017 MM table Notes [6])
Lg=20e-9;
Id_Vth=1e-7*1000e-9/Lg;
%Width in um
W=0.046*2;


% NC1_file='DeviceNC2_DC_IdVg_Vd700mV_mAum.txt';
% data_NC1=Impdata_COMSOLForm(NC1_file);

%Input should be in amps
%NCFET
NCIdVg=importdata('HP_NC2_Rs1122_IdVg_Vd700mV.mat');
Vg_NC=NCIdVg.Vg_app;
Id_NC=NCIdVg.Id_NCFET/W;

vthNC=interp1(log10(Id_NC),Vg_NC,log10(Id_Vth))


MOSIdVg=importdata('HP_dA_Rs1122_IdVg_Vd700mV.mat');
Vg_MOS=MOSIdVg.Vg_app;
Id_MOS=MOSIdVg.Id_MOSFET/W;

vthMOS=interp1(log10(Id_MOS),Vg_MOS,log10(Id_Vth))




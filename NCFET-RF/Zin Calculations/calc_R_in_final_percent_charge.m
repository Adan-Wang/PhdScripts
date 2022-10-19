clear all; close all; clc;
file="DeviceNC2_HP_CorrVgVd_dQ_IsoIdVg100mV.txt";
dx=0.05*1e-9;
dy=0.05*1e-9;
width=46e-9;
SDL=8e-9;
Lch=20e-9;
N=200;
dV=0.02;
tfe=4.22e-9;
rho=1.8e-3;
Afe=Lch*(2*width);
%How much of the channel is help ON EACH SIDE
%pchannel=0.1;

[dq_x,xi_dq]=extract_dqx(file,dx,dy,width,1);

%extract relevant segment for channel
ch_start=SDL;
ch_end=SDL+Lch;
% ch_start_ind=find(abs(xi_dq-ch_start)<1e-12);
% ch_end_ind=find(abs(xi_dq-ch_end)<1e-12);
ch_start_ind=1;
ch_end_ind=length(dq_x);


dq_x_ch=dq_x(ch_start_ind:ch_end_ind);

%Capacitance of each segment, with a length of dx
cn_full_dx=(dq_x*dx)/dV;
for i=1:length(cn_full_dx)
    if cn_full_dx(i)<0
        cn_full_dx(i)=0;
    end
end
%Capacitance of each segment, with a length of dx for the channel region
cn_ch_dx=dq_x_ch*dx/dV;
for i=1:length(cn_ch_dx)
    if cn_ch_dx(i)<0
        cn_ch_dx(i)=0;
    end
end
% %Command to make distibuted capacitance look like a uniform average channel
% %capacitance
% cn_ch_dx=sum(cn_ch_dx)/length(cn_ch_dx)*ones(1,length(cn_ch_dx));

%Capacitance of the sides lumped together, discounting the channel region
% C_left=cn_full_dx(1:ch_start_ind-1);
% C_right=cn_full_dx(ch_end_ind+1:end);
% 
% l_help=floor(pchannel*length(cn_ch_dx));
%Capacitance of the sides, evenly distributed to add to branches in the
%channel region
% C_left_dis=(sum(C_left)/l_help)*ones(1,l_help);
% C_right_dis=(sum(C_right)/l_help)*ones(1,l_help);

figure(3);
plot(xi_dq,cn_full_dx,'DisplayName','Full-Channel Capacitance');
hold on;
plot(xi_dq(ch_start_ind:ch_end_ind),cn_ch_dx,'DisplayName','Capacitance over Channel Region');
xlabel('x(m)');
ylabel('C(F/m)');
title('C(x),dx=0.01nm');
grid on;


%Helping Commands for modifying capacitance so that the channel portions
%"help charge the side"
% cn_ch_dx(1:l_help)=cn_ch_dx(1:l_help)+C_left_dis;
% cn_ch_dx(end-l_help+1:end)=cn_ch_dx(end-l_help+1:end)+C_right_dis;

plot(xi_dq(ch_start_ind:ch_end_ind),cn_ch_dx,'DisplayName','Capacitance over Channel, with side caps added in');
legend('show');
%pause;



%Zin Calculation%%%%%

% f=logspace(1,12);
f=logspace(0,15);
% w=2*pi*f;
R=rho*tfe/Afe;

%FET - dx discretization
for ii=1:length(f)
     w=2*pi*f(ii);
%     Z_in(ii)=calc_Zin(cn_full_dx,R,w);
%     R_in(ii)=real(Z_in(ii));


    %Channel only - dx discretization, but with each channel "segment" also
    %contributing to charging the "side capacitors"
    Z_in_ch(ii)=calc_Zin(cn_ch_dx,R,w);
    R_in_ch(ii)=real(Z_in_ch(ii));

end

figure(4);

semilogx(f,R_in_ch/R,'DisplayName','R_{in} (Channel Region Only, with equal contribution to side loads)');
hold on;
grid on;
% semilogx(f,R_in,'DisplayName','R_in (Entire Channel)');
xlabel('Frequency (Hz)');
ylabel('R_in (\Omega)');
title('R_in vs f, R_\rho=\rho*t_fe/A*fe=3540\Omega');
legend('show');




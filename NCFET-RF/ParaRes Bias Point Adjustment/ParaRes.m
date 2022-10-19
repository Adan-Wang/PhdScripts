clear all; close all; %clc;
fet_arr=ArrayExtract(6,6,'DeviceNC2_7nm_AdjVdd_Full_IdVd.txt');
fet_arr=abs(fet_arr); %Likely a bug-fixing thing...
% Vg=1.2;
% Vd=1;
R1=459.51*2;
R2=459.51*2;
Vd_app=0.55;
Vg_app=0.55;
W=0.05*2;



for i=1:length(Vd_app)
    Vd=Vd_app(i);
    for j=1:length(Vg_app)
        Vg=Vg_app(j);
        I_calc=213;
        ub=interp2(0:0.1:0.5,0:0.1:0.5,fet_arr,0.5,0.5);
        lb=min(min(fet_arr));
        I_guess=0.5*(ub+lb);

        
        %i=0;
        %While loop to find correct I
        bsc=0;
        while abs(I_guess-I_calc)>I_guess*1e-6
            vd_calc=Vd-I_guess*R1;
            vs_calc=I_guess*R2;
            

            Vgs_calc=Vg-vs_calc;
            Vds_calc=vd_calc-vs_calc;
            
            if Vgs_calc<0
               Vgs_calc=0;
            end
            
            if Vds_calc<0
                Vds_calc=0;
            end
            
            I_calc=interp2(0:0.1:0.5,0:0.1:0.5,fet_arr,Vgs_calc,Vds_calc);
            %vd_calc=I_guess+I*R1+I*R2;
            
            %If the guess is too low, we need to increase the guess to
            %decrease the calc, as an increase in I decreases vds' and
            %vgs', which decreases the calc, if the goal is to have
            %Iguess==Icalc, it is necessary to increase Iguess in the case
            %where Iguess<Icalc, and vice versa, the if statements below
            %takes care of that.
            if I_guess-I_calc<0
                lb=I_guess;
                I_guess=0.5*(ub+lb);
            elseif I_guess-I_calc>0
                ub=I_guess;
                I_guess=0.5*(ub+lb);
            elseif I_guess-I_calc==0
                break;
            else
                disp('something is wrong, this should never be triggered');
                return;
            end
            bsc=bsc+1;
            if bsc>1E7
                disp('No result fromsearch');
                return;
            end
        end
        I_ds_final(i,j)=I_guess;
        Vd_prime_final(i,j)=Vd-I_guess*R1;
        Vs_prime_final(i,j)=I_guess*R2;
    end
end

figure(1);
yyaxis left
semilogy(Vg_app,1e6*I_ds_final(end,:)/W,'DisplayName','COMSOL - Log');
ylabel('Ids(\muA/\mum)');
yyaxis right
plot(Vg_app,1e6*I_ds_final(end,:)/W,'DisplayName','COMSOL - Lin');
hold on;
xlabel('Vgs(V)');
ylabel('Ids(\muA/\mum)');
title(sprintf('On current characteristics with Rext',R1+R2));
grid on;
legend('show');

%Plotting the output characteristic
figure;
hold on;
[Vd_size, Vg_size]=size(I_ds_final);
for ii=1:Vg_size
    plot(Vd_app,I_ds_final(:,ii),'LineWidth',2);
end


% %Plot reference with COMSOL Series Resistance
% IdVg="DGFET_ExpGate_CustMesh_IdVg_mu200_DopedChannel_WF470mV_IdVg_VarRext.txt";
% delimiterIn=' ';
% idvg_dat=importdata(IdVg,delimiterIn,8);
% idvg_noR=idvg_dat.data;
% plot(idvg_noR(1:13,1),idvg_noR(1:13,2),'bo');
% plot(idvg_noR(14:26,1),idvg_noR(14:26,2),'ko');
% plot(idvg_noR(27:39,1),idvg_noR(27:39,2),'mo');
% %plot(idvg_noR(40:52,1),idvg_noR(40:52,2),'mo');
% % %plot second reference
% % IdVg2="DGFET_ExpGate_CustMesh_IdVg_mu200_DopedChannel_WF470mV_IdVg_Rext2kOhm.txt";
% % delimiterIn=' ';
% % idvg2_dat=importdata(IdVg2,delimiterIn,8);
% % idvg2=idvg2_dat.data;
% % plot(idvg2(:,1),idvg2(:,2),'o');
% 
%Plot Voltages
figure;
plot(Vg_app,Vd_prime_final,'DisplayName','Actual Drain Voltage');
hold on;
plot(Vg_app,Vs_prime_final,'DisplayName','Actual Source Votlage');
plot(Vg_app,Vd_prime_final-Vs_prime_final,'--','DisplayName','Actual Vds');
xlabel('Vgs(V)');
ylabel('Voltages (V)');
grid on;
legend('show');

fprintf('Results in text form \n');
for i=1:length(Vd_app)
    for j=1:length(Vg_app)
        fprintf("External Voltages: Vgs=%0.2f V, Vds=%0.2f V, Voltages at Intrinsic terminals: Vgs'=%0.3f V, Vds'=%0.3f V \n",Vg_app(j),Vd_app(i),Vg_app(j)-Vs_prime_final(i,j),Vd_prime_final(i,j)-Vs_prime_final(i,j));
        fprintf("\n");
    end
end
% 
% %Singh Data
% singh_1V=importdata("SinghFig3a_Vd1V.csv");
% 
% figure(3);
% plot(singh_1V(:,1),singh_1V(:,2)/360,'ro','DisplayName','Singh et al, Vd=1V, Lg=20nm');
% vg_singh1V=singh_1V(:,1);
% logid_singh1V=log10(singh_1V(:,2));
% id_singh1V=singh_1V(:,2);
% hold on;
% grid on;
% plot(Vg_app,I_ds_final,'b','DisplayName','COMSOL');
% xlabel('Vgs(V)');
% ylabel('Ids(A)');
% title('Ids vs Vgs, Vd=1V');
% legend('show');

%AuthData

% auth_700mV=importdata("AuthFig11_Vd700mV.csv");
% 
% 
% figure(1);
% yyaxis left
% semilogy(auth_700mV(:,1),1e6*auth_700mV(:,2),'*','DisplayName','Auth et al. Vd=700mV');
% yyaxis right
% plot(auth_700mV(:,1),1e6*auth_700mV(:,2),'*','DisplayName','Auth et al. Vd=700mV');
% 
% %Compare FoC%
% figure(3);
% hold on;
% grid on;
% for i=1:length(Vg_app)
%     plot(Vd_app,1e6*I_ds_final(:,i)/W,'DisplayName',sprintf('Vg=%0.2f',Vg_app(i)));
% end
% xlabel('Vd(V)');
% ylabel('Id(uA/um)');
% title('Output Characteristics COMSOL vs Auth');
% legend('show')
% 
% %AuthFoC%
% 
% auth_FoC=importdata('AuthFig9.csv');
% figure(3);
% plot(auth_FoC(:,1),1e3*auth_FoC(:,2),'*','DisplayName','Auth et al');

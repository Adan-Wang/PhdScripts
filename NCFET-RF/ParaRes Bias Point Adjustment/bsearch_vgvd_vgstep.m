function [I_ds_final,Vd_prime_final,Vs_prime_final] = bsearch_vgvd_vgstep(Vd_app,Vg_app,Rd,Rs,fet_arr,info_struct)
%UNTITLED2 Summary of this function goes here
%Perform binary search on given Vg,Vd,Rs, and Rd.  Takes array inputs of Vd
%and Vg applied (target Vd,Vg on the outside terminals, in any array form),
%Rs,Rd (single value), and fet_arr, which is the Id-Vd array for the FET,
%generated via "ArrayExtract" function, which makes the rows each Vg, and
%the columns each Vd. Info_struct is to be a structure that allows user to
%specify the Vg ranges, Vd ranges, and steps for the interpolation.

%This function putputs three arrays, Ids, Vd, and Vs, these are values of
%the Ids, internal Vd, and internal Vs for a given Vg and Vd
%   Detailed explanation goes here

Vg_min=info_struct.Vg_min;
Vg_max=info_struct.Vg_max;

Vd_min=info_struct.Vd_min;
Vd_max=info_struct.Vd_max;

step=info_struct.step;


for i=1:length(Vd_app)
    Vd=Vd_app(i);
    for j=1:length(Vg_app)
        Vg=Vg_app(j);
        I_calc=213;
        ub=interp2(Vg_min:step:Vg_max,Vd_min:step:Vd_max,fet_arr,Vg,Vd);
        lb=min(min(fet_arr));
        I_guess=0.5*(ub+lb);

        
        %i=0;
        %While loop to find correct I
        bsc=0;
        while abs(I_guess-I_calc)>I_guess*1e-7
            vd_calc=Vd-I_guess*Rd;
            vs_calc=I_guess*Rs;
            

            Vgs_calc=Vg-vs_calc;
            Vds_calc=vd_calc-vs_calc;
            
            if Vgs_calc<Vg_min
               Vgs_calc=Vg_min;
            end
            
            if Vds_calc<Vd_min
                Vds_calc=Vd_min;
            end
            
            I_calc=interp2(Vg_min:step:Vg_max,Vd_min:step:Vd_max,fet_arr,Vgs_calc,Vds_calc);
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
                disp(Vds_calc);
                disp(I_guess);
                disp(I_calc);
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
        Vd_prime_final(i,j)=Vd-I_guess*Rd;
        Vs_prime_final(i,j)=I_guess*Rs;
    end
end


end


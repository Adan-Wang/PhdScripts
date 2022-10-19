function [Zin] = calc_Zin(C_n,R,w)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
Zin_inv=0;
for ii=1:length(C_n)
    Zin_inv=Zin_inv+(1j*w*C_n(ii))/(1j*w*C_n(ii)*R*length(C_n)+1);
end
Zin=(Zin_inv)^-1;
end


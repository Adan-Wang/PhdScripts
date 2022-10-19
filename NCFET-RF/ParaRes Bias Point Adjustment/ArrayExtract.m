function [IdVgVdArr] = ArrayExtract(vg_pts,vd_pts,file)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
IdVgVdArr=zeros(vd_pts,vg_pts);
delimiterIn=' ';
idvgvd_raw=importdata(file,delimiterIn,8);
data_arr=idvgvd_raw.data;
j=1;
for i=1:vg_pts
IdVgVdArr(:,i)=data_arr(j:j+vd_pts-1,2);
j=j+vd_pts;
end
end


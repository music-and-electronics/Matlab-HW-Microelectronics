clear all;
close all;

Vd_Diode_Voltage=[0:0.01:0.9]';
k_Boltz         =1.38e-23;
Temperature     =300;
q_charge        =1.6e-19;
Vt_Thermal      =k_Boltz*Temperature/q_charge;
Is_Saturation   =1e-16;
Id_diode              =Is_Saturation*exp(Vd_Diode_Voltage/Vt_Thermal);

figure;
plot(Vd_Diode_Voltage,Id_diode);

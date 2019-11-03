%% Initiallizing
clear all; close all;
beta = 100; % Transistor Current Gain
Is = 5.0e-16; % Saturation Current
Vt = 26e-3;
Va = 50; % Early Voltage = 50V
Rsrc = 500; % Source Impedance
Rb1 = 100e3;
Rb2 = 100e3;
RL = 10e3;
RC = 1e3;
Vcc = 4.0; 
Ve = 0.2; %Emitter Volt.
etol = 1e-7; % error tolerance

%% (a) find bias current an voltage
VBE = 0.7; %% iteration starts with 0.8V
err = etol + 1; %% initialize for while loop
V_thevenin = (Rb2/(Rb1+Rb2))*Vcc;  %%thevenin eq
R_thevenin =P_Resistance(Rb1,Rb2); %%thevenin eq

while(abs(err) > etol) % Iterate if error is too large
	err = VBE;
    IB = (V_thevenin-VBE)/R_thevenin;
	IC = beta*IB;
	VBE = Vt*log(IC/Is);
	err = err-VBE; %%값 차이 측정(err)
end

disp(IC);
VB = VBE + Ve;
disp(VB);

RC_MAX = (Vcc-VB)/IC; %% MAX는 VBC = 0 'saturation edge' 일 때
disp(RC_MAX);

%% (b) find gain expression using small-signal anlaysis
gm = IC/Vt;
Ro = Va/IC;
VTheofIn = (R_thevenin/(R_thevenin+Rsrc)); %% 테브난V = VIn * VTtheofIn 꼴
Rthe = P_Resistance(Rsrc,R_thevenin);

tempgain = -(P_Resistance(RL,RC,Ro))/((1/gm)+(Rthe/(1+beta)));
disp(P_Resistance(RL,RC,Ro));
gain = tempgain*VTheofIn;
disp(gain);
%% (c) find Vc1 3_cycle plot
t = [0:1e-6:3e-4]';
f = 10e3; %% f=10khz
Vin = 0.001*sin(2*pi*f.*t); %% .*t 시간에 대해서

Vc1 = gain*Vin; %% Vout과 Vc1의 전압 같음

h=figure;
plot(t, Vc1,'LineWidth',2);
grid on;
axis([0 3e-4 -0.1 0.1]);
xlabel('time [s]','FontSize',14);
ylabel('Vin [V]','FontSize',14);
title('V-t characteristic','FontSize',14);
FN=findall(h,'-property','FontSize');
set(FN,'FontSize',14);

%% (d) find Rb2 and Ic1

etol = 1e-2;
err = etol + 1;

while(abs(err) > etol)
	V_thevenin = (Rb2/(Rb1+Rb2))*Vcc;
	R_thevenin =P_Resistance(Rb1,Rb2);
	IB = (V_thevenin-VBE)/R_thevenin;
	IC = beta*IB;
	VBE = Vt*log(IC/Is);
	gm = IC/Vt;
	Ro = Va/IC;
	VTheofIn = (R_thevenin/(R_thevenin+Rsrc));
	Rthe = P_Resistance(Rsrc,R_thevenin);
	tempgain = -(P_Resistance(RL,RC,Ro))/((1/gm)+(Rthe/(1+beta)));
	gain = tempgain*VTheofIn;
	if(abs(gain) < 50)
		Rb2 = Rb2 + 0.1;
    elseif(abs(gain) > 50)
		Rb2 = Rb2 - 0.1;
    end
	err = 50 - abs(gain);
end

    disp(Rb2); disp(gain); %% gain -50


%-funtion for caculating Parellel Resistance-%
function R=P_Resistance(varargin)
    
    resistor_num     =nargin;                     %number of input parameter
    resistor_vec     =zeros(1,resistor_num);      %intializing vector
    
    for i=1:resistor_num
        resistor_vec(i) = varargin{i};            %input value in vector
    end
    
    R = 1/sum(1./resistor_vec(1,1:resistor_num)); %Caculating Parellel Resistance 
                                                  %from vector value
end
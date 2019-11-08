clear all;
close all;

%-Resistor-%
    R_b1  =100e3;
    R_b2  =100e3;
%-Voltage-%
    V_cc  =4.0;
    V_t   =26e-3; 
    V_E   =0.2;
%-Current-%
    I_s   =5e-16;
%-etc-%
    e_tol =1e-7;
    beta  =100;   

%-(a)-%
    V_BE   =0.7;                                    %V_BE assumption
    err    =e_tol+1;                                %initial error value (eror_value is e_tol+1)    
    V_bias =(R_b2/(R_b1+R_b2))*V_cc;                %Caculation of DC bias voltage 
    R_bias =P_Resistance(R_b1,R_b2);                %Caculation of DC bias resistance

    while (abs(err)>e_tol)           
        err  =V_BE;                                 %err=V_BE
        I_B  =(V_bias-V_BE)/R_bias;                 %Caculating Value of I_B from V_BE
        I_C  =I_B*beta;                              
        V_BE =V_t*log(I_C/I_s);                     %update V_BE from iterated I_C
        err  =err-V_BE;                             %err = V_BE-V_BE_new
    end
    V_B =V_BE+V_E;                                  %V_BE is V_B - V_E
    R_C_max=(V_cc-V_B)/I_C;                         %Rc is max when V_C = V_B

    disp(I_C); disp(V_B); disp(R_C_max);

%-Resistor-%
    R_c     =1e3;
    R_L     =10e3;
    R_src   =500;
    R_T     =P_Resistance(R_bias,R_src);           %value of thevenin equivalent resistance
%-Voltage-%
    V_A     =50;
%-etc-%
    gm      =I_C/V_t;                              %transconductance
    r_o     =V_A/I_C;                              %Early Resistance
%-(b)-%
    R_in    = R_bias/(R_src+R_bias);               %value of input impedence
    gain    =-(P_Resistance(R_c,R_L,r_o)/((1/gm)+R_T/(1+beta)))*R_in; %gain calculation in CE circuit
    disp(gain);
%-(c)-%
    t       =[0:1e-10:3e-4]';                      %time scale definition
    freq    =10e3;                                 %freqeuncy definition
    V_in    =1e-3*sin(2*pi*freq.*t);               %V_in definition
    V_dc    = V_cc-I_C*R_c;                        %value of DC voltage in large signal model
    V_c1    =gain*V_in+V_dc;                       %actual value of V_c1 with the effect of DC voltage
  
%-plot code of prob(c)-%
    figure;
    plot(t,V_c1,'LineWidth',2);                    %characteristic of graph line
    grid on
    title('The Plot Of Vc1 (V/time)');             %title of plot
    xlabel('time[s] (3 cycles)','fontsize',12);    %explain of x-axis
    ylabel('Vc1[V]','fontsize',12);                %explain of y-axis
    legend({'Vc1'},'Location','northeast');        %position of graph name label

%-(d)-%
    gain_taget  =-50;                              %initial target value of gain
    error_gain  =10;                               %initial gain assumption

    while(abs(error_gain)>abs(gain_taget/100))     %if error value is less or same with 1% of target gain
        V_bias     =(R_b2/(R_b1+R_b2))*V_cc;       
        R_bias     =P_Resistance(R_b1,R_b2);
        I_B        =(V_bias-V_BE)/R_bias;  
        I_C        =I_B*beta;        
        V_BE       =V_t*log(I_C/I_s);           
        r_o        =V_A/I_C;
        gm         =I_C/V_t;        
        R_in       =R_bias/(R_src+R_bias);
        R_T        =P_Resistance(R_bias,R_src);
        gain_cal   =-(P_Resistance(R_c,R_L,r_o)/((1/gm)+R_T/(1+beta)))*R_in;    %updating gain by updated gain factors
        error_gain =gain_cal-gain_taget;                                        %updating gain error value by updated gain
        
        if error_gain>0 %if gain_target is larger than gain_cal
            R_b2 =R_b2+0.1; 
        else            %else gain_cal is larger than gain target
            R_b2 =R_b2-0.1;
        end

    end
    

    disp(R_b2); disp(gain_cal); disp(I_C);
    

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
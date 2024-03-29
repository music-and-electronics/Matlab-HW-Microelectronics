%-Resistor-%
    R_b1  =100e3;
    R_b2  =160e3;
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
        I_B  =(V_bias-V_BE-V_E)/R_bias;             %Caculating Value of I_B from V_BE
        I_C  =I_B*beta;                              
        V_BE =V_t*log(I_C/I_s);                     %update V_BE from iterated I_C
        err  =err-V_BE;                             %err = V_BE-V_BE_new
    end
    V_B    =V_BE+V_E;                               %V_BE is V_B - V_E
    R_C_max=(V_cc-V_B)/I_C;                         %Rc is max when V_C = V_B

    disp(I_C); disp(V_B); disp(R_C_max);

%-Resistor-%
    R_c     =1e3;
    R_L     =4e3;
    R_src   =500;
    R_T     =P_Resistance(R_bias,R_src);           %value of thevenin equivalent resistance
%-Voltage-%
    V_A     =50;                                   %Early voltage
%-etc-%
    gm      =I_C/V_t;                              %transconductance
    r_o     =V_A/I_C;                              %Early Resistance
    r_pi    =beta/gm;
%-(b)-%
    R_in       =R_bias/(R_src+R_bias);               %value of input impedence
    %gain calculation in CE circuit
    V_divide   =r_pi/(r_pi+R_T);
    gain       =-gm*P_Resistance(R_c,R_L,r_o)*V_divide*R_in; 
    disp(gain);
        

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
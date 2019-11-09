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
        I_B  =(V_bias-V_BE-V_E)/R_bias;                 %Caculating Value of I_B from V_BE
        I_C  =I_B*beta;                              
        V_BE =V_t*log(I_C/I_s);                     %update V_BE from iterated I_C
        err  =err-V_BE;                             %err = V_BE-V_BE_new
    end
    
    V_B     =V_BE+V_E;                              %V_BE=V_B-V_E
    R_C_max =(V_cc-V_B)/I_C;                        %R_c is max when V_B=V_C

    disp(I_C); disp(V_B); disp(R_C_max);

%-Resistor-%
    R_c     =1e3;
    R_L     =10e3;
    R_src   =500;
    R_T     =P_Resistance(R_bias,R_src);
%-Voltage-%
    V_A     =50;
%-etc-%
    gm      =I_C/V_t;
    r_o     =V_A/I_C;
    r_pi    =beta/gm;
%-(b)-%
    R_x     =(R_bias/(R_bias+R_src));
    gain    =gm*(r_pi/(R_T+r_pi))/(r_o/P_Resistance(R_c,R_L)-1)*R_x;
    
    disp(gain);
%-(c)-%
    t       =[0:1e-10:3e-4]';
    freq    =10e3;
    V_in    =1e-3*sin(2*pi*freq.*t);
    V_c1    =gain*V_in;
    
    figure;
    plot(t,V_c1,'LineWidth',2);
    grid on
    title('The Plot Of Vc1');
    num     =3e-4;
    xlabel(['time[s] : 0<t<',num2str(num)],'fontsize',12);
    ylabel('Vc1[V]','fontsize',12);
    legend({'Vc1'},'Location','southwest');

%-(d)-%
    gain_taget  =-50;
    error_gain  =10;

    while(abs(error_gain)>abs(gain_taget/100))
        V_bias     =(R_b2/(R_b1+R_b2))*V_cc; 
        R_bias     =P_Resistance(R_b1,R_b2);
        I_B        =(V_bias-V_BE-V_E)/R_bias;  
        I_C        =I_B*beta;        
        V_BE       =V_t*log(I_C/I_s);           
        r_o        =V_A/I_C;
        gm         =I_C/V_t;
        r_pi       =beta/gm; 
        R_T        =P_Resistance(R_bias,R_src);
        R_x        =(R_bias/(R_bias+R_src));
        gain_cal   =gm*(r_pi/(R_T+r_pi))/(r_o/P_Resistance(R_c,R_L)-1)*R_x;
        error_gain =gain_cal-gain_taget;
        
        if error_gain>0 %if gain_target is larger than gain_cal
            R_b2 =R_b2+0.1; 
        else            %else if gain_cal is larger than gain target
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
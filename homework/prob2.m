clear all;
close all;

    Rb1  =100e3;
    Rb2  =100e3;
    Vcc  =4.0;
    Vt   =26e-3; 
    VE   =0.2;
    Is   =5e-16;
    etol =1e-7;
    beta  =100;   

%-(a)-%
    VBE   =0.7;                                    
    err    =etol+1;                                
    Vbias =(Rb2/(Rb1+Rb2))*Vcc;                
    Rbias =P_Resistance(Rb1,Rb2);              

    while (abs(err)>etol)           
        err  =VBE;                              
        IB  =(Vbias-VBE)/Rbias;              
        IC  =IB*beta;                              
        VBE =Vt*log(IC/Is);                    
        err  =err-VBE;                          
    end
    
    VB     =VBE+VE;
    RCmax =(Vcc-VB)/IC;                     
    Rc     =1e3;
    RL     =10e3;
    Rsrc   =500;
    RT     =P_Resistance(Rbias,Rsrc);
    VA     =50;
    gm      =IC/Vt;
    ro     =VA/IC;
%-(b)-%
    R_in    = Rbias/(Rsrc+Rbias);
    gain    =-(P_Resistance(Rc,RL,ro)/((1/gm)+RT/(1+beta)))*R_in;
    disp(gain);
%-(c)-%
    t       =[0:1e-10:3e-4]';
    freq    =10e3;
    Vin    =1e-3*sin(2*pi*freq.*t);
    Vc1    =gain*Vin;
    
    figure;
    plot(t,Vc1);

%-(d)-%
    gain  =-50;
    error  =100;

    while(abs(error)>abs(-0.5))
        Vbias     =(Rb2/(Rb1+Rb2))*Vcc; 
        Rbias     =P_Resistance(Rb1,Rb2);
        IB        =(Vbias-VBE)/Rbias;  
        IC        =IB*beta;        
        VBE       =Vt*log(IC/Is);           
        ro        =VA/IC;
        gm         =IC/Vt;        
        R_in       =Rbias/(Rsrc+Rbias);
        RT        =P_Resistance(Rbias,Rsrc);
        gainresult   =-(P_Resistance(Rc,RL,ro)/((1/gm)+RT/(1+beta)))*R_in;
        error =gainresult-gain;
        
        if error>0 
            Rb2 =Rb2+10; 
        else            
            Rb2 =Rb2-10;
        end

    end
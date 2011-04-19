function ds_dt= clin_model_2(t,y)

global Rav Rmv Rpv_F Rpv_R Rtriv Rcap Rvein Rlung_L Rlung_R Raor Laor Rart Lart Rvc Lvc Rpulart_L Rpulart_R;
global Lpulart_L Lpulart_R Rpulvein_L Rpulvein_R Lpulvein_L Lpulvein_R Caor Cart Ccap Cvein Cvc Cpulart_L;
global Cpulart_R Clung_L Clung_R Cpulvein_L Cpulvein_R;
global Eed_la Ees_la Eed_lv Ees_lv Eed_ra Ees_ra Eed_rv Ees_rv Lpma Rpma Cpma Ratrialres_L Ratrialres_R;

%Other Variables
HR=70;
f=HR/60;

%Name function y with state variables
Iaor=y(1);
Iart=y(2);
Ivc=y(3);

Ipulart_L=y(4); 
Ipulart_R=y(5);

Paor=y(6);
Part=y(7);
Pcap=y(8);
Pvein=y(9);
Pvc=y(10);

Ipulvein_L=y(11);
Ipulvein_R=y(12);

Ppulart_L=y(13);

Pla=y(14);
Plv=y(15);
Pra=y(16);
Prv=y(17);

Ppulart_R=y(18);

Plung_L=y(19);
Plung_R=y(20);
Ppulvein_L=y(21);
Ppulvein_R=y(22);

Ipma=y(23);
Ppulart=y(24);



%Variables needed for diff'l equations (7 equations)
%Old equations
Iav=max((Plv-Paor)/Rav, 0); %eq2
Imv=max((Pla-Plv)/Rmv, 0); %eq1
Ipv=Ipma;
Icap=(Pcap-Pvein)/Rcap; %eq5
Ivein=(Pvein-Pvc)/Rvein; %eq6
Itriv=max((Pra-Prv)/Rtriv,0); %eq8

%New Equations
%eq9, new pulmonary valve
%We know Ipv=Ipma 

if (Ipma>0)
    Ppma=Prv-Ipma*Rpv_F;
else
    Ppma=Prv-Ipma*Rpv_R;
end

%Newer Equations
Ipulart=Ipulart_L+Ipulart_R;

Ilung_L=(Ppulart_L-Plung_L)/Rlung_L;
Ilung_R=(Ppulart_R-Plung_R)/Rlung_R;

Iatrialres_L=(Ppulvein_L-Pla)/Ratrialres_L;
Iatrialres_R=(Ppulvein_L-Pla)/Ratrialres_R;

%Activation Functions
PR=195.36+(-0.384*HR);
PR=PR/(1000); %Convert from ms to sec
f=HR/60;
T=1/f;

%Elastance functions
%active=sine function
tmod=mod(t, 1/f);

if tmod<=(T/3)
        E_la=Eed_la+Ees_la*(sin(3*f*pi*tmod)); 
        Eprime_la=Ees_la*3*f*pi*(cos(3*pi*f*tmod));
    
        E_ra=Eed_ra+Ees_ra*(sin(3*pi*f*tmod));
        Eprime_ra=Ees_ra*3*f*pi*(cos(3*pi*f*tmod));
 
    else
        E_la=Eed_la;
        Eprime_la=0;
    
        E_ra=Eed_ra;
        Eprime_ra=0;
end    
   

if (tmod>PR) && (tmod<(PR+(T/3)))
        E_lv=(Eed_lv+Ees_lv*sin(3*f*pi*(tmod-PR)));
        Eprime_lv=(Ees_lv*3*f*pi*(cos(3*f*pi*(tmod-PR))));
 
        E_rv=(Eed_rv+Ees_rv*sin(3*f*pi*(tmod-PR)));
        Eprime_rv=(Ees_rv*3*f*pi*(cos(3*f*pi*(tmod-PR))));
    else
    
        E_lv=Eed_lv;
        Eprime_lv=0;  
     
        E_rv=Eed_rv;
        Eprime_rv=0;  
end 
   


%Differential Equations (5+8+4=17 equations)
dIaor_dt=((Paor-Part)-(Iaor*Raor))/Laor;%eq3
dIart_dt=((Part-Pcap)-(Iart*Rart))/Lart;%eq4
dIvc_dt=((Pvc-Pra)-(Ivc*Rvc))/Lvc;%eq7

dIpulart_L_dt=((Ppulart-Ppulart_L)-(Ipulart_L*Rpulart_L))/Lpulart_L;%eq10_L
dIpulart_R_dt=((Ppulart-Ppulart_R)-(Ipulart_R*Rpulart_R))/Lpulart_R;%eq10_R

dPaor_dt=(Iav-Iaor)/Caor;%eq15
dPart_dt=(Iaor-Iart)/Cart;%eq16
dPcap_dt=(Iart-Icap)/Ccap;%eq17
dPvein_dt=(Icap-Ivein)/Cvein;%eq18
dPvc_dt=(Ivein-Ivc)/Cvc;%eq19

dIpulvein_L_dt=((Plung_L-Ppulvein_L)-(Ipulvein_L*Rpulvein_L))/Lpulvein_L;%eq30
dIpulvein_R_dt=((Plung_R-Ppulvein_R)-(Ipulvein_R*Rpulvein_R))/Lpulvein_R;%eq30

dPpulart_L_dt=(Ipulart_L-Ilung_L)/Cpulart_L;%eq32,1

dPla_dt=((Eprime_la)*Pla/E_la)+(Iatrialres_L+Iatrialres_R-Imv)*E_la;%eq13-new!
dPlv_dt=((Eprime_lv)*Plv/E_lv)+(Imv-Iav)*E_lv;%eq14
dPra_dt=((Eprime_ra)*Pra/E_ra)+(Ivc-Itriv)*E_ra;%eq20
dPrv_dt=((Eprime_rv)*Prv/E_rv)+(Itriv-Ipv)*E_rv;%eq21

dPpulart_R_dt=(Ipulart_R-Ilung_R)/Cpulart_R;%eq32,2

dPlung_L_dt=(Ilung_L-Ipulvein_L)/Clung_L;%eq23
dPlung_R_dt=(Ilung_R-Ipulvein_R)/Clung_R;%eq23

dPpulvein_L_dt=(Ipulvein_L-Iatrialres_L)/Cpulvein_L;%eq35
dPpulvein_R_dt=(Ipulvein_R-Iatrialres_R)/Cpulvein_R;%eq35

dIpma_dt=((Ppma-Ppulart)-(Ipma*Rpma))/Lpma;%eq9.5,1
dPpulart_dt=((Ipma-Ipulart)/Cpma);%eq9.5,2


%Initialize differential matrix
ds_dt=[dIaor_dt;
    dIart_dt;
    dIvc_dt;
    dIpulart_L_dt;
    dIpulart_R_dt;
    dPaor_dt;
    dPart_dt;
    dPcap_dt;
    dPvein_dt;
    dPvc_dt;
    dIpulvein_L_dt;
    dIpulvein_R_dt;
    dPpulart_L_dt;
    dPla_dt;
    dPlv_dt;
    dPra_dt;
    dPrv_dt;
    dPpulart_R_dt;
    dPlung_L_dt;
    dPlung_R_dt;
    dPpulvein_L_dt;
    dPpulvein_R_dt;
    dIpma_dt;
    dPpulart_dt
    ];


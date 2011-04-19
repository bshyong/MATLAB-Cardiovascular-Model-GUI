function [yinit] = get_clinical_initial( )

%Due to activation functions, starting at 
Iaor_init=40;
Iart_init=10;
Ivc_init=30;
Ipulart_L_init=25;
Ipulart_R_init=25;

Paor_init=100; %guess
Part_init=25; %lidco.com
Pcap_init=1; %guess
Pvein_init=5; %guess
Pvc_init=1; 

Ipulvein_L_init=1;
Ipulvein_R_init=1;
Ppulart_L_init=20;

Pla_init=8;%lidco.com
Plv_init=15; %guess
Pra_init=4;%lidco.com
Prv_init=15;%lidco.com

Ppulart_R_init=20;

Plung_L_init=1;
Plung_R_init=1;
Ppulvein_L_init=11;
Ppulvein_R_init=11;

Ipma_init=50;
Ppulart_init=15;


yinit=[Iaor_init;
    Iart_init;
    Ivc_init;
    Ipulart_L_init;
    Ipulart_R_init
    Paor_init;
    Part_init;
    Pcap_init;
    Pvein_init;
    Pvc_init;
    Ipulvein_L_init;
    Ipulvein_R_init;
    Ppulart_L_init;
    Pla_init;
    Plv_init;
    Pra_init;
    Prv_init;
    Ppulart_R_init;
    Plung_L_init;
    Plung_R_init;
    Ppulvein_L_init;
    Ppulvein_R_init;
    Ipma_init;
    Ppulart_init;]';
end

%struct
%  load structs

%  Intermediate cardiac circuit

%  Component values

% VESSELS

        % ARTERIES

                    % AORTA
                            aortic_resistance = 0.2;%from Table 3, Mark I (.04)
                            aortic_inertance = .009;%from simple model (.009)
                            aortic_compliance = .85; %from simple model (.45)

                        aorta = struct('r', aortic_resistance, 'i', aortic_inertance, 'c', aortic_compliance);

                    % ARTERIOLES
                            arteriole_resistance = .62;%from Table 3, Mark I, %Mark II, pg 14 says should be 1.0
                            arteriole_inertance = 1.36*10^-06; %Rough calculation
                            arteriole_compliance = 1.55; %Mark II, pg 14 (=2.0-.45)

                        arterioles = struct('r', arteriole_resistance, 'i', arteriole_inertance, 'c', arteriole_compliance);

                    % PULMONARY ARTERY
                            %Left and Right Pulmonary Artery
                            pulmonary_artery_resistance_L = 0.08; %Mimick aorta w/ 2 in parallel
                            pulmonary_artery_resistance_R = 0.08; %Mimick aorta w/ 2 in parallel

                            pulmonary_artery_inertance_L = .018;%Mimick aorta
                            pulmonary_artery_inertance_R = .018;%Mimick aorta
                           
                            pulmonary_artery_compliance_L = 0.22;%Mimick aorta
                            pulmonary_artery_compliance_R = 0.22;%Mimick aorta
                            
                            %Main Pulmonary Artery
                            main_pulmonary_artery_resistance= 0.1;%prev 0.1
                            main_pulmonary_artery_inertance= .018;%prev .018
                            main_pulmonary_artery_compliance= 0.45;%prev 0.45

                        pulmonary_artery = struct('r_L', pulmonary_artery_resistance_L,'r_R', pulmonary_artery_resistance_R, 'r_main',main_pulmonary_artery_resistance,'i_L', pulmonary_artery_inertance_L, 'i_R', pulmonary_artery_inertance_R,'i_main',main_pulmonary_artery_inertance,'c_L', pulmonary_artery_compliance_L,'c_R', pulmonary_artery_compliance_R, 'c_main',main_pulmonary_artery_compliance);

            arteries = struct('aorta', aorta, 'arterioles', arterioles, 'pulmonary_artery', pulmonary_artery);

        % CAPILLARIES
                capillary_resistance = .27;%from Table 3, Mark I
                capillary_compliance = .001;%small. 

            capillaries = struct('r', capillary_resistance, 'c', capillary_compliance);

        % VEINS

                    % VENA CAVA
                            vena_cava_resistance = 0.015;%from Table 3, Mark I, also Roughly calculated (.018), and 
                            vena_cava_inertance = 0.002695;%Guess
                            vena_cava_compliance = 20;%Estimated from MarkII

                    vena_cava = struct('r', vena_cava_resistance, 'i', vena_cava_inertance, 'c', vena_cava_compliance);

                    % VENULES (and veins)
                        venule_resistance = .055;%from Table 3, Mark I
                        venule_compliance = 80; %from Mark II

                    venules = struct('r', venule_resistance, 'c', venule_compliance);

                    % PULMONARY VEIN
                        pulmonary_vein_resistance_L = .01;%Estimate
                        pulmonary_vein_resistance_R = .01;%Estimate
                        
                        pulmonary_vein_inertance_L = .002;%Guess
                        pulmonary_vein_inertance_R = .002;%Guess
                          
                        pulmonary_vein_compliance_L = 25;% GUess based on veins
                        pulmonary_vein_compliance_R = 25;% GUess based on veins
                        
                    %Entrance to Left Atrium
                        entrance_atrial_resistance_L=.01;
                        entrance_atrial_resistance_R=.01;
                  
                    left_atr_entrance=struct('r_L',entrance_atrial_resistance_L, 'r_R', entrance_atrial_resistance_R);


                    pulmonary_vein = struct('r_L', pulmonary_vein_resistance_L,'r_R', pulmonary_vein_resistance_R, 'i_L', pulmonary_vein_inertance_L,'i_R', pulmonary_vein_inertance_R, 'c_L', pulmonary_vein_compliance_L, 'c_R', pulmonary_vein_compliance_R);

            veins = struct('vena_cava', vena_cava, 'venules', venules, 'pulmonary_vein', pulmonary_vein, 'LA_entr', left_atr_entrance);

vessels = struct('arteries', arteries, 'capillaries', capillaries, 'veins', veins);

%  HEART
    
        %  VALVES
                mitral_valve_resistance = 0.008;
                atrioventricular_valve_resistance = 0.002;
                tricuspid_valve_resistance = 0.008;
                pulmonary_valve_resistance_forward = 0.002;
                pulmonary_valve_resistance_back=5;%new

            mitral_valve = struct('r', mitral_valve_resistance);
            atrioventricular_valve = struct('r', atrioventricular_valve_resistance);
            tricuspid_valve = struct('r', tricuspid_valve_resistance);
            pulmonary_valve = struct('r_F', pulmonary_valve_resistance_forward, 'r_R', pulmonary_valve_resistance_back);

        valves = struct('mitral', mitral_valve, 'atrioventricular', atrioventricular_valve, 'pulmonary', pulmonary_valve, 'tricuspid', tricuspid_valve);

        %  LEFT SIDE
        
                %VENTRICLE
                    left_ventricle_end_diastole_elastance=0.1;
                    left_ventricle_end_systole_elastance=4.3;%4.3 from Watrous

                %ATRIUM
                    left_atrium_end_diastole_elastance=0.04;
                    left_atrium_end_systole_elastance=0.2;
         

            left_ventricle = struct('Eed', left_ventricle_end_diastole_elastance, 'Ees',left_ventricle_end_systole_elastance);
            left_atrium = struct('Eed', left_atrium_end_diastole_elastance, 'Ees', left_atrium_end_systole_elastance);

        left_side = struct('ventricle', left_ventricle, 'atrium', left_atrium);

        %  RIGHT SIDE
                %VENTRICLE
                    right_ventricle_end_diastole_elastance=0.07;
                    right_ventricle_end_systole_elastance=0.55;%used to be .55, watrous

                %ATRIUM
                    right_atrium_end_diastole_elastance=0.04;
                    right_atrium_end_systole_elastance=0.2;
         

            right_ventricle = struct('Eed', right_ventricle_end_diastole_elastance, 'Ees',right_ventricle_end_systole_elastance);
            right_atrium = struct('Eed', right_atrium_end_diastole_elastance, 'Ees', right_atrium_end_systole_elastance);

        right_side = struct('ventricle', right_ventricle, 'atrium', right_atrium);
    
heart = struct('valves', valves, 'left', left_side, 'right', right_side);


 %  LUNGS
    %RESISTANCE
        
        lung_resistance_L = .0067;%from document sent by ben, %250 dynes sec/cm^5
        lung_resistance_R = .0067;
        
    %COMPLIANCE                           
         lung_compliance_L = .0005;%mimick capillaries
         lung_compliance_R = .0005;


 lungs = struct('r_L', lung_resistance_L, 'r_R', lung_resistance_R, 'c_L', lung_compliance_L, 'c_R', lung_compliance_R);
   

% declare variables according to struc names


global Rav Rmv Rpv_F Rpv_R Rtriv Rcap Rvein Rlung_L Rlung_R Raor Laor Rart Lart Rvc Lvc Rpulart_L Rpulart_R
global Lpulart_L Lpulart_R Rpulvein_L Rpulvein_R Lpulvein_L Lpulvein_R Caor Cart Ccap Cvein Cvc Cpulart_L 
global Cpulart_R Clung_L Clung_R Cpulvein_L Cpulvein_R
global Eed_la Ees_la Eed_lv Ees_lv Eed_ra Ees_ra Eed_rv Ees_rv Lpma Rpma Cpma Ratrialres_L Ratrialres_R

Rav = valves.atrioventricular.r;
Rmv = valves.mitral.r;
Rtriv = valves.tricuspid.r;
Rpv_F=valves.pulmonary.r_F;
Rpv_R=valves.pulmonary.r_R; %edited in GUI

Rcap = vessels.capillaries.r;
Rvein= vessels.veins.venules.r;
Rlung_L = lungs.r_L;
Rlung_R = lungs.r_R;

Raor = arteries.aorta.r;
Laor = arteries.aorta.i;
Rart = arteries.arterioles.r;
Lart = arteries.arterioles.i;
Rvc = vessels.veins.vena_cava.r;
Lvc = vessels.veins.vena_cava.i;
Rpulart_L = vessels.arteries.pulmonary_artery.r_L; %edited in GUI
Rpulart_R = vessels.arteries.pulmonary_artery.r_R;
Lpulart_L = vessels.arteries.pulmonary_artery.i_L;
Lpulart_R = vessels.arteries.pulmonary_artery.i_R;
Rpulvein_L = vessels.veins.pulmonary_vein.r_L;
Rpulvein_R = vessels.veins.pulmonary_vein.r_R;
Lpulvein_L = vessels.veins.pulmonary_vein.i_L;
Lpulvein_R = vessels.veins.pulmonary_vein.i_R;
Caor = vessels.arteries.aorta.c;
Cart = vessels.arteries.arterioles.c;
Ccap = vessels.capillaries.c;
Cvein = vessels.veins.venules.c;
Cvc = vessels.veins.vena_cava.c;
Cpulart_L = vessels.arteries.pulmonary_artery.c_L;
Cpulart_R = vessels.arteries.pulmonary_artery.c_R;
Clung_L = lungs.c_L;
Clung_R = lungs.c_R;
Cpulvein_L = vessels.veins.pulmonary_vein.c_L;
Cpulvein_R = vessels.veins.pulmonary_vein.c_R;

Lpma=vessels.arteries.pulmonary_artery.i_main;
Rpma=vessels.arteries.pulmonary_artery.r_main;
Cpma=vessels.arteries.pulmonary_artery.c_main;

Ratrialres_L=vessels.veins.LA_entr.r_L;
Ratrialres_R=vessels.veins.LA_entr.r_R;

Eed_la=heart.left.atrium.Eed;
Ees_la=heart.left.atrium.Ees;
Eed_lv=heart.left.ventricle.Eed;
Ees_lv=heart.left.ventricle.Ees;
Eed_ra=heart.right.atrium.Eed;
Ees_ra=heart.right.atrium.Ees;
Eed_rv=heart.right.ventricle.Eed;
Ees_rv=heart.right.ventricle.Ees;
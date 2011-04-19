%Wiggers Plot of Cardiac Cycle in Left Heart (Paor, Pla, Plv)
figure;
subplot(2,1,1);
plot(Tout(1000:end), Yout(1000:end,6), Tout(1000:end), Yout(1000:end,14), Tout(1000:end), Yout(1000:end,15));legend('Paor','Pla','Plv');

%Right Heart Cardiac Cycle (Ppma, Pra, Prv)
for i=1:length(Yout)
    if (Yout(i,23)>0)
        Ppma(i)=Yout(i,17)-Yout(i,23)*Rpv_F;
    else
        Ppma(i)=Yout(i,17)-Yout(i,23)*Rpv_R;
    
    end
end
 subplot(2,1,2)
 plot(Tout(1000:end), Ppma(1000:end), Tout(1000:end), Yout(1000:end,16), Tout(1000:end), Yout(1000:end,17));legend('Ppma','Pra','Prv');

 %Pressure Volume Curves
 %Left Atrium
 
 %solve: dV/dt=Iin-Iout for Iin=Iatrialres_L+Iatrialres_R and Iout=Imv,
 %with Vo=250 (guess)
 
 %Left Atrium
 Iatrialres_L=(Yout(:,21)-Yout(:,14))/Ratrialres_L;
 Iatrialres_R=(Yout(:,22)-Yout(:,14))/Ratrialres_R;
 Iin_LA=(Iatrialres_L+Iatrialres_R); 
 Iout_LA=max(((Yout(:,14)-Yout(:,15))/Rmv), 0);
 I_LA=Iin_LA-Iout_LA;
 
 %Left Ventricle
 Iin_LV=Iout_LA;
 Iout_LV=max((Yout(:,15)-Yout(:,6))/Rav, 0);
 I_LV=Iin_LV-Iout_LV;
 
 %Right Atrium
 Iin_RA=Yout(:,3);
 Iout_RA=max((Yout(:,16)-Yout(:,17))/Rtriv,0);
 I_RA=Iin_RA-Iout_RA;
 
 %Right Ventricle
 Iin_RV=Iout_RA;
 Iout_RV=Yout(:,23); 
 I_RV=Iin_RV-Iout_RV;
 
 %After 20 beats, choose 1 heartbeat (defined based on heart rate)
 T=60/70;
 A=find(Tout>(20*T)&Tout<(21*T));
 Tsmall=(Tout(A)-Tout(A(1)));
 
 Icut_LA=I_LA(A);
 Icut_LV=I_LV(A);
 Icut_RA=I_RA(A);
 Icut_RV=I_RV(A);

 for i=2:length(Tsmall)
     Volume_LA(1)=0;
     Volume_LV(1)=0;
     Volume_RA(1)=0;
     Volume_RV(1)=0;
     
     Volume_LA(i)=trapz(Tsmall(1:i), Icut_LA(1:i));
     Volume_LV(i)=trapz(Tsmall(1:i), Icut_LV(1:i));
     Volume_RA(i)=trapz(Tsmall(1:i), Icut_RA(1:i));
     Volume_RV(i)=trapz(Tsmall(1:i), Icut_RV(1:i));
 end
 
 %Add initial volumes
 Volume_LA=Volume_LA+40;
 Volume_LV=Volume_LV+120;
 Volume_RA=Volume_RA;
 Volume_RV=Volume_RV;
 
 Pressure_LA=Yout(A,14);
 Pressure_LV=Yout(A,15);
 Pressure_RA=Yout(A,16);
 Pressure_RV=Yout(A,17);
 
 figure;
 subplot(2,2,1)
 plot(Volume_LA,Pressure_LA, 'b.-')
 title('Left Atrium');
 
 subplot(2,2,2)
 plot(Volume_LV,Pressure_LV, 'b.-')
 title('Left Ventricle');

 subplot(2,2,3)
 plot(Volume_RA,Pressure_RA, 'b.-')
 title('Right Atrium');

 subplot(2,2,4)
 plot(Volume_RV,Pressure_RV, 'b.-')
 title('Right Ventricle');

 
 
 
 
 
 
 
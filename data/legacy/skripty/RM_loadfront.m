#!/usr/bin/octave -qf
function f=RM_loadfront(f)
	load(f.filename,"savaa");
	Beta=savaa(1,2:end);
	Pole=savaa(2:end,1);
	Voigt=1000*savaa(2:end,2:end);
	Voigt-=mean(Voigt);
	
	pocet=floor(numel(Pole)/2); %kolik hodnot phiH budu mít
	SPole=linspace(0,180,pocet+1)(1:end-1)'; %lineární
	
	%zde by bylo vhodne nejak namerene data nejak ucesat, aby to vzdycky vyslo spravne 
	extPole=[Pole-360;Pole;Pole+360];
	extVoigt=[Voigt;Voigt;Voigt];
	Voigt1=interp1(extPole,extVoigt,SPole);
	Voigt2=interp1(extPole,extVoigt,SPole+180);

  
  f.Beta=Beta;
  
	f.mer.Voigt=Voigt; %zmerene
	f.mer.Pole=Pole;

	f.red.Pole=SPole; %redukovane (linearni 0-180)
	f.red.Voigt=0.5*(Voigt1+Voigt2);
	f.red.antisymVoigt=0.5*(Voigt1-Voigt2);
endfunction
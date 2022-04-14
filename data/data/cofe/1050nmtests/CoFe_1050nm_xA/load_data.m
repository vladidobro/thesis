#!/usr/bin/octave -qf
function load_data()
	beta=[0 15 45 60 90 105 135 150];

	for i=1:numel(beta)
		data=load(sprintf("beta%03d/magnet.dat",beta(i)));
		data=data(:,[1,2,4]);
    
		data(:,2)=(data(:,2)-mean(data(:,2)))/2;
				
    
    	ncyklu=numel(data(:,2))/73;
    	if ncyklu!=round(ncyklu)
      		error("pocet sloupcu")
    	endif

    	V=data(1:73,2);
    	for j=2:ncyklu
    	  V+=data((1+73*(j-1)):(73*j),2);
    	endfor
    	V-=linspace(-0.5,0.5,73)'*(V(end)-V(1));
    	V/=ncyklu;
    
		Pole=data(1:73,1);

    V=0.5*(V(1:36)+V(37:72));
    V-=mean(V);
		Voigt(:,i)=V;

    Pole=0.5*(Pole(1:36)+Pole(37:72))-180;
	endfor
  magnet=[0, beta; Pole, Voigt];
  %savaa
  %imagesc(Voigt)
  save("1050_xA.dat","magnet")
endfunction
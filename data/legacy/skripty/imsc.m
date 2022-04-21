#!/usr/bin/octave -qf
function val=imsc(phi,beta,img,clim=NaN,zeroline=NaN) 
	load('bentcoolwarm.csv');
	bentcoolwarm=flipud(bentcoolwarm(:,2:4));
	colormap(bentcoolwarm)
	if isnan(clim)
		climits=[- max(max(abs(img))), max(max(abs(img)))];
	else
		climits=[-clim, clim];
	endif
	imagesc (phi,beta,-img',climits)
	colorbar
	xlabel("direction of external field")
	ylabel("polarization")
	if !isnan(zeroline) %zeroline jsou po radcich dvojice phi beta kde to ma byt nula, nakresli se i +-90

	endif
endfunction
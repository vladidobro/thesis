#!/usr/bin/octave -qf
function res=harmfit(beta,sig)
	resbeta=[0 15 45 60 90 105 135 150];
	F=[cosd(2*beta)' sind(2*beta)'];
	for i=1:rows(sig)
		fit=LinearRegression(F,sig(i,:)');
		par(i,:)=fit';
	endfor
	FF=[cosd(2*resbeta); sind(2*resbeta)];
	res=par*FF;
endfunction
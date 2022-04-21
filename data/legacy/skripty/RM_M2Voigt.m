#!/usr/bin/octave -qf
function Voigt=RM_M2Voigt(M,Beta)
  cc=cosd(2*Beta);
  ss=sind(2*Beta);
  Voigt=M(:,1)*cc+M(:,2)*ss;
endfunction
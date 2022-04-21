#!/usr/bin/octave -qf
function [P,phiM]=RM_M2Pphi(M,phiH)
  C=-M(:,2)+I*M(:,1);
  P=abs(C);
  phiM=rad2deg(0.5*angle(C));
  flipp=round((phiM-phiH)/90);
  P.*=(-1).^flipp;
  phiM-=90*flipp;
endfunction
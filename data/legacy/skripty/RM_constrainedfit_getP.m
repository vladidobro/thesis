#!/usr/bin/octave -qf
function P=RM_constrainedfit_getP(M,chi,a,b)
  P=sum((M-chi').*[a b],2);
endfunction
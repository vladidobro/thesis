#!/usr/bin/octave -qf
function [dsq, chi]=RM_constrainedfit(M,a,b)
  Mmes=sum(M.*[b,-a],2);
  Y=[b'*Mmes;-a'*Mmes];
  X=[b'*b, -a'*b; -b'*a, a'*a];
  chi=X\Y;
  Mfit=[b, -a]*chi;
  dsq=sum((Mmes-Mfit).^2);
endfunction
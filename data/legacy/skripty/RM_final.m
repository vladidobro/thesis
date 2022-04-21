#!/usr/bin/octave -qf
function f=RM_final(f)
  phiH=f.red.Pole;
  
  f.final.phiH=phiH;
  [f.final.P.free, f.final.phiM.free]=RM_M2Pphi(f.free.M, phiH);
  [f.final.P.zero, f.final.phiM.zero]=RM_M2Pphi(f.free.M-f.zero.Mchi, phiH);
  [f.final.P.given, f.final.phiM.given]=RM_M2Pphi(f.free.M-f.given.Mchi, phiH);
endfunction
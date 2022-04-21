#!/usr/bin/octave -qf
function g=RM_anisotropy_fit(f,phiM)
  a=sind(2*phiM);
  b=-cosd(2*phiM);
  [chyba, chi]=RM_constrainedfit(f.free.M,a,b);
  P=RM_constrainedfit_getP(f.free.M,chi,a,b);
  chiM=zeros(size(f.free.M))+chi';
  
  g.PMLD=P;
  g.phiM=phiM;
  g.MP=P.*[a b];
  g.Mchi=chiM;
endfunction
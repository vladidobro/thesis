#!/usr/bin/octave -qf
function f=RM_optimised_uhel_zero(f,dphi)
  %vypocet rozdilu mezi vztaznou soustavou magnetu a polarizace
  for i=1:numel(dphi)
    phiM=f(1).f.red.Pole+dphi(i);
    a=sind(2*phiM);
    b=-cosd(2*phiM);  
    
    for j=1:numel(f)
      [dsq chi]=RM_constrainedfit(f(j).f.free.M,a,b);
      ssq=sum(sumsq(RM_M2Voigt(f(j).f.free.M-chi',f(j).f.Beta)));
      
      f(j).f.uhel.zero.dsq(i,1)=dsq;  %total square deviation
      f(j).f.uhel.zero.ssq(i,1)=ssq;  %total square signal
    endfor
  endfor
  
  for j=1:numel(f)
    f(j).f.uhel.zero.ndsq=f(j).f.uhel.zero.dsq./f(j).f.uhel.zero.ssq;   %normalized total square deviation
    f(j).f.uhel.zero.dphi=dphi;
  endfor
endfunction
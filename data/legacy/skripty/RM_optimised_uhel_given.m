#!/usr/bin/octave -qf
function f=RM_optimised_uhel_given(f,anisotropy,dphi,dalfa)
  %vypocet rozdilu mezi vztaznou soustavou magnetu a polarizace
  for i=1:numel(dphi)
  for k=1:numel(dalfa)
    phiM=dphi(i)+interp1(anisotropy(:,1),anisotropy(:,2),f(1).f.red.Pole-dalfa(k))+dalfa(k);
    a=sind(2*phiM);
    b=-cosd(2*phiM);  
    
    for j=1:numel(f)
      [dsq chi]=ROTMOKE_constrainedfit(f(j).f.free.M,a,b);
      ssq=sum(sumsq(ROTMOKE_M2Voigt(f(j).f.free.M-chi',f(j).f.Beta)));
      
      f(j).f.uhel.given.dsq(i,k)=dsq;  %total square deviation
      f(j).f.uhel.given.ssq(i,k)=ssq;  %total square signal
    endfor
  endfor
  endfor
  
  for j=1:numel(f)
    f(j).f.uhel.given.ndsq=f(j).f.uhel.given.dsq./f(j).f.uhel.given.ssq;   %normalized total square deviation
    f(j).f.uhel.given.dphi=dphi;
    f(j).f.uhel.given.dalfa=dalfa;
  endfor
endfunction
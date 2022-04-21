#!/usr/bin/octave -qf
function plot_full(f)
lambda=sprintf("%4d nm", f.wavelength);
fil=sprintf("%04d", f.wavelength);

pole=f.red.Pole;

Vmes=f.red.Voigt;
Vfree=ROTMOKE_M2Voigt(f.free.M,f.Beta);
Vzero=ROTMOKE_M2Voigt(f.zero.MP+f.zero.Mchi,f.Beta);
Vgiven=ROTMOKE_M2Voigt(f.given.MP+f.given.Mchi,f.Beta);

figure(5)
for i=1:columns(Vmes)
  plot(pole,Vmes(:,i),pole,Vfree(:,i),pole,Vzero(:,i),pole,Vgiven(:,i))
  legend({"measured","free fit","zero anisotropy","given anisotropy"})
  title(strcat(lambda,sprintf(", polarisation %03d",f.Beta(i))))
  xlabel("external magnetic field direction (205mT)")
  ylabel("signal")
  %print(strcat("out/full/",fil,sprintf("%03d.png",f.Beta(i))))
endfor


  
endfunction
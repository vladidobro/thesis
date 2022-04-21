#!/usr/bin/octave -qf
function plot_given(f)
lambda=sprintf("%4d nm", f.wavelength);
fil=sprintf("%04d", f.wavelength);


figure(4)
  subplot(2,2,2)
    imsc(f.red.Pole,f.Beta,ROTMOKE_M2Voigt(f.given.MP,f.Beta))
    colorbar
    title("given anisotropy fit")

  subplot(2,2,1)
    imsc(f.red.Pole,f.Beta,f.red.Voigt-ROTMOKE_M2Voigt(f.given.Mchi,f.Beta))
    colorbar
    title(strcat(lambda," - measured"))

  subplot(2,2,3)
    imsc(f.red.Pole,f.Beta,f.red.Voigt-ROTMOKE_M2Voigt(f.given.MP+f.given.Mchi,f.Beta))
    colorbar
    title("error (measured minus fitted)")
    
%print(strcat("out/heatmapy/",fil,"_given.png"))


endfunction
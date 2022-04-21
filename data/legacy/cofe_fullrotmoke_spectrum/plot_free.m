#!/usr/bin/octave -qf
function plot_free(f)
lambda=sprintf("%4d nm", f.wavelength);
fil=sprintf("%04d", f.wavelength);

lambda="1050 nm NEW";
fil="1050_new";

figure(2)
  subplot(2,2,2)
    imsc(f.red.Pole,f.Beta,ROTMOKE_M2Voigt(f.free.M,f.Beta))
    colorbar
    title("fourfold symmetry fit (harmonic fit, zero mean)")

  subplot(2,2,1)
    imsc(f.red.Pole,f.Beta,f.red.Voigt)
    colorbar
    title(strcat(lambda," - measured"))

  subplot(2,2,3)
    imsc(f.red.Pole,f.Beta,f.red.Voigt-ROTMOKE_M2Voigt(f.free.M,f.Beta))
    colorbar
    title("error (measured minus fitted)")
    
%print(strcat("out/heatmapy/",fil,"_free.png"))




endfunction
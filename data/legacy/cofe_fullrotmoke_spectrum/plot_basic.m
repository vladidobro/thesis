#!/usr/bin/octave -qf
function plot_basic(f)
lambda=sprintf("%4d nm", f.wavelength);
fil=sprintf("%04d", f.wavelength);

lambda="1050 nm NEW";
fil="1050_new";

figure(1)
  subplot(2,2,1:2)
    imsc([0 360],f.Beta,f.mer.Voigt)
    colorbar
    title(strcat(lambda,"- measured raw data (minus linear function)"))

  subplot(2,2,3)
    imsc(f.red.Pole,f.Beta,f.red.Voigt)
    colorbar
    title("symmetic in M")
    
  subplot(2,2,4)
    imsc(f.red.Pole,f.Beta,f.red.antisymVoigt)
    colorbar
    title("antisymmetic in M")
    
%print(strcat("out/heatmapy/",fil,"_measured.png"))



endfunction
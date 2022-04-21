#!/usr/bin/octave -qf
function f=RM_freefit(f)
	
  cc=cosd(2*f.Beta);
  ss=sind(2*f.Beta);
  
  M=f.red.Voigt*[cc'/(cc*cc'), ss'/(ss*ss')];  %zjisti se fourierovy koeficienty

  f.free.M=M;
  f.free.funccc=cc;
  f.free.funcss=ss;
 endfunction
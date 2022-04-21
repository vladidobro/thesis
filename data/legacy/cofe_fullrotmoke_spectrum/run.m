#!/usr/bin/octave -qf


%init
lambda=[405; 530; 620; 1050; 1200; 1450];
for i=1:numel(lambda)
	f(i).f.wavelength=lambda(i);
	f(i).f.filename=sprintf("data/%04d.dat",lambda(i));
endfor

%nahrani dat
for i=1:numel(f)
	f(i).f=ROTMOKE_loadfront(f(i).f);
endfor

%fit s neznamou anizotropii (volnou)
for i=1:numel(f)
	f(i).f=ROTMOKE_freefit(f(i).f);
endfor


load("anisotropy.dat","anisotropy")
anisotropy_given=[anisotropy(1:end-1,:)-360; anisotropy];
%urceni natoceni vzorku a offset os
if false
    dphi_zero=[(-10:0.5:-3)';(-3:0.05:3)';(3:0.5:10)'];
    f=ROTMOKE_optimised_uhel_zero(f,dphi_zero);  %funguje jen kdyz vsechny vlnove delky maji stejne hodnoty pole a polarizace

    dphi_given=[(-10:0.01:10)'];
    dalfa_given=(70:1:110);

    f=ROTMOKE_optimised_uhel_given(f,anisotropy_given,dphi_given,dalfa_given); %tohle taky jen kdyz stejne. nutne upravit skript, pokud to tak neni
endif
%nakresleni zavislosti chyby na natoceni vzorku a offsetu os
if false
    plot_uhel(f)
    pause
endif
%urcil jsem dphi=1.5, dalfa=90


%fit se znamou anizotropii
for i=1:numel(f)
	f(i).f.zero=ROTMOKE_anisotropy_fit(f(i).f,f(i).f.red.Pole+0); %fit s nulovou anizotropii, tj phiM=phiH  (+1.5deg)
  f(i).f.given=ROTMOKE_anisotropy_fit(f(i).f,0+interp1(anisotropy_given(:,1),anisotropy_given(:,2),f(i).f.red.Pole-90)+90); %fit s cinskou anizotropii
endfor


%nakresleni kazde vlnove delky
if false
  for i=f
    disp(i.f.wavelength)
    plot_basic(i.f) %1 2 3
    plot_free(i.f)  %4 5
    plot_zero(i.f)  %6 7 8
    plot_given(i.f) %9 10 11
  endfor
endif
if false
  for i=f
    plot_full(i.f)
  endfor
endif


%najit P a phiM a ulozit
for i=1:numel(f)
  f(i).f=ROTMOKE_final(f(i).f);
endfor
phiH=f(1).f.red.Pole;
for i=1:numel(f)
  Pfree(:,i)=f(i).f.final.P.free;
  Pzero(:,i)=f(i).f.final.P.zero;
  Pgiven(:,i)=f(i).f.final.P.given;
  phiMfree(:,i)=f(i).f.final.phiM.free;
  phiMzero(:,i)=f(i).f.final.phiM.zero;
  phiMgiven(:,i)=f(i).f.final.phiM.given;
endfor

#{
for i=1:numel(f)
  plot(phiMgiven(:,i),Pgiven(:,i))
  hold on
endfor
hold off
legend({"405","530","620","1050","1200","1450"})
xlabel("magnetization direction")
ylabel("PMLD")
title("PMLD - given anisotropy fit")
#}


for i=1:numel(f)
  plot(phiH,phiMgiven(:,i)-phiH)
  hold on
endfor
plot(anisotropy(1:floor(rows(anisotropy)/2),1),anisotropy(1:floor(rows(anisotropy)/2),2)-anisotropy(1:floor(rows(anisotropy)/2),1))
hold off
legend({"405","530","620","1050","1200","1450","given"})
xlabel("external field direction")
ylabel("phiM-phiH")
title("phiM - given anisotropy fit")

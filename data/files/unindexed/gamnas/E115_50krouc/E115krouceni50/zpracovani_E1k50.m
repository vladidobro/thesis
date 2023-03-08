#!/usr/bin/octave -qf

clear

m=zeros(73,13);	 																	#73 hodnot uhlu, 12 uhlu polarizace
p=zeros(73,13);				


polarizace=(0:15:165)';																	#seznam polarizaci ktery merim


for pol=0:11
	data=load(sprintf("E115_50_b%03d.dat",pol*15)); 									#krok 15 polarizace
	out=zeros(73,2);
	howmany=round(size(data,1)/73)
	for i=1:73
		for j=0:(howmany-1)																		#5 projeti krivky
			out(i,1)+=data(i+j*73,2); 													#2 sloupec A-B
			out(i,2)+=data(i+j*73,4);													#4 sloupec A+B
		endfor
	endfor
	out/=howmany;																				#prumer...
	m(:,pol+2)=out(:,1);
	p(:,pol+2)=out(:,2);
	if pol==0
		uhly=data(1:73,1);
	endif																		
endfor																					#seznam

m(:,1)=uhly;
p(:,1)=uhly;

for pol=0:11
	m(:,pol+2)-=mean(m(:,pol+2));													#posunuti
	m(:,pol+2)/=mean(p(:,pol+2));											#mrad
	p(:,pol+2)/=mean(p(:,pol+2));
endfor

M=[polarizace, m(:,2:13)'];
P=[polarizace, p(:,2:13)'];

clear i j data out pol

save("out/E115_k50_V_vspol.dat", 'm', '-ascii')
save("out/E115_k50_M_vspol.dat", 'p', '-ascii')
save("out/E115_k50_V_vsmag.dat", 'M', '-ascii')
save("out/E115_k50_M_vsmag.dat", 'P', '-ascii')
#!/usr/bin/octave -qf

load_data
load("1050_xA.dat","magnet")
beta=magnet(1,2:end);
mag=magnet(2:end,1);
signal=magnet(2:end,2:end);

load_polar

Gpsi=gpsi(1,:);

corrA=sqrt(max(1,1./abs(A(1,:)).^2)-1);
corrB=sqrt(max(1,1./abs(B(1,:)).^2)-1);
corrD=sqrt(1-abs(D(2,:)).^2);
Uchi=sqrt(corrA.*corrB)./corrD;
Uerr=[corrA; corrB]./corrD;
Schi=[1 1 1 1 1 1 1 1]; %nezajímá mě pokud chci elipticitu jenom filtrovat

Gchi=abs(Gpsi).*Uchi.*Schi;

disp("beta; psi; chi")
[beta; Gpsi; Gchi]


corrSignal(:,1)=(Gchi(5)*signal(:,1)+Gchi(1)*signal(:,5))/(Gpsi(1)*Gchi(5)-Gpsi(5)*Gchi(1));
corrSignal(:,2)=(Gchi(6)*signal(:,2)+Gchi(2)*signal(:,6))/(Gpsi(2)*Gchi(6)-Gpsi(6)*Gchi(2));
corrSignal(:,3)=signal(:,3)/Gpsi(3);
corrSignal(:,4)=(Gchi(8)*signal(:,4)+Gchi(4)*signal(:,8))/(Gpsi(4)*Gchi(8)-Gpsi(8)*Gchi(4));
corrSignal(:,5)=-corrSignal(:,1);
corrSignal(:,6)=-corrSignal(:,2);
corrSignal(:,7)=signal(:,7)/Gpsi(7);
corrSignal(:,8)=-corrSignal(:,4);


clf
hold on
for i=1:8
	plot(mag,corrSignal(:,i))
endfor
hold off


CORRSIGNAL1=harmfit(beta([1 2 4 5 6 8]),corrSignal(:,[1 2 4 5 6 8]));
CORRSIGNAL2=harmfit(beta,corrSignal);


%pause
for i=1:8
	%plot(mag,corrSignal(:,i),...
	%	mag,CORRSIGNAL1(:,i),...
	%	mag,CORRSIGNAL2(:,i))
	%pause
endfor

CORRECT=CORRSIGNAL1(:,[1,3]);

load("../data/cofe1050_x2.dat","savaa")

xbeta=savaa(1,2:end);
xpole=mag;
xvoigt=savaa(2:end,2:end);
xvoigt=0.5*(xvoigt(1:36,:)+xvoigt(37:72,:));

PREV(:,1)=0.5*(0.5*(0.5*(xvoigt(:,1)+xvoigt(:,9))+xvoigt(:,5))-0.5*(xvoigt(:,3)+xvoigt(:,7)));
PREV(:,2)=0.5*(0.5*( xvoigt(:,2)+xvoigt(:,6) )-0.5*( xvoigt(:,4)+xvoigt(:,8) ));

propconst=LinearRegression(CORRECT(:),PREV(:))

figure(1)
plot(mag,PREV(:,1),mag,propconst*CORRECT(:,1))
xlabel("H ext")
ylabel("polarization rotation")
title("beta=0deg")
legend("bez zrcadel IR2","nova korekce")
print("nova000.png")
figure(2)
plot(mag,PREV(:,2),mag,propconst*CORRECT(:,2))
xlabel("H ext")
ylabel("polarization rotation")
title("beta=45deg")
legend("bez zrcadel IR2","nova korekce")
print("nova045.png")

novakorekce=[0,[0 45];mag,propconst*CORRECT];
save("cofe1050_xA.dat","novakorekce")
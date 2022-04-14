#!/usr/bin/octave -qf

addpath('/home/wohlrath/octave/optim-1.6.0')

zesileni=100;
beta=[0 15 45 60 90 105 135 150];

for i=1:numel(beta)

	clear sens
	full=csvread(sprintf("beta%03d/full.csv",beta(i)));
	full=full(2:end,2:end); #beta, A, B, A-B, A+B

	sens=csvread(sprintf("beta%03d/sens.csv",beta(i)));
	sens_aux=sens(2:end,[2 4 5]); #beta, A-B theta, A+B
	sens=sens(2:end,2:3); #beta, A-B x


	[fit, ~, ~, err, ~] = LinearRegression([sens(:,1),ones(rows(sens),1)], sens(:,2));
	gpsi(:,i)=[fit(1); err(1)];

	F=[ones(rows(full),1), cosd(2*full(:,1)), sind(2*full(:,1))];
	#lab={"A","B","A-B","A+B"};
	for j=1:4
	  [fit, ~, ~, err, ~]=LinearRegression(F,full(:,j+1));
	  fitt(:,j)=fit;
	  errr(:,j)=err;
	  #plot(full(:,1),full(:,j+1),'o',full(:,1),F*fit,'-')
	  #xlabel(lab{j})
	  #title(beta(i))
	  #pause
	endfor
	
	A(:,i)=[(fitt(2,1)-I*fitt(3,1)); max(errr(2,1),errr(3,1))]/fitt(1,1);
	B(:,i)=[(fitt(2,2)-I*fitt(3,2)); max(errr(2,2),errr(3,2))]/fitt(1,2);
	D(:,i)=[fitt(2,3)-I*fitt(3,3); fitt(1,3)]/abs(fitt(2,3)-I*fitt(3,3));

endfor

#errorbar(beta,abs(gpsi(1,:)),gpsi(2,:))

\begin{asy}
settings.outformat="pdf";
settings.prc=false;
settings.render=16; 
import three; 
size(5cm,0);

draw(-1.5X -- 1.5X, arrow=Arrow3(TeXHead2), L=Label("$s_1$", position=EndPoint,align=S));
draw(-1.5Y -- 1.5Y, arrow=Arrow3(TeXHead2), L=Label("$s_2$", position=EndPoint,align=S));
draw(-1.2Z -- 1.2Z, arrow=Arrow3(TeXHead2), L=Label("$s_3$", position=EndPoint,align=W));

draw(unitsphere, surfacepen = material(white+opacity(0.3), emissivepen = gray(0.2)));

real delta=20;
real theta=30;

real gamma=atan(Tan(delta)*Sin(theta))*180/pi;
real beta=atan(Tan(theta)/Cos(delta))*180/pi;

path3 uncirc=circle(c=O, r=1, normal=Z);

draw(uncirc,gray+dashed); 

transform3 pol=rotate(angle=delta, u=O, v=X);
transform3 kov=rotate(angle=theta, u=O, v=Z);

triple prusgam=(Cos(gamma), 0, Sin(gamma));
triple prusbet=(Cos(beta),Sin(beta), 0);
triple prus = pol*prusbet;
dot(pol*prusbet);

real len=0.5;

draw(prus -- prus+pol*rotate(angle=90, u=O, v=Z)*(len*prusbet), blue, arrow=Arrow3(), L=Label("$\textrm{d}\beta$", p=black, position=EndPoint,align=E));
draw(prus -- prus+pol*(len*Z), blue, arrow=Arrow3(), L=Label("$\textrm{d}\chi$", p=black, position=EndPoint,align=W));
draw(prus -- prus+kov*(len*Y), red ,arrow=Arrow3(), L=Label("$\textrm{d}U_\textrm{A-B}$", p=black , position=EndPoint,align=S));



draw(pol*uncirc, blue+dashed);
draw(kov*circle(c=O, r=1, normal=Y), red);

label("(a)",(1,0,1.2),align=W);

\end{asy}

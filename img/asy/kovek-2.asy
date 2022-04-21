\begin{asy}
settings.outformat="pdf";
settings.prc=false;
settings.render=16; 
import three; 
size(3cm,0);

draw(-1.5X -- 1.5X, arrow=Arrow3(TeXHead2), L=Label("$s_1$", position=EndPoint,align=S));
draw(-1.5Y -- 1.5Y, arrow=Arrow3(TeXHead2), L=Label("$s_2$", position=EndPoint,align=S));
draw(-1.2Z -- 1.2Z, arrow=Arrow3(TeXHead2), L=Label("$s_3$", position=EndPoint,align=W));

draw(unitsphere, surfacepen = material(white+opacity(0.3), emissivepen = gray(0.2)));

real ang=45;
real len=0.5;

draw(circle(c=O, r=1, normal=Z),gray+dashed); 

draw(circle(c=O, r=1, normal=X), red); 

dot(Y);
dot(-Y);
dot(Z);
dot(-Z);

draw(O -- -1X, red+linewidth(1pt), arrow=Arrow3());

label("(a)",(1,0,1.2),align=W);

\end{asy}

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

real ang=30;
real len=0.5;

draw(circle(c=O, r=1, normal=Z),gray+dashed); 


draw(surface(O -- (-Cos(ang),Sin(ang),0), c=O, axis=X), surfacepen = material(green+opacity(0.7)) );
draw(circle(c=-Cos(ang)*X, r=Sin(ang), normal=X),black+dashed); 
dot((-Cos(ang),Sin(ang),0));
dot((-Cos(ang),-Sin(ang),0));

draw(surface(O -- (0,1,0), c=O, axis=X), surfacepen = material(red+opacity(0.3), emissivepen=red));
draw(circle(c=O, r=1, normal=X),black+dashed); 
dot(Y);
dot(-Y);
dot(Z);
dot(-Z);
\end{asy}

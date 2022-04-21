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

real z=30;
real zz=20;
real len=0.8;

path3 uncirc=circle(c=O, r=1, normal=Z);

transform3 rovina=rotate(angle=z, u=O, v=Z);
transform3 cela=rovina*rotate(angle=zz, u=O, v=X);

triple u=rovina*X;
triple v=rovina*Y;
triple w=cela*Y;
draw(uncirc,gray+dashed); 

draw(O -- u ^^ O -- v ^^ O -- w);

path3 uh1=O -- arc(O, len*X, u) -- cycle;
path3 uh2=O -- arc(O, len*v, w) -- cycle;

draw(uh1);
draw(uh2);
draw(surface(uh1), surfacepen = material(emissive(green+opacity(0.8))));
draw(surface(uh2), surfacepen = material(emissive(blue+opacity(0.8))));

draw(O -- cela*Z, red+linewidth(1pt), arrow=Arrow3());

draw(cela*uncirc, red); 


\end{asy}

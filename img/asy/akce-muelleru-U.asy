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

real ang=45;
real len=0.5;

draw(circle(c=O, r=1, normal=Z),gray+dashed); 

draw(circle(c=O, r=1, normal=(0,-Sin(ang),Cos(ang))),dashed); 

triple P=(0,Cos(ang),Sin(ang));
path3 uhel=O -- arc(O,len*Y,P) -- cycle;
draw(uhel,L=Label("$\delta'$",align=(-0.2,0)));
draw(surface(uhel), surfacepen = material(emissive(green+opacity(0.9))));
draw(O -- P, dashed);

real[] x={0.93, 0.75,0,-0.8};
for(int i=0; i<x.length; ++i){
    draw(arc((x[i],0,0),(x[i],sqrt(1-x[i]**2),0),(x[i],Cos(ang),Sin(ang))),arrow=Arrow3(TeXHead2));
}

dot(X,L=Label("$\mathcal{J}_1$",align=N+(-0.25,0)));


label("(a)",(1,0,1.2),align=W);

\end{asy}

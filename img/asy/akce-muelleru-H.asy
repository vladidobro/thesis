\begin{asy}
settings.outformat="pdf";
settings.prc=false;
settings.render=16; 
import three; 
size(5cm,0);

draw(-1.5X -- 1.5X, arrow=Arrow3(TeXHead2), L=Label("$s_1$", position=EndPoint,align=S));
draw(-1.5Y -- 1.5Y, arrow=Arrow3(TeXHead2), L=Label("$s_2$", position=EndPoint,align=S));
draw(-1.2Z -- 1.2Z, arrow=Arrow3(TeXHead2), L=Label("$s_3$", position=EndPoint,align=W));

real[] eta={1,0.5,0.1};
material[] p={material(white+opacity(0.3)),material(green+opacity(0.3)),material(red+opacity(0.3))};
for(int i=0; i<eta.length; ++i){
    transform3 sc=shift((1-eta[i]**2)/2,0,0)*scale((1+eta[i]**2)/2,eta[i],eta[i]);
    draw(sc*unitsphere, surfacepen = p[i]);
    draw(sc*circle(c=O,r=1, normal=Z),dashed);
}

label("(b)",(1,0,1.2),align=W);

label("$\eta=1$",(0,1,1.3),align=E);
label("$\eta=0,5$",(0,1,1),green,align=E);
label("$\eta=0,1$",(0,1,0.7),red,align=E);

dot(X,L=Label("$\mathcal{J}_1$"),align=S);

\end{asy}

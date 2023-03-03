settings.outformat="pdf";
settings.prc=false;
settings.render=16; 
import three; 
size(3cm,0);

draw(-1.5X -- 1.5X, arrow=Arrow3(TeXHead2), L=Label("$s_1$", position=EndPoint,align=S));
draw(-1.5Y -- 1.5Y, arrow=Arrow3(TeXHead2), L=Label("$s_2$", position=EndPoint,align=S));
draw(-1.2Z -- 1.2Z, arrow=Arrow3(TeXHead2), L=Label("$s_3$", position=EndPoint,align=W));

draw(unitsphere, surfacepen = material(white+opacity(0.3), emissivepen = gray(0.2)));

real ang=67;
triple P=(-Cos(ang),-Sin(ang),0);
triple Q=(-Sin(ang),Cos(ang),0);

draw(circle(c=O, r=1, normal=Z),gray+dashed); 

draw(circle(c=O, r=1, normal=P), red); 

dot(Q);
dot(-Q);
dot(Z);
dot(-Z);

draw(O -- P, red+linewidth(1pt), arrow=Arrow3());

real len=0.7;
path3 uhel=O -- arc(O,len*Q,Y) -- cycle;

draw(O -- Q);
draw(uhel);
draw(surface(uhel), surfacepen = material(emissive(green+opacity(0.9))));

label("(b)",(1,0,1.2),align=W);


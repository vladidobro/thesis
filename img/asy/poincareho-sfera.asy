settings.outformat="pdf";
settings.prc=false;
settings.render=16; 
import three; 
size(5cm,0);

draw(-1.5X -- 1.5X, arrow=Arrow3(TeXHead2), L=Label("$s_1$", position=EndPoint,align=S));
draw(-1.5Y -- 1.5Y, arrow=Arrow3(TeXHead2), L=Label("$s_2$", position=EndPoint,align=S));
draw(-1.2Z -- 1.2Z, arrow=Arrow3(TeXHead2), L=Label("$s_3$", position=EndPoint,align=W));

draw(unitsphere, surfacepen = material(white+opacity(0.3), emissivepen = gray(0.2)));
draw(circle(c=(0,0,0), r=1, normal=Z),dashed); 
dot(Z ^^ -Z);

triple P = (sin(pi/2*0.6)*cos(pi/2*0.8),sin(pi/2*0.6)*sin(pi/2*0.8),cos(pi/2*0.6));
triple Pp = (P.x,P.y,0);
dot(P);
draw(O -- Pp -- P -- cycle);

real rat=1;

draw(surface(O -- arc(O,rat*Pp,X) -- cycle), surfacepen = material(blue+opacity(0.7)));
draw(arc(O,rat*Pp,X),L=Label("$2\beta$",align=(0,0.12)));

draw(surface(O -- arc(O,rat*Pp,P) -- cycle), surfacepen = material(blue+opacity(0.7)));
draw(arc(O,rat*Pp,P),L=Label("$2\chi$",align=(-0.6,-0.1)));



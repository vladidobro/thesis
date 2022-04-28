\begin{asy}
settings.outformat="pdf";
settings.prc=false;
settings.render=16; 
import three; 
size(3cm,0);


draw(X -- O, red+linewidth(1pt), arrow=Arrow3());
draw(O -- Z, red+linewidth(1pt), arrow=Arrow3());
draw(Z -- Z+Y, red+linewidth(1pt), arrow=Arrow3());

real l=0.2;

path3 zr1 = l*(X-Y-Z) -- l*(X+Y-Z) -- l*(-X+Y+Z) -- l*(-X-Y+Z) -- cycle;
path3 zr2 = Z+l*(X+Y+Z) -- Z+l*(-X+Y+Z) -- Z+l*(-X-Y-Z) -- Z+l*(+X-Y-Z) -- cycle; 

path3 bok1 = l*(X+Y-Z) -- l*(-X+Y+Z) -- l*(-X+Y-Z) -- cycle;
path3 bok2 = Z+l*(X+Y+Z) -- Z+l*(+X-Y-Z) -- Z+l*(X-Y+Z) -- cycle;
path3 stena2 = Z+l*(X+Y+Z) -- Z+l*(-X+Y+Z) -- Z+l*(-X-Y+Z) -- Z+l*(+X-Y+Z) -- cycle;

draw(surface(zr1), surfacepen = material(emissive(grey))  );
draw(surface(zr2), surfacepen = material(emissive(grey))  );

draw(zr1);
draw(zr2);
draw(bok1);
draw(bok2);
draw(stena2);


draw(surface(bok1), surfacepen = material(emissive(grey)));
draw(surface(bok2), surfacepen = material(emissive(grey)));

draw(surface(stena2), surfacepen = material(emissive(grey)));


label("(b)",(0.5,0,1.2),align=W);
\end{asy}

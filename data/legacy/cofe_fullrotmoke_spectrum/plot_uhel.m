#!/usr/bin/octave -qf
function plot_uhel(f)
  
  figure(1) 
  zero1(:,1)=f(1).f.uhel.zero.dphi;
  for i=1:numel(f)
    zero1(:,i+1)=sqrt(f(i).f.uhel.zero.ndsq);
    plot(zero1(:,1),zero1(:,i+1))
    hold on
    leg{i}=sprintf("%d nm",f(i).f.wavelength);
  endfor
  hold off
  legend(leg,"location","southwest")
  legend boxoff
  xlabel("nominal phiM=0 in polarisation coordinates")
  ylabel("mean square error/mean square signal")
  title("zero anisotropy fit - offset between magnet and polarisation coordinates")
  %print("out/uhly/zero1.png")
  %save("out/uhly/zero1.dat","zero1")
  
  
  figure(2) 
  given1(:,1)=f(1).f.uhel.given.dphi;
  [~,iw]=min(abs(f(i).f.uhel.given.dalfa-90));
  for i=1:numel(f)
    given1(:,i+1)=sqrt(f(i).f.uhel.given.ndsq(:,iw));
    plot(given1(:,1),given1(:,i+1))
    hold on
    leg{i}=sprintf("%d nm",f(i).f.wavelength);
  endfor
  hold off
  legend(leg,"location","southwest")
  legend boxoff
  xlabel("nominal phiM=0 in polarisation coordinates")
  ylabel("mean square error/mean square signal")
  title("given anisotropy fit - magnet-polarisation offset (for 90deg sample orientation)")
  %print("out/uhly/given1.png")
  %save("out/uhly/given1.dat","given1")
  
  
  figure(3)
  given2(:,1)=(f(1).f.uhel.given.dalfa)';
  for i=1:numel(f)
    given2(:,i+1)=(sqrt(min(f(i).f.uhel.given.ndsq)))';
    plot(given2(:,1),given2(:,i+1))
    hold on
  endfor
  hold off
  legend(leg,"location","northeast")  
  legend boxoff
  xlabel("sample [100] in magnet coordinates (set to c. 90 manually)")
  ylabel("mean square error/mean square signal (for best magnet-polarisation offset)")
  title("given anisotropy fit - orientation of sample")
  %print("out/uhly/given2.png")
  %save("out/uhly/given2.dat","given2")
  
  
  figure(4)
  given3(:,1)=(f(1).f.uhel.given.dalfa)';
  for i=1:numel(f)
    [~,iw]=min(f(i).f.uhel.given.ndsq);
    given3(:,i+1)=(f(i).f.uhel.given.dphi(iw))';
    plot(given3(:,1),given3(:,i+1))
    hold on
  endfor
  hold off
  legend(leg,"location","southeast")  
  legend boxoff
  xlabel("sample [100] in magnet coordinates (set to c. 90 manually)")
  ylabel("magnet-polarisation offset for lowest error")
  title("given anisotropy fit - orientation of sample")
  %print("out/uhly/given3.png")
  %save("out/uhly/given3.dat","given3")
  
  
endfunction
function b=ferh_cross_1()
  b.name="FR06 FeRh, 420K, 1st set, reflection MLD spectrum, AOI=1deg";
  lambda=[460 530 620 710 810 920 1050 1200 1400 1600];
  beta=[0 45 90 135 180 225 270 315];
  Hext=207;
  gain=10;
  order=[1 2 4];
  
  fls=@(i,j) struct("filename", sprintf("data/ferh/cross_1/%04d/FR06_%04d_beta%03d.dat",lambda(i),lambda(i),beta(j)),...
                 "gain", gain,  "order", order);
  for i=1:numel(lambda)
    b.data{i}.wavelength=lambda(i);
    b.data{i}.beta=beta;
    b.data{i}.Hext=Hext;
    b.data{i}.name=sprintf("%04dnm - %03dmT, (1)",lambda(i),Hext);
    for j=1:numel(beta)
      b.data{i}.files{j}=fls(i,j);
    endfor
  endfor
  
  b=batch_load(b);
  for i=1:numel(lambda)
    %b.data{i}=process_Hsymmetric(b.data{i});
    %b.data{i}=process_2beta(b.data{i});
  endfor
endfunction
function b=cofe_good_rt()
  b.name="CoFe, room temperature, pure transmission MLD spectrum";
  lambda=[460 530 620 710 810 920 1050 1200 1450];
  beta=[0 45 90 135 180 225 270 315];
  gain=100;
  order=[1 2 4];
  
  fls=@(i,j) struct("filename", sprintf("data/cofe/good_rt/%04d/cofe_%04dnm_b%03d.dat",lambda(i),lambda(i),beta(j)),...
                 "gain", gain,  "order", order);
  for i=1:numel(lambda)
    b.data{i}.wavelength=lambda(i);
    b.data{i}.beta=beta;
    for j=1:numel(beta)
      b.data{i}.files{j}=fls(i,j);
    endfor
  endfor
  
  b=batch_load(b);
  for i=1:numel(lambda)
    b.data{i}=process_Hsymmetric(b.data{i});
    b.data{i}=process_2beta(b.data{i});
  endfor
endfunction
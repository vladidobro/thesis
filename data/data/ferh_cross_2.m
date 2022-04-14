function b=ferh_cross_2()
  b.name="FR06 FeRh, 420K, 2nd set, reflection MLD spectrum, AOI=0.5deg";
  name={"0460L","0530L","0620L","0710L","0810L","0920L","1050L","1200L","1400L","1600L","0710H","1050H","1600H","1600LR","1600HR"};
  lambda=[460 530 620 710 810 920 1050 1200 1400 1600 710 1050 1600 1600 1600];
  Hext=[50 50 50 50 50 50 50 50 50 50 207 207 207 50 207];
  beta=[0:22.5:337.5];
  gain=10;
  order=[1 2 4];
  
  fls=@(i,j) struct("filename", sprintf("data/ferh/cross_2/%s/%04d.dat",name{i},beta(j)*10),...
                 "gain", gain,  "order", order);
  for i=1:numel(lambda)
    b.data{i}.wavelength=lambda(i);
    b.data{i}.beta=beta;
    b.data{i}.Hext=Hext(i);
    b.data{i}.name=sprintf("%04dnm - %03dmT, (2)",lambda(i),Hext(i));
    if i>=14
      b.data{i}.name=strcat(b.data{i}.name," rotated sample (new gamma=old gamma - cca 90)");
    endif
    for j=1:numel(beta)
      b.data{i}.files{j}=fls(i,j);
    endfor
  endfor
  
  b=batch_load(b);
  for i=1:numel(lambda)
    b.data{i}=process_Hsymmetric(b.data{i});
    b.data{i}=process_2beta(b.data{i});
    b.data{i}.rotation*=1000;
  endfor
endfunction
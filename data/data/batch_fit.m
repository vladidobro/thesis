function b=batch_fit(b)
  for i=1:numel(b.data)
    [b.data{i}.coef,...
     b.data{i}.phiM,...
     b.data{i}.P,...
     ~,~]=anisocoeffit(b.data{i}.rotation,b.data{i}.phiH);
     b.data{i}.ncoef=[b.data{i}.Hext,1,b.data{i}.Hext,1].*coef2ncoef(b.data{i}.coef);
     
    b.data{i}.wavelength
    b.data{i}.ncoef
  endfor
endfunction
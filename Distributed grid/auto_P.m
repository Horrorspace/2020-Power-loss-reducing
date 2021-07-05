   P(1) = 0; % активная мощность нагрузки узла [МВт]
   P(2) = 0.1;  
   P(3) = 0.09;
   P(4) = 0.12;
   P(5) = 0.06;
   P(6) = 0.06;
   P(7) = 0.2;
   P(8) = 0.2;
   P(9) = 0.06;
   P(10) = 0.06;
   P(11) = 0.045;
   P(12) = 0.06;
   P(13) = 0.06;
   P(14) = 0.12;
   P(15) = 0.06;
   P(16) = 0.06;
   P(17) = 0.06;
   P(18) = 0.09;
   P(19) = 0.09;
   P(20) = 0.09;
   P(21) = 0.09;
   P(22) = 0.09;
   P(23) = 0.09;
   P(24) = 0.42;
   P(25) = 0.42;
   P(26) = 0.06;
   P(27) = 0.06;
   P(28) = 0.06;
   P(29) = 0.12;
   P(30) = 0.2;
   P(31) = 0.15;
   P(32) = 0.21;
   P(33) = 0.06;
stop = 0;
Pg = 0.400;
nvars = 33;
lb = zeros(1,33);
ub = zeros(1,33);
v = zeros (1,33);
value = zeros(1,33);
k = zeros(1,33);

  U = dU(v);
  [val, inx] = min(U);
  k(1) = inx;
  ub(k(1)) = P(k(1));
  
  %% Start with the default options
options = optimoptions('ga');
%% Modify options setting
options = optimoptions(options,'Display', 'iter');
[x,fval,exitflag,output,population,score] = ...
ga(@(v)dP1(v),nvars,[],[],[],[],lb,ub,[],[],options);
  v = x;
  
  value(1) = v(k(1));
i = 1;
while (stop == 0)
  i = i + 1;
  U = dU(v);
  [val, inx] = min(U);
  inx1 = 0;

    for (m = 1:i);
      if k(m) == inx;
         inx1 = inx - 1;
      end
   if (inx1 ~= 0)
     for (mm = 1:i)
      if k(mm) == inx1;
          inx1 = inx1 - 1;
      end
      if k(mm) == inx1;
          inx1 = inx1 - 1;
      end
      if k(mm) == inx1;
          inx1 = inx1 - 1;
      end
      if k(mm) == inx1;
          inx1 = inx1 - 1;
      end
      if k(mm) == inx1;
          inx1 = inx1 - 1;
      end
      if k(mm) == inx1;
          inx1 = inx1 - 1;
      end
     end
   end
  end
  
  if inx1 ~= 0;
      k(i) = inx1;
  else k(i) = inx;
  end
  ub(k(i)) = P(k(i));
  
  %% Start with the default options
options = optimoptions('ga');
%% Modify options setting
options = optimoptions(options,'Display', 'iter');
[x,fval,exitflag,output,population,score] = ...
ga(@(v)dP1(v),nvars,[],[],[],[],lb,ub,[],[],options);
  v = x;
  if (sum(v)<Pg)
  value(i) = v(k(i));
  else value(i) = Pg - (sum(v) - v(k(i))); stop = 1;
  end
end
k
value
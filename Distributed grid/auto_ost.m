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
n = 12;
nvars = 33;
lb = zeros(1,33);
ub = zeros(1,33);
v = zeros (1,33);
value = zeros(1,n);
k = zeros(1,n);

proizvodnaya_P = zeros(1,33); % создание нулевой матрицы производных в точках
v = zeros(1, 33); % создание нулевой матрицы решений
m = zeros(1,33);
m0 = dP_ostr(v);
for (i = 2:33)
    v = zeros(1, 33); % создание нулевой матрицы решений
    v(i) = P(i) + P(i)*0.05;
    m(i) = dP_ostr(v);
    proizvodnaya_P(i) = (m0 - m(i))/(P(i)*0.05);
end
[val, inx] = max(abs(proizvodnaya_P));
  k(1) = inx;
  ub(k(1)) = 1.5;
  
  %% Start with the default options
options = optimoptions('ga');
%% Modify options setting
options = optimoptions(options,'Display', 'iter');
[x,fval,exitflag,output,population,score] = ...
ga(@(v)dP_ostr(v),nvars,[],[],[],[],lb,ub,[],[],options);
  v = x;
  
  value(1) = v(k(1));

for (i = 2:n);
     proizvodnaya_P = zeros(1,33); % создание нулевой матрицы производных в точках
m = zeros(1,33);
m0 = dP1(v);
for (kk = 2:33)
    variable = v(kk);
    v(kk) = P(kk)*0.05;
    m(kk) = dP1(v);
    proizvodnaya_P(kk) = (m0 - m(kk))/(P(kk)*0.05);
    v(kk) = variable;
end
proizvodnaya_P;
[val, inx] = max((proizvodnaya_P));
  inx1 = 0;
for (count = 1:n)
for (m = 1:n)
   if k(m) == inx;
         proizvodnaya_P(inx) = 0;
         [val, inx] = max((proizvodnaya_P));
      end
end
end

  k(i) = inx;
  ub(k(i)) = 3.715;
  
  %% Start with the default options
options = optimoptions('ga');
%% Modify options setting
options = optimoptions(options,'Display', 'iter');
[x,fval,exitflag,output,population,score] = ...
ga(@(v)dP_ostr(v),nvars,[],[],[],[],lb,ub,[],[],options);
  v = x;
  value = v;
end
k
value
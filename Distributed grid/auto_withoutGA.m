   P(1) = 0; % �������� �������� �������� ���� [���]
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
i = 1;
while (stop == 0)
    U = dU(v);
   [val, inx] = min(U);
   
   
       if value(i) == P(k(i))
           i = i+1;
       end
       
   for (mm = 1:33)
       if value(i) == P(k(i))
           k(i) = k(i) - 1;
       end
   end
   value(i) = value (i) + 0.1*P(k(i));
   if sum(value)>Pg
       stop = 1; value(i) = Pg -(sum(value) - value(i));
   end
end
k
value
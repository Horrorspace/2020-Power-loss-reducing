function f = Rezhim(v)
j = sqrt(-1); % ������� ������ �������
Unom = 10; % ����������� ���������� ���� [��]
  P = zeros(1, 33); % �������� ������� ������� �������� ��������� �������� �����
  Q = zeros(1, 33); % �������� ������� ������� ���������� ��������� �������� �����
  S = zeros(1, 33); % �������� ������� ������� ������ ��������� �������� �����
   P(2) = 0.1;  % �������� �������� �������� ���� [���]
   P(3) = 0.09;
   P(4) = 0.12;
   P(5) = 0.06;
   P(6) = 0.06;
   P(7) = 0.2;
   P(8) = 0.2;
   P(9) = 0.06;
   P(10) = 0.06 - v(1);
   P(11) = 0.045 - v(2);
   P(12) = 0.06 - v(3);
   P(13) = 0.06 - v(4);
   P(14) = 0.12 - v(5);
   P(15) = 0.06 - v(6);
   P(16) = 0.06 - v(7);
   P(17) = 0.06 - v(8);
   P(18) = 0.09 - v(9);
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
   P(29) = 0.12 - v(10);
   P(30) = 0.2 - v(11);
   P(31) = 0.15 - v(12);
   P(32) = 0.21 - v(13);
   P(33) = 0.06 - v(14);
   Q(2) = 0.06; % ���������� �������� �������� ���� [����]
   Q(3) = 0.04;
   Q(4) = 0.08;
   Q(5) = 0.03;
   Q(6) = 0.02;
   Q(7) = 0.1;
   Q(8) = 0.1;
   Q(9) = 0.02;
   Q(10) = 0.02;
   Q(11) = 0.03;
   Q(12) = 0.035;
   Q(13) = 0.035;
   Q(14) = 0.08;
   Q(15) = 0.01;
   Q(16) = 0.02;
   Q(17) = 0.02;
   Q(18) = 0.04;
   Q(19) = 0.04;
   Q(20) = 0.04;
   Q(21) = 0.04;
   Q(22) = 0.04;
   Q(23) = 0.05;
   Q(24) = 0.2;
   Q(25) = 0.2;
   Q(26) = 0.025;
   Q(27) = 0.025;
   Q(28) = 0.02;
   Q(29) = 0.07;
   Q(30) = 0.6;
   Q(31) = 0.07;
   Q(32) = 0.1;
   Q(33) = 0.04;
   for (i = 2:33) % ���������� ������ ��������� �������� �����
       S(i) = P(i) + j*Q(i); % ������ �������� �������� i-�� ���� [���]
   end
 l = zeros(1, 32); % �������� ������� ������� ���� �����
 for (k = 1:32) % ���������� �������� ����� 1 �� ������
    l(k) = 1; % ����� k-� �����
 end
 r = zeros(1, 32); % �������� ������� ������� �������� �������� ������������� �����
 x = zeros(1, 32); % �������� ������� ������� �������� ���������� ������������� �����
 r = [0.0922; 0.4930; 0.3660; 0.3811; 0.8190; 0.1872; 1.7114; 1.03; 
     1.0440; 0.1966; 0.3744; 1.4680; 0.5416; 0.5910; 0.7463; 1.289; 
     0.732; 0.164; 1.5042; 0.4095; 0.7089; 0.4512; 0.8980; 0.8960;
     0.2030; 0.2842; 1.059; 0.8042; 0.5075; 0.9744; 0.3105; 0.3410]; % �������� �������� ������������� ����� [��/��]
 x = [0.047; 0.2511; 0.1864; 0.1941; 0.707; 0.6188; 1.2351; 0.74; 0.74; 
     0.065; 0.1238; 1.155; 0.7129; 0.526; 0.545; 1.721; 0.574; 0.1565;
     1.3554; 0.4784; 0.9373; 0.3083; 0.7091; 0.7011; 0.1034; 0.1447;
     0.9337; 0.7006; 0.2585; 0.9630; 0.3619; 0.5302]; % �������� ���������� ������������� ����� [��/��]
 for (k = 1:32) % ���������� ��������, ���������� � ������ ������������� �����
     R(k) = r(k)*l(k); % �������� ������������� k-�� ����� [��]
     X(k) = x(k)*l(k); % ���������� ������������� k-�� ����� [��]
     Z(k) = R(k) + j*X(k); % ������ ������������� k-�� ����� [��]
 end
  Pl = zeros(1, 32); % �������� ������� ������� ������� �������� �������� 
  Ql = zeros(1, 32); % �������� ������� ������� ������� ���������� ��������
  Sl = zeros(1, 32); % �������� ������� ������� ������� ������ ��������
  U = zeros(1, 33); % �������� ������� ������� ���������� � �����
  dS = zeros(1, 32); % �������� ������� ������� ������ ������ ��������

  for (i = 1:33) % ���������� ����� ������������ ����������
      U(i) = Unom; % ���������� � i-�� ���� [��]
  end
  
  U0 = zeros(1, 33); % �������� ������� ������� ���������� �� ���������� ��������
  e = 0.001; % ������� �������� ������� [��]
  Perc = Unom; % ��������� ����������� ������� �������� ���������� � ����� �� �������� ���������
  
  for (q = 1:3)
   for (m = 1:11) % ���������� ������� � ������ ����� ���� �� 6-�� �� 18-�� ����
     Sl(17) = S(18); % ������ ����� �� 17-� ����� [���]
     Pl(17) = real(Sl(17)); % �������� ����� �� 17-� ����� [���]
     Ql(17) = imag(Sl(17)); % ���������� ����� �� 17-� ����� [����]
     dS(17) = (Pl(17)^2 + Ql(17)^2)*Z(17)/U(18)^2; % ������ ������ �������� � 17-� ����� [���]
       k = 17 - m; % ����� ����� ��� ������� ����������� ������ �� ������ ��������
       Sl(k) = S(k+1) + Sl(k+1) + dS(k+1); % ������ ����� �� k-� ����� [���]
       Pl(k) = real(Sl(k)); % �������� ����� �� k-� ����� [���]
       Ql(k) = imag(Sl(k)); % ���������� ����� �� k-� ����� [����]
       dS(k) = (Pl(k)^2 + Ql(k)^2)*Z(k)/U(k+1)^2; % ������ ������ �������� � k-� ����� [���]
   end
   
   for (m = 1:7) % ���������� ������� � ������ ����� ���� �� 6-�� �� 33-�� ����
     Sl(32) = S(33); % ������ ����� �� 32-� ����� [���]
     Pl(32) = real(Sl(32)); % �������� ����� �� 32-� ����� [���]
     Ql(32) = imag(Sl(32)); % ���������� ����� �� 32-� ����� [����]
     dS(32) = (Pl(32)^2 + Ql(32)^2)*Z(32)/U(33)^2; % ������ ������ �������� � 32-� ����� [���]
       k = 32 - m; % ����� ����� ��� ������� ����������� ������ �� ������ ��������
       Sl(k) = S(k+1) + Sl(k+1) + dS(k+1); % ������ ����� �� k-� ����� [���]
       Pl(k) = real(Sl(k)); % �������� ����� �� k-� ����� [���]
       Ql(k) = imag(Sl(k)); % ���������� ����� �� k-� ����� [����]
       dS(k) = (Pl(k)^2 + Ql(k)^2)*Z(k)/U(k+1)^2; % ������ ������ �������� � k-� ����� [���]
   end
   
   for (m = 1:2) % ���������� ������� � ������ ����� ���� �� 3-�� �� 6-�� ����
     Sl(5) = S(6) + Sl(6) + dS(6) + Sl(25) + dS(25); % ������ ����� �� 5-� ����� [���]
     Pl(5) = real(Sl(5)); % �������� ����� �� 5-� ����� [���]
     Ql(5) = imag(Sl(5)); % ���������� ����� �� 5-� ����� [����]
     dS(5) = (Pl(5)^2 + Ql(5)^2)*Z(5)/U(6)^2; % ������ ������ �������� � 5-� ����� [���]
       k = 5 - m; % ����� ����� ��� ������� ����������� ������ �� ������ ��������
       Sl(k) = S(k+1) + Sl(k+1) + dS(k+1); % ������ ����� �� k-� ����� [���]
       Pl(k) = real(Sl(k)); % �������� ����� �� k-� ����� [���]
       Ql(k) = imag(Sl(k)); % ���������� ����� �� k-� ����� [����]
       dS(k) = (Pl(k)^2 + Ql(k)^2)*Z(k)/U(k+1)^2; % ������ ������ �������� � k-� ����� [���]
   end
   
   for (m = 1:2) % ���������� ������� � ������ ����� ���� �� 3-�� �� 25-�� ����
     Sl(24) = S(25); % ������ ����� �� 24-� ����� [���]
     Pl(24) = real(Sl(24)); % �������� ����� �� 24-� ����� [���]
     Ql(24) = imag(Sl(24)); % ���������� ����� �� 24-� ����� [����]
     dS(24) = (Pl(24)^2 + Ql(24)^2)*Z(24)/U(25)^2; % ������ ������ �������� � 24-� ����� [���]
       k = 24 - m; % ����� ����� ��� ������� ����������� ������ �� ������ ��������
       Sl(k) = S(k+1) + Sl(k+1) + dS(k+1); % ������ ����� �� k-� ����� [���]
       Pl(k) = real(Sl(k)); % �������� ����� �� k-� ����� [���]
       Ql(k) = imag(Sl(k)); % ���������� ����� �� k-� ����� [����]
       dS(k) = (Pl(k)^2 + Ql(k)^2)*Z(k)/U(k+1)^2; % ������ ������ �������� � k-� ����� [���]
   end
     
   % ���������� ������ � ������ ����� ���� �� 2-�� �� 3-�� ����
     Sl(2) = S(3) + Sl(3) + dS(3) + Sl(22) + dS(22); % ������ ����� �� 2-� ����� [���]
     Pl(2) = real(Sl(2)); % �������� ����� �� 2-� ����� [���]
     Ql(2) = imag(Sl(2)); % ���������� ����� �� 2-� ����� [����]
     dS(2) = (Pl(2)^2 + Ql(2)^2)*Z(2)/U(3)^2; % ������ ������ �������� � 2-� ����� [���]
    
   for (m = 1:3) % ���������� ������� � ������ ����� ���� �� 2-�� �� 22-�� ����
     Sl(21) = S(22); % ������ ����� �� 21-� ����� [���]
     Pl(21) = real(Sl(21)); % �������� ����� �� 21-� ����� [���]
     Ql(21) = imag(Sl(21)); % ���������� ����� �� 21-� ����� [����]
     dS(21) = (Pl(21)^2 + Ql(21)^2)*Z(21)/U(22)^2; % ������ ������ �������� � 21-� ����� [���]
       k = 21 - m; % ����� ����� ��� ������� ����������� ������ �� ������ ��������
       Sl(k) = S(k+1) + Sl(k+1) + dS(k+1); % ������ ����� �� k-� ����� [���]
       Pl(k) = real(Sl(k)); % �������� ����� �� k-� ����� [���]
       Ql(k) = imag(Sl(k)); % ���������� ����� �� k-� ����� [����]
       dS(k) = (Pl(k)^2 + Ql(k)^2)*Z(k)/U(k+1)^2; % ������ ������ �������� � k-� ����� [���]
   end
   
   % ���������� ������ � ������ ����� ���� �� 1-�� �� 2-�� ����
     Sl(1) = S(2) + Sl(18) + dS(18) + Sl(2) + dS(2); % ������ ����� �� 1-� ����� [���]
     Pl(1) = real(Sl(1)); % �������� ����� �� 1-� ����� [���]
     Ql(1) = imag(Sl(1)); % ���������� ����� �� 1-� ����� [����]
     dS(1) = (Pl(1)^2 + Ql(1)^2)*Z(1)/U(2)^2; % ������ ������ �������� � 1-� ����� [���]
   
   
     
  dU = zeros(1, 32); % �������� ������� ������� ������ ���������� � ������
  U(1) = 10.5 % ���������� �������� ���� [��]
  dU(1) = conj(Sl(1) + dS(1))*Z(1)/conj(U(1)); % ���������� ������ ���������� � ����� ���� �� 1-�� �� 2-�� ���� [��]  
  U(2) = U(1) - dU(1); % ���������� � ���� 2 [��]
     
  for (m = 1:3) % ���������� ������ ���������� � ����� ���� �� 2-�� �� 22-�� ���� [��]  
  dU(18) = conj(Sl(18) + dS(18))*Z(18)/conj(U(18)); % ���������� ������ ���������� � 18-� ����� [��]  
  U(19) = U(2) - dU(18); % ���������� � ���� 2 [��]   
  k = 18 + m; % ����� ����� ��� ������� ����������� ������ �� ������ �������� 
  dU(k) = conj(Sl(k) + dS(k))*Z(k)/conj(U(k)); % ���������� ������ ���������� � k-� ����� [��]  
  U(k+1) = U(k) - dU(k); % ���������� � ���� k+1 [��]      
  end
   
  dU(2) = conj(Sl(2) + dS(2))*Z(2)/conj(U(2)); % ���������� ������ ���������� � ����� ���� �� 2-� ����� [��]  
  U(3) = U(2) - dU(2); % ���������� � ���� 3 [��]
  
  for (m = 1:2) % ���������� ������ ���������� � ����� ���� �� 3-�� �� 25-�� ���� [��]  
  dU(22) = conj(Sl(22) + dS(22))*Z(22)/conj(U(3)); % ���������� ������ ���������� � 22-� ����� [��]  
  U(19) = U(2) - dU(18); % ���������� � ���� 23 [��]   
  k = 22 + m; % ����� ����� ��� ������� ����������� ������ �� ������ �������� 
  dU(k) = conj(Sl(k) + dS(k))*Z(k)/conj(U(k)); % ���������� ������ ���������� � k-� ����� [��]  
  U(k+1) = U(k) - dU(k); % ���������� � ���� k+1 [��]      
  end
  
  for (m = 1:15) % ���������� ������ ���������� � ����� ���� �� 3-�� �� 18-�� ���� [��]  
  k = 2 + m; % ����� ����� ��� ������� ����������� ������ �� ������ �������� 
  dU(k) = conj(Sl(k) + dS(k))*Z(k)/conj(U(k)); % ���������� ������ ���������� � k-� ����� [��]  
  U(k+1) = U(k) - dU(k); % ���������� � ���� k+1 [��]      
  end
  
  for (m = 1:7) % ���������� ������ ���������� � ����� ���� �� 6-�� �� 33-�� ���� [��]  
  dU(25) = conj(Sl(25) + dS(25))*Z(25)/conj(U(6)); % ���������� ������ ���������� � 25-� ����� [��]  
  U(26) = U(6) - dU(25); % ���������� � ���� 26 [��]   
  k = 25 + m; % ����� ����� ��� ������� ����������� ������ �� ������ �������� 
  dU(k) = conj(Sl(k) + dS(k))*Z(k)/conj(U(k)); % ���������� ������ ���������� � k-� ����� [��]  
  U(k+1) = U(k) - dU(k); % ���������� � ���� k+1 [��]      
  end 
  
  [val, inx] = max(abs(abs(U)-abs(U0)));
  Perc = val; % ������������ ������� ����� ������������ � ����� �� �������� ��������  
  U0 = abs(U); % ������ ���������� � ����� �� ������� �������� � ���������� U0 ��� ���������� ������� ����� ���������� �� ��������� ��������
  end
  
  
   deltaU = zeros(1, 33); % �������� ������� ������� ������������ ���������� � ����� [%]
  for (i = 1:33) % ���������� ���������� ���������� � �����
      deltaU(i) = abs(Unom - U(i))*100/Unom; % ������������ ���������� � i-�� ���� [%]
  end
  [val, inx] = max(deltaU);
   deltaUmax = val; % ������������ ���������� ���������� [%]
   deltaUmax_node = inx; % ����� ���� � ������������ ����������� ����������
    dP = real(dS); % ������� ������ �������� �������� � ����
 dP_sum = sum(dP); % ��������� ������ �������� �������� � ���� [���]
  if sum(v)> 2
    dP_sum = 200; 
 end
 
 f = dP_sum;
   
   
   
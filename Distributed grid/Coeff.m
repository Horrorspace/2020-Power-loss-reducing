proizvodnaya_P = zeros(1,33); % �������� ������� ������� ����������� � ������
for (k = 2:33) % ���� ���������� ����������� � ����� v(k) = 0
v = zeros(1, 33); % �������� ������� ������� �������
h = 0.2; % ��� �����������������, ���
x = 0:h:5; % �������� ��������� �������� ��� �����������������
n = length(x); % ���������� ����� � ������� x
dy = zeros(1,(n-1)); % �������� ������� ������� ��� ������ �������� �����������
for (i = 1:(n-1)) % ���� ���������� �����������
 v(k) = x(i+1);
 val = diff_1(v);
 f1 = val(1);
 v(k) = x(i);
 val = diff_1(v);
 f2 = val(1);
 dy(i) = (f1 - f2)/h;   
end
proizvodnaya_P(k)= dy(1); % ������ �������� ����������� � ����� v(k) = 0 ��� ������� ����
end
[val, inx] = max(abs(proizvodnaya_P));
val;
inx
k = 1:33;
%abs(proizvodnaya_P)
%xlswrite('E:\Edu\������ (�)\��������� � Matlab\Distributed grid\Result.xls',abs(proizvodnaya_P)) 

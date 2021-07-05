proizvodnaya_P = zeros(1,33); % создание нулевой матрицы производных в точках
for (k = 2:33) % цикл вычисления производной в точке v(k) = 0
v = zeros(1, 33); % создание нулевой матрицы решений
h = 0.2; % шаг дифференцирования, МВт
x = 0:h:5; % диапазон изменения мощности при дифференцировании
n = length(x); % количество точек в векторе x
dy = zeros(1,(n-1)); % создание нулевой матрицы для записи значений производной
for (i = 1:(n-1)) % цикл вычисления производной
 v(k) = x(i+1);
 val = diff_1(v);
 f1 = val(1);
 v(k) = x(i);
 val = diff_1(v);
 f2 = val(1);
 dy(i) = (f1 - f2)/h;   
end
proizvodnaya_P(k)= dy(1); % запись значения производной в точке v(k) = 0 для каждого узла
end
[val, inx] = max(abs(proizvodnaya_P));
val;
inx
k = 1:33;
%abs(proizvodnaya_P)
%xlswrite('E:\Edu\Диплом (м)\Программа в Matlab\Distributed grid\Result.xls',abs(proizvodnaya_P)) 

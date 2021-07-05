function f = Select()
x = zeros (1,33);
k = zeros (1,33);
for (i = 2:33)
    k = zeros (1,33);
    k(i) = 3.715;
    x(i) = dP(k);
end
otv = zeros(1,32);
for (i = 2:33)
    otv(i-1) = x(i);
end
x(1) = 0.312;
x
[val, inx] = min(x)
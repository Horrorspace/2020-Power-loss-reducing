function [x,fval,exitflag,output,population,score] = ga_optimization(nvars,lb,ub)
%% Start with the default options
options = optimoptions('ga');
%% Modify options setting
options = optimoptions(options,'Display', 'iter');
lb = [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0];
ub = [3.715; 3.715; 3.715; 3.715; 3.715; 3.715; 3.715; 3.715; 3.715; 3.715; 3.715; 3.715];
nvars = 12;
[x,fval,exitflag,output,population,score] = ...
ga1(@(v)dP(v),nvars,[],[],[],[],lb,ub,[],[],options);

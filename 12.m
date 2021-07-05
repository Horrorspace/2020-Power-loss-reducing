function [x,fval,exitflag,output,population,score] = 12(nvars,lb,ub)
%% This is an auto generated MATLAB file from Optimization Tool.

%% Start with the default options
options = optimoptions('ga');
%% Modify options setting
options = optimoptions(options,'Display', 'iter');
[x,fval,exitflag,output,population,score] = ...
ga(@(v)dP(v),nvars,[],[],[],[],lb,ub,[],[],options);

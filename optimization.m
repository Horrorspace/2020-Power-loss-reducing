function [x,fval,exitflag,output,population,score] = optimization(x)
%% This is an auto generated MATLAB file from Optimization Tool.

%% Start with the default options
options = optimoptions('ga');
%% Modify options setting
options = optimoptions(options,'HybridFcn', {  @fminunc [] });
options = optimoptions(options,'Display', 'off');
[x,fval,exitflag,output,population,score] = ...
ga(@objectivefunc1,1,options);
%% Start with the default options
options = optimoptions('ga');
%% Modify options setting
options = optimoptions(options);
lb = [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0];
ub = [0.06; 0.045; 0.06; 0.06; 0.12; 0.06; 0.06; 0.06; 0.09; 0.15; 0.21; 0.06];
nvars = 12;
[x,fval,exitflag,output,population,score] = ...
ga(@(v)dP(v),nvars,[],[],[],[],lb,ub,[],[],options);
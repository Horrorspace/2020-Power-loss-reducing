function temperature = temperaturefast(optimValues,options)
%TEMPERATUREFAST Updates the temperature vector for annealing process 
%   TEMPERATURE = TEMPERATUREFAST(optimValues,options) uses fast 
%   annealing by updating the current temperature based on the initial
%   temperature and the current annealing parameter k
%
%   OPTIMVALUES is a structure containing the following information:
%              x: current point 
%           fval: function value at x
%          bestx: best point found so far
%       bestfval: function value at bestx
%    temperature: current temperature
%      iteration: current iteration 
%             t0: start time
%              k: annealing parameter
%
%   OPTIONS: options object created by using OPTIMOPTIONS.
%
%   Example:
%    Create an options structure using TEMPERATUREFAST as the annealing
%    function
%    options = optimoptions('simulannealbnd','TemperatureFcn',@temperaturefast);

%   Copyright 2006-2015 The MathWorks, Inc.

temperature = options.InitialTemperature./optimValues.k;


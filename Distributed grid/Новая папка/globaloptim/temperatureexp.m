function temperature = temperatureexp(optimValues,options)
%TEMPERATUREEXP Updates the temperature vector for annealing process 
%   TEMPERATURE = TEMPERATUREEXP(optimValues,options) uses exponential 
%   annealing schedule by updating the current temperature based on the
%   initial temperature and the current annealing parameter k
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
%    Create an options structure using TEMPERATUREEXP as the annealing
%    function
%    options = optimoptions('simulannealbnd','TemperatureFcn',@temperatureexp);

%   Copyright 2006-2015 The MathWorks, Inc.

temperature = options.InitialTemperature.*.95.^optimValues.k;


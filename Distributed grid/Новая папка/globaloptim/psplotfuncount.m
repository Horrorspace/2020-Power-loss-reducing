function stop = psplotfuncount(optimvalues,flag)
%PSPLOTFUNCOUNT Plot function evaluations every iteration.
%   STOP = PSPLOTFUNCOUNT(OPTIMVALUES,FLAG) where OPTIMVALUES is a
%   structure with the following fields: 
% 
%   PATTERNSEARCH:
%               x: current point X
%       iteration: iteration count
%            fval: function value
%        meshsize: current mesh size
%       funccount: number of function evaluations
%          method: method used in last iteration
%          TolFun: tolerance on function value in last iteration
%            TolX: tolerance on X value in last iteration
%      nonlinineq: nonlinear inequality constraints at X
%        nonlineq: nonlinear equality constraints at X
% 
%   PARETOSEARCH:
%               x: current Pareto set in parameter space
%            fval: current Pareto set in functional space
%       iteration: iteration count
%       funccount: number of function evaluations
%      nonlinineq: nonlinear inequality constraints at X
%        nonlineq: nonlinear equality constraints at X
%          volume: total volume of polytope defined by Pareto set
% averagedistance: weighted average distance between Pareto points
%          spread: measure of how far apart Pareto points are from outliers in the Pareto set
%
%   FLAG: Current state in which PlotFcn is called. Possible values are:
%            init: initialization state
%            iter: iteration state
%       interrupt: intermediate state
%            done: final state
%
%   STOP: A boolean to stop the algorithm.
%
%   See also PATTERNSEARCH, PARETOSEARCH, GA, GAMULTIOBJ, OPTIMOPTIONS.

%   Copyright 2003-2018 The MathWorks, Inc.

persistent previousFvals

if isempty(previousFvals) || strcmpi(flag, 'init')
    previousFvals = 0;
end

fileTag = 'psplotfuncount'; % unique label, usually name of m-file or similar. Allows MATLAB to keep track and update this specific plot.
varTypeX = 'iteration';      % specify that optimvalues.iteration will be plotted on the x-axis
varTypeY = 'funccount';  % specify that optimvalues.maxconstraint will be plotted on the y-axis

% style of plot we would like to view
plotter = @plot;
% cell array with name/value pairs for 'plotter' function
markeropts = {'kd', 'MarkerSize',5,'MarkerFaceColor',[1 0 1]}; 
% X/Y and Title labels for plot function
xlabelStr = getString(message('globaloptim:psplotcommon:iterationXLabel'));
ylabelStr = getString(message('globaloptim:psplotcommon:funccountYLabel'));
titleStr = getString(message('globaloptim:psplotcommon:funccountTitle', num2str(optimvalues.(varTypeY))));

% get delta between each iteration
temp = optimvalues.(varTypeY);
optimvalues.(varTypeY) = optimvalues.(varTypeY) - previousFvals;
previousFvals = temp;

% Commonized function that takes care of plotting and updating every
% iteration.
stop = globaloptim.patternsearch.internal.psplotscalar(optimvalues,flag,...
       fileTag,varTypeX,varTypeY,plotter,markeropts,xlabelStr,ylabelStr,titleStr,@i_interrupt,@i_done);

%--------------
function stop = i_interrupt(optimvalues, flag) %#ok
% I_INTERRUPT Perform interrupt tasks

    % This plot function does not update when the algorithm is in an
    % intermediate state.
    stop = false;
end

%--------------
function stop = i_done(optimvalues, flag) %#ok
% I_DONE Perform clean-up tasks

    previousFvals = 0;
    stop = false;
end

end

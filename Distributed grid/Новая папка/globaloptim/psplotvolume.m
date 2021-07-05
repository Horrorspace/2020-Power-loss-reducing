function stop = psplotvolume(optimvalues,flag)
%PSPLOTVOLUME Plot volume every iteration.
%   STOP = PSPLOTVOLUME(OPTIMVALUES,FLAG) where OPTIMVALUES is a
%   structure with the following fields:
% 
%    PARETOSEARCH:
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
%   See also PARETOSEARCH, OPTIMOPTIONS.

%   Copyright 2018 The MathWorks, Inc.

persistent allowRefresh;

stop = false;

% initialize constants
fileTag = 'psplotvolume'; % unique label, usually name of m-file or similar. Allows MATLAB to keep track and update this specific plot.
varTypeX = 'iteration'; % specify that optimvalues.iteration will be plotted on the x-axis
varTypeY = 'volume'; % specify that optimvalues.maxconstraint will be plotted on the y-axis
plotter = @semilogy; % style of plot we would like to view
markeropts = {'k*', 'MarkerSize', 5, 'MarkerFaceColor', 'k'}; % cell array with name/value pairs for 'plotter' function
xlabelStr = getString(message('globaloptim:psplotcommon:iterationXLabel'));
ylabelStr = getString(message('globaloptim:psplotcommon:volumeYLabel'));

% Determine if we function supports problem.
if strcmpi(flag, 'init')
    % Plot is unavailable for single objective problems.
    % We adjust the plot title appropriately.
    if ~isfield(optimvalues, 'fval') || (size(optimvalues.fval,2) == 1)
        allowRefresh = false;
        titleStr = getString(message('globaloptim:psplotcommon:PlotFcnUnavailableSingleObj',fileTag));
        title(titleStr);
    else
        allowRefresh = true;
    end
end

if allowRefresh
    % update non-constant values on subsequent iterations if supported

    % update title
    titleStr = getString(message('globaloptim:psplotcommon:volumeTitle', num2str(optimvalues.(varTypeY))));

    % Commonized function that takes care of plotting and updating every
    % iteration.
    stop = globaloptim.patternsearch.internal.psplotscalar(optimvalues,flag,...
           fileTag,varTypeX,varTypeY,plotter,markeropts,xlabelStr,ylabelStr,titleStr,@i_interrupt,@i_done);
end


%--------------
function stop = i_interrupt(optimvalues, flag) %#ok
% I_INTERRUPT Perform interrupt tasks.  This is called in psplotscalar.

% This plot function does not update when the algorithm is in an
% intermediate state.
stop = false;
    
%--------------
function stop = i_done(optimvalues, flag) %#ok
% I_DONE Perform clean-up tasks.  This is called in psplotscalar.

% No clean up tasks required for this plot function.
stop = false;

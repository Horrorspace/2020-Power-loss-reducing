function stop = psplotmaxconstr(optimvalues,flag)
%PSPLOTMAXCONSTR PlotFcn to plot maximum nonlinear constraint violation
%every iteration.
%   STOP = PSPLOTMAXCONSTR(OPTIMVALUES,FLAG) where OPTIMVALUES is a
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

%   Copyright 2005-2018 The MathWorks, Inc.

persistent allowRefresh;
stop = false;

% initialize constants
fileTag = 'psplotmaxconstr'; % unique label, usually name of m-file or similar. Allows MATLAB to keep track and update this specific plot.
varTypeX = 'iteration';      % specify that optimvalues.iteration will be plotted on the x-axis
varTypeY = 'maxconstraint';  % specify that optimvalues.maxconstraint will be plotted on the y-axis
plotter = @plot; % style of plot we would like to view
markeropts = {'.b'}; % cell array with name/value pairs for 'plotter' function
xlabelStr = getString(message('globaloptim:psplotcommon:iterationXLabel'));
ylabelStr = getString(message('globaloptim:psplotcommon:maxconstrYLabel'));

% Determine if we function supports problem.
if strcmpi(flag, 'init')
    % Plot is unavailable for those problems that don't have nonlinear
    % constraints.  We adjust the plot title appropriately.
    if ~(isfield(optimvalues, 'nonlinineq') && isfield(optimvalues, 'nonlineq')) || ...
        (isempty(optimvalues.nonlinineq) && isempty(optimvalues.nonlineq))
        allowRefresh = false; % don't continue to plot anything
        titleStr = getString(message('globaloptim:psplotcommon:PlotFcnUnavailableMaxConstr')); % "not available" title
        title(titleStr); % generate figure
    else
        allowRefresh = true;
    end
end

if allowRefresh
    % update non-constant values on subsequent iterations if supported

    % compute ydata and update title
    optimvalues.(varTypeY) = i_calcMaxConstrViol(optimvalues);
    titleStr = getString(message('globaloptim:psplotcommon:maxconstrTitle', num2str(optimvalues.(varTypeY))));

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
end
    
%--------------
function stop = i_done(optimvalues, flag) %#ok
% I_DONE Perform clean-up tasks.  This is called in psplotscalar.

stop = false;
end

%--------------
function maxConstr = i_calcMaxConstrViol(optimvalues)
%I_CALCMAXCONSTRVIOL Calculate maximum constraint violation

    maxConstr = 0;
    hasNonlinIneqConstr = isfield(optimvalues, 'nonlinineq') && ~isempty(optimvalues.nonlinineq);
    hasNonlinEqConstr = isfield(optimvalues, 'nonlineq') && ~isempty(optimvalues.nonlineq);
    if hasNonlinIneqConstr
        maxConstr = max([maxConstr; optimvalues.nonlinineq(:)]);
    end
    if hasNonlinEqConstr
        maxConstr = max([maxConstr; abs(optimvalues.nonlineq(:))]);
    end
end

end
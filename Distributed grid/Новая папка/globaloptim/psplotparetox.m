function stop = psplotparetox(optimvalues,flag,valuesToPlot)
%PSPLOTPARETOX Plots a the parameter space in up to three dimensions.
%   STOP = PSPLOTPARETOX(OPTIMVALUES,FLAG) where OPTIMVALUES is a
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
%   See also PARETOSEARCH, GAMULTIOBJ, OPTIMOPTIONS.

%   Copyright 2018 The MathWorks, Inc.

persistent notAvailable

if strcmpi(flag, 'init')
    notAvailable = false;
end

fileTag = 'psplotparetox'; % unique label, usually name of m-file or similar. Allows MATLAB to keep track and update specific plot.
varType = 'x'; % specify that optimvalues.(varType) will be plotted
marker = {'sb'}; % Cell array with name/value pairs for 'plot' function

% set title
if notAvailable || ~isfield(optimvalues, varType)
    titleStr = getString(message('globaloptim:psplotcommon:PlotFcnUnavailable',fileTag));
    title(titleStr);
    ax = gca;
    ax.Tag = fileTag;
    fig = gcf;
    fig.Name = 'paretosearch';
    notAvailable = true;
    stop = false;
    return;
elseif size(optimvalues.fval,2) == 1
    titleStr = getString(message('globaloptim:psplotcommon:PlotFcnUnavailableSingleObj',fileTag));
    title(titleStr);
    stop = false;
    return;
else
    % title string
    titleStr = getString(message('globaloptim:psplotcommon:xParamTitle')); 
end


% make sure parametersToPlot are defined so we can properly label the axes
if nargin < 3 || isempty(valuesToPlot)
    if ~isfield(optimvalues,varType) || isempty(optimvalues.(varType))
        valuesToPlot = [1 2];
    else
        valuesToPlot = 1:size(optimvalues.(varType),2);
    end
end

% Define axis labels.  Can use string array or cell array of chars/strings
axisLabelStr = strings(numel(valuesToPlot),1);
axisLabelStr(1) = getString(message('globaloptim:psplotcommon:paramAxisLabelDefault',valuesToPlot(1))); % xlabel
axisLabelStr(2) = getString(message('globaloptim:psplotcommon:paramAxisLabelDefault',valuesToPlot(2))); % ylabel

if numel(valuesToPlot) >= 3
    axisLabelStr(3) = getString(message('globaloptim:psplotcommon:paramAxisLabelDefault',valuesToPlot(3))); % zlabel (if needed)
end

stop = globaloptim.paretosearch.internal.psplotpareto(optimvalues,flag,valuesToPlot,...
    fileTag,varType,marker,axisLabelStr,titleStr,@i_interrupt,@i_done);

%--------------
function stop = i_interrupt(optimvalues, flag, valuesToPlot) %#ok
% I_INTERRUPT Perform interrupt tasks.  This is called in psplotscalar.

% This plot function does not update when the algorithm is in an
% intermediate state.
stop = false;
    
%--------------
function stop = i_done(optimvalues, flag, valuesToPlot) %#ok
% I_DONE Perform clean-up tasks.  This is called in psplotscalar.

% No clean up tasks required for this plot function.
stop = false;


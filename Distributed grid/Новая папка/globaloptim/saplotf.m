function stop = saplotf(~,optimvalues,flag)
%SAPLOTF PlotFcn to plot current function value.
%   STOP = SAPLOTF(OPTIONS,OPTIMVALUES,FLAG) where OPTIMVALUES is a
%   structure with the following fields:
%              x: current point 
%           fval: function value at x
%          bestx: best point found so far
%       bestfval: function value at bestx
%    temperature: current temperature
%      iteration: current iteration
%      funccount: number of function evaluations
%             t0: start time
%              k: annealing parameter
%
%   OPTIONS: The options object created by using OPTIMOPTIONS
%
%   FLAG: Current state in which PlotFcn is called. Possible values are:
%           init: initialization state
%           iter: iteration state
%           done: final state
%
%   STOP: A boolean to stop the algorithm.
%
%   Example:
%    Create an options structure that will use SAPLOTF
%    as the plot function
%     options = optimoptions('simulannealbnd','PlotFcn',@saplotf);

%   Copyright 2006-2015 The MathWorks, Inc.

persistent thisTitle

stop = false;
%plot the current function value against the iteration number
switch flag
    case 'init'
        plotBest = plot(optimvalues.iteration,optimvalues.fval, '.b');
        set(plotBest,'Tag','saplotf');
        xlabel('Iteration','interp','none'); 
        ylabel('Function value','interp','none')
        thisTitle = title(sprintf('Current Function Value: %g',optimvalues.fval),'interp','none');
    case 'iter'
        plotBest = findobj(get(gca,'Children'),'Tag','saplotf');
        newX = [get(plotBest,'Xdata') optimvalues.iteration];
        newY = [get(plotBest,'Ydata') optimvalues.fval];
        set(plotBest,'Xdata',newX, 'Ydata',newY);        
        if isempty(thisTitle)
            set(get(gca,'Title'),'String',sprintf('Current Function Value: %g',optimvalues.fval));
        else
            set(thisTitle,'String',sprintf('Current Function Value: %g',optimvalues.fval));
        end
end

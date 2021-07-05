function stop = saplotx(~,optimvalues,flag)
%SAPLOTX PlotFcn to plot current X value.
%   STOP = SAPLOTX(OPTIONS,OPTIMVALUES,FLAG) where OPTIMVALUES is a
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
%    Create an options structure that will use SAPLOTX
%    as the plot function
%     options = optimoptions('simulannealbnd',PlotFcn',@saplotx);

%   Copyright 2006-2015 The MathWorks, Inc.

stop = false;
% Plot the current point on a bar graph (each bar represents a dimension)
switch flag
    case 'init'
        set(gca,'xlimmode','manual','zlimmode','manual', ...
            'alimmode','manual')
        title('Current Point','interp','none')
        Xlength = numel(optimvalues.x);
        xlabel(sprintf('Number of variables (%i)',Xlength),'interp','none');
        ylabel('Current point','interp','none');
        plotX = bar(optimvalues.x(:));
        set(plotX,'Tag','saplotx');
        set(plotX,'edgecolor','none')
        set(gca,'xlim',[0,1 + Xlength])
    case 'iter'
        plotX = findobj(get(gca,'Children'),'Tag','saplotx');
        set(plotX,'Ydata',optimvalues.x(:))
end
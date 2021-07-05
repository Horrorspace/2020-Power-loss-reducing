function stop = saplottemperature(~,optimvalues,flag)
%SAPLOTTEMPERATURE PlotFcn to plot mean temperature.
%   STOP = SAPLOTTEMPERATURE(OPTIONS,OPTIMVALUES,FLAG) where OPTIMVALUES is
%   a structure with the following fields:
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
%    Create an options structure that will use SAPLOTTEMPERATURE
%    as the plot function
%     options = optimoptions('simulannealbnd','PlotFcn',@saplottemperature);

%   Copyright 2006-2015 The MathWorks, Inc.

stop = false;
% plot the current temperature on a bar graph (each bar represents a dimension)
switch flag
    case 'init'
        set(gca,'xlimmode','manual','zlimmode','manual', ...
            'alimmode','manual')
        title('Current Temperature','interp','none')
        Xlength = numel(optimvalues.temperature);
        xlabel(sprintf('Number of variables (%i)',Xlength),'interp','none');
        ylabel('Current temperature','interp','none');
        plotTemp = bar(optimvalues.temperature(:));
        set(plotTemp,'Tag','saplottemperature');
        set(plotTemp,'edgecolor','none')
        set(gca,'xlim',[0,1 + Xlength])
    case 'iter'
        plotTemp = findobj(get(gca,'Children'),'Tag','saplottemperature');
        set(plotTemp,'Ydata',optimvalues.temperature(:))
end
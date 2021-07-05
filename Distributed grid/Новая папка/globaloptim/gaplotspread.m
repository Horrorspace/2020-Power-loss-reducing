function state = gaplotspread(options,state,flag)
%GAPLOTSPREAD Plots spread of individuals on Pareto front.
%
%   Example:
%    Create an options structure that will use GAPLOTSPREAD
%    as the plot function
%     options = optimoptions(@gamultiobj,'PlotFcn',@gaplotspread);

%   Copyright 2007-2016 The MathWorks, Inc.


if ~isfield(state,'Spread') 
    msg = getString(message('globaloptim:gaplotcommon:PlotFcnUnavailable','gaplotspread'));
    title(msg,'interp','none');
    return;
end

avg_spread = mean(state.Spread(end,:));
switch flag
    case 'init'
        hold on;
        set(gca,'xlim',[0,options.MaxGenerations]);
        xlabel('Generation','interp','none');
        ylabel('Average Spread','interp','none');
        plotConstr = plot(state.Generation,avg_spread,'.b');
        set(plotConstr,'Tag','gaplotavgdistance');
         title(sprintf('Average Spread: %g',avg_spread),'interp','none');
    case 'iter'
        plotSpread = findobj(get(gca,'Children'),'Tag','gaplotavgdistance');
        newX = [get(plotSpread,'Xdata') state.Generation];
        newY = [get(plotSpread,'Ydata') avg_spread];
        set(plotSpread,'Xdata',newX, 'Ydata',newY);
         title(sprintf('Average Spread: %g',avg_spread),'interp','none');
    case 'done'
        hold off;
end

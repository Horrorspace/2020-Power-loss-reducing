function state = gaplotmaxconstr(options,state,flag)
%GAPLOTMAXCONSTR Plots the maximum nonlinear constraint violation by GA.
%   STATE = GAPLOTMAXCONSTR(OPTIONS,STATE,FLAG) plots the maximum nonlinear
%   constraint violation
%
%   Example:
%    Create an options structure that will use GAPLOTMAXCONSTR
%    as the plot function
%     options = optimoptions('ga','PlotFcn',@gaplotmaxconstr);
%
%    (Note: If calling gamultiobj, replace 'ga' with 'gamultiobj') 

%   Copyright 2005-2016 The MathWorks, Inc.

% If the flag is 'interrupt' simply return
if strcmpi(flag,'interrupt')
    return;
end
if ~(isfield(state,'NonlinIneq') || isfield(state,'NonlinEq') || ...
        isfield(state,'C') || isfield(state,'Ceq'))
    msg = getString(message('globaloptim:gaplotcommon:PlotFcnUnavailable','gaplotmaxconstr'));
    title(msg,'interp','none');
    return;
end
% Maximum constraint violation
maxConstr = 0;
if isfield(state,'NonlinIneq') % GA
    maxConstr = max([maxConstr;
                     state.NonlinIneq(:);
                     abs(state.NonlinEq(:)) ]);
else % GAMULTIOBJ
    maxConstr = max([maxConstr;
                     state.C(:);
                     abs(state.Ceq(:)) ]);    
end

switch flag
    case 'init'
        hold on;
        set(gca,'xlim',[0,options.MaxGenerations]);
        xlabel('Generation','interp','none');
        ylabel('Max constraint','interp','none');
        plotConstr = plot(state.Generation,maxConstr,'.k');
        set(plotConstr,'Tag','gaplotconstr');
         title(sprintf('Max constraint: %g',maxConstr),'interp','none');
    case 'iter'
        plotConstr = findobj(get(gca,'Children'),'Tag','gaplotconstr');
        newX = [get(plotConstr,'Xdata') state.Generation];
        newY = [get(plotConstr,'Ydata') maxConstr];
        set(plotConstr,'Xdata',newX, 'Ydata',newY);
         title(sprintf('Max constraint: %g',maxConstr),'interp','none');
    case 'done'
        hold off;
end

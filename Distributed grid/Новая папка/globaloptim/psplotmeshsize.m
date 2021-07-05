function stop = psplotmeshsize(optimvalues,flag)
%PSPLOTMESHSIZE PlotFcn to plot mesh size.
%   STOP = PSPLOTBESTF(OPTIMVALUES,FLAG) where OPTIMVALUES is a structure
%   with the following fields: 
% 
%   PATTERNSEARCH:
%              x: current point X
%      iteration: iteration count
%           fval: function value
%       meshsize: current mesh size
%      funccount: number of function evaluations
%         method: method used in last iteration
%         TolFun: tolerance on function value in last iteration
%           TolX: tolerance on X value in last iteration
%
%   FLAG: Current state in which PlotFcn is called. Possible values are:
%           init: initialization state
%           iter: iteration state
%           done: final state
%
%   STOP: A boolean to stop the algorithm.
%
%   See also PATTERNSEARCH, GA, OPTIMOPTIONS.

%   Copyright 2003-2018 The MathWorks, Inc.

stop = false;
switch flag
    case 'init'
        xlabel('Iteration','interp','none'); 
        ylabel('Mesh size','interp','none');
        if isscalar(optimvalues.fval)
            title(sprintf('Current Mesh Size: %g',optimvalues.meshsize),'interp','none')
        else
            % if we have a multi-objective call to this function, we
            % display a useful title message and disable functionality
            titleStr = getString(message('globaloptim:psplotcommon:PlotFcnUnavailableMultiObj', 'psplotmeshsize'));
            title(titleStr,'interp','none');
            return;
        end
        plotMesh = plot(optimvalues.iteration,optimvalues.meshsize, 'm');
        set(plotMesh,'Tag','psplotmeshsize');
    case 'iter'
        % no updates for multi-objective
        if ~isscalar(optimvalues.fval)
            return;
        end
        plotMesh = findobj(get(gca,'Children'),'Tag','psplotmeshsize');
        newX = [get(plotMesh,'Xdata') optimvalues.iteration];
        newY = [get(plotMesh,'Ydata') optimvalues.meshsize];
        set(plotMesh,'Xdata',newX, 'Ydata',newY);
        set(get(gca,'Title'),'String',sprintf('Current Mesh Size: %g',optimvalues.meshsize)); 
end


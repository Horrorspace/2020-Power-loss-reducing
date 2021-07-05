function stop = surrogateoptplot(~,optimValues,state)
% SURROGATEOPTPLOT Plot value of the objective function after each function
% evaluation.
%
%   STOP = SURROGATEOPTPLOT(X,OPTIMVALUES,STATE) plots current, incumbent
%   and best fval.

%   Copyright 2018 The MathWorks, Inc.

persistent plotBest plotIncumbent plotRandom plotAdaptive plotInitial ... 
    legendHndl legendStr

stop = false;

if strcmpi(state,'init')
    plotBest = []; plotIncumbent = []; plotRandom = [];
    plotAdaptive = []; plotInitial = []; legendHndl = []; legendStr = {};
    xlabel('Number of Function Evaluations','interp','none');
    ylabel('Objective Function','interp','none');
    title(['Best: ',' Incumbent: ',' Current: '],'interp','none')
    hold on; grid on;
end

if optimValues.funccount == 0 || isempty(optimValues.fval)
    % no function evals or none of the trials are successfully evaluated; no plots.
    return;
end

if isempty(plotBest)
    plotBest = plot(optimValues.funccount,optimValues.fval,'go');
    set(plotBest,'Tag','surrplotbestf','MarkerSize',6);
    legendHndl(end+1) = plotBest;
    legendStr{end+1} = 'Best';
else
    newX = [get(plotBest,'Xdata') optimValues.funccount];
    newY = [get(plotBest,'Ydata') optimValues.fval];
    set(plotBest,'Xdata',newX, 'Ydata',newY);
end
if isempty(plotIncumbent)
    plotIncumbent = plot(optimValues.funccount,optimValues.incumbentFval,'bx');
    set(plotIncumbent,'Tag','surrplotincumbent','MarkerSize',4);
    legendHndl(end+1) = plotIncumbent;
    legendStr{end+1} = 'Incumbent';
else
    newX = [get(plotIncumbent,'Xdata') optimValues.funccount];
    newY = [get(plotIncumbent,'Ydata') optimValues.incumbentFval];
    set(plotIncumbent,'Xdata',newX, 'Ydata',newY);
end

if strcmpi('adaptive',optimValues.currentFlag)
    if isempty(plotAdaptive)
        plotAdaptive = plot(optimValues.funccount,optimValues.currentFval,'k.');

        set(plotAdaptive,'Tag','surrplotadaptive','MarkerSize',8);
        legendHndl(end+1) = plotAdaptive;
        legendStr{end+1} = 'Adaptive Samples';
    else
        newX = [get(plotAdaptive,'Xdata') optimValues.funccount];
        newY = [get(plotAdaptive,'Ydata') optimValues.currentFval];
        set(plotAdaptive,'Xdata',newX, 'Ydata',newY);
    end
end

if strcmpi('random',optimValues.currentFlag)
    if isempty(plotRandom)
        plotRandom = plot(optimValues.funccount,optimValues.currentFval,'cv');
        set(plotRandom,'Tag','surrplotrandom','MarkerSize',4);
        legendHndl(end+1) = plotRandom;
        legendStr{end+1} = 'Random Samples';
    else
        newX = [get(plotRandom,'Xdata') optimValues.funccount];
        newY = [get(plotRandom,'Ydata') optimValues.currentFval];
        set(plotRandom,'Xdata',newX, 'Ydata',newY);
    end
end

if strcmp(optimValues.currentFlag,'initial')
    if isempty(plotInitial)
        plotInitial = plot(optimValues.funccount,optimValues.currentFval,'md');
        %plotInitial = plot(optimValues.funccount,optimValues.currentFval,'d');
        set(plotInitial,'Tag','surrplotinitial','MarkerSize',4);
        legendHndl(end+1) = plotInitial;
        legendStr{end+1} = 'Initial Samples';
    else
        newX = [get(plotInitial,'Xdata') optimValues.funccount];
        newY = [get(plotInitial,'Ydata') optimValues.currentFval];
        set(plotInitial,'Xdata',newX, 'Ydata',newY);
    end
end

if optimValues.surrogateReset == 1 && optimValues.funccount > 1
    y = get(gca,'Ylim');
    x = optimValues.funccount;
    ll = line([x, x],y);
    if optimValues.surrogateResetCount < 2
        legendHndl(end+1) = ll;
        legendStr{end+1} = 'Surrogate Reset';
    end
end

if optimValues.checkpointResume && optimValues.funccount > 1
    y = get(gca,'Ylim');
    x = optimValues.funccount;
    ll = line([x, x],y,'Color','red','LineWidth',0.75);
    if optimValues.checkpointResumeCount < 2
        legendHndl(end+1) = ll;
        legendStr{end+1} = 'Checkpoint Resume';
    end    
end

set(get(gca,'Title'),'String', ...
    sprintf('Best: %g Incumbent: %g Current: %g',optimValues.fval, ...
    optimValues.incumbentFval, optimValues.currentFval));

legend(legendHndl, legendStr,'FontSize',8);    
        
if strcmp(state, 'done')
    hold off;
end

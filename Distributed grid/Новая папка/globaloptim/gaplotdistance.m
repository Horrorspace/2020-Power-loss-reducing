function state = gaplotdistance(options,state,flag)
%GAPLOTDISTANCE Averages several samples of distances between individuals.
%   STATE = GAPLOTDISTANCE(OPTIONS,STATE,FLAG) plots an averaged distance
%   between individuals.
%
%   Example:
%    Create an options structure that uses GAPLOTDISTANCE
%    as the plot function
%     options = optimoptions('ga','PlotFcn',@gaplotdistance);
%
%    (Note: If calling gamultiobj, replace 'ga' with 'gamultiobj') 

%   Copyright 2003-2015 The MathWorks, Inc.

samples = 20;
choices = ceil(sum(options.PopulationSize) * rand(samples,2));
switch flag
    case 'init'
        population = state.Population;
        distance = 0;
        for i = 1:samples
            d = population(choices(i,1),:) - population(choices(i,2),:);
            distance = distance + sqrt( sum ( d.* d));
        end
        plotDist = plot(state.Generation,distance/samples,'.');
        set(gca,'xlimmode','manual','zlimmode','manual', ...
            'alimmode','manual')
        set(gca,'xlim',[1,options.MaxGenerations]);
        set(plotDist,'Tag','gaplotdistance');
        xlabel('Generation','interp','none');
        ylabel('Average Distance');
        title('Average Distance Between Individuals','interp','none')

    case 'iter'
        population = state.Population;
        distance = 0;
        for i = 1:samples
            d = population(choices(i,1),:) - population(choices(i,2),:);
            distance = distance + sqrt( sum ( d.* d));
        end
        plotDist = findobj(get(gca,'Children'),'Tag','gaplotdistance');
        newX = [get(plotDist,'Xdata') state.Generation];
        newY = [get(plotDist,'Ydata') distance/samples];
        set(plotDist,'Xdata',newX,'Ydata',newY);
end

function state = gaplotparetodistance(options,state,flag)
%GAPLOTPARETODISTANCE Plots distance value of each individuals.
%
%   Example:
%    Create an options structure that will use GAPLOTPARETODISTANCE
%    as the plot function
%     options = optimoptions('ga','PlotFcn',@gaplotparetodistance);

%   Copyright 2007-2016 The MathWorks, Inc.

if ~isfield(state,'Distance') 
    msg = getString(message('globaloptim:gaplotcommon:PlotFcnUnavailable','gaplotparetodistance'));
    title(msg,'interp','none');
    return;
end

colors = ['g','m','b','k','r','c'];
subPops = populationIndices(options.PopulationSize);
[~,c] = size(subPops);

switch flag
    case 'init'
         set(gca,'xlimmode','manual','zlimmode','manual', ...
            'climmode','manual','alimmode','manual')
        % make the x axis span exactly the data size
        set(gca,'xlim',[0,1 + sum(options.PopulationSize)])
        title('Distance of individuals','interp','none')
        xlabel('Individuals');
        ylabel('Distance');
        for i = 1:c
            pop = subPops(:,i);
            range = pop(1):pop(2);
            h = bar(range,state.Distance(range),colors(1 + mod(i,5)));
            str = ['gaplotparetodistance',int2str(i)];
            set(h,'edgecolor','none','facecolor',colors(1 + mod(i,5)),'Tag',str)
            hold on;
        end
        hold off;

    case 'iter'
       for i = 1:c
            pop = subPops(:,i);
            range = pop(1):pop(2);
            str = ['gaplotparetodistance',int2str(i)];
            h = findobj(get(gca,'Children'),'Tag',str);
            set(h,'Ydata',state.Distance(range));
        end
end

function state = gaplotrankhist(~,state,flag)
%GAPLOTRANKHIST Plots a histogram of all ranks.
%
%   Example:
%    Create an options structure that will use GAPLOTRANK
%    as the plot function
%     options = optimoptions(@gamultiobj,'PlotFcn',@gaplotrank);

%   Copyright 2007-2016 The MathWorks, Inc.

if ~isfield(state,'Rank') 
    msg = getString(message('globaloptim:gaplotcommon:PlotFcnUnavailable','gaplotrankhist'));
    title(msg,'interp','none');
    return;
end

% maximum limit for x axis
maxRank = 5;

switch flag
    case 'init'
        title('Rank histogram','interp','none')
        xlabel('Rank','interp','none')
        ylabel('Number of individuals','interp','none')
        addlistener(gca,'XLim','PostSet',@gahistplotupdate);
        xlim([0 maxRank])
    case 'iter'
        allRank = state.Rank;
        h = histogram(gca, allRank,'BinMethod','integers');
        % update the xlim if necessary
        if maxRank <= h.NumBins
            set(gca,'xlim', [0, h.NumBins+1])
        end
end
function crowdingDistance = distancecrowding(pop,score,~,space)
%DISTANCECROWDING Assign local crowding distance to each individual
%   CROWDINGDISTANCE = DISTANCECROWDING(POP,SCORE,OPTIONS,SPACE) Calculates
%   crowding distance for each individuals on a non-dominated front. The
%   fourth argument SPACE can be 'phenotype' or 'genotype' for distance to
%   be in function space or decision variable space respectively.
%
%   Example:
%   Create an options structure using DISTANCECROWDING as the distance
%   function in decision variable space
%     options = optimoptions('gamultiobj','DistanceMeasureFcn',{@distancecrowding,'genotype'}); 

%   Reference: Kalyanmoy Deb, "Multi-Objective Optimization using
%   Evolutionary Algorithms", John Wiley & Sons ISBN 047187339, pg: 245 -
%   253

%   Copyright 2007-2018 The MathWorks, Inc.

if nargin < 4
    space = 'phenotype';
end

% Score should be finite to work with 'phenotype' distance 
if strcmpi(space,'phenotype') && nnz(~isfinite(score)) == 0
    y = score;
else % if strcmpi(space,'genotype')
    y = pop;
end

popSize = size(y,1);
numData = size(y,2);
crowdingDistance = zeros(popSize,1);

for m = 1:numData
    data = y(:,m);
    % Normalize obective before computing distance
    data = data./(1 + vecnorm(data(isfinite(data)),Inf));
    [~,index] = sort(data);
    % The best and worst individuals are at the end of Pareto front and
    % they are assigned Inf distance measure
    crowdingDistance([index(1),index(end)]) = Inf;
    % Distance measure of remaining individuals
    for i = 2:popSize-1
        crowdingDistance(index(i)) = crowdingDistance(index(i)) + ...
            min(Inf, (data(index(i+1)) - data(index(i-1)))); % use min(Inf, ...) to replace NaN with Inf
    end
end
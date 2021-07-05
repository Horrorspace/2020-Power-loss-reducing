function expectation = fitscalingrank(scores,nParents)
% FITSCALINGRANK Rank based fitness scaling (single objective only).
%   EXPECTATION = FITSCALINGRANK(SCORES,NPARENTS) calculates the
%   EXPECTATION using the SCORES and number of parents NPARENTS.
%   This relationship can be linear or nonlinear.
%
%   Example:
%   Create an options structure using FITSCALINGRANK as 
%   the fitness scaling function
%     options = optimoptions('ga','FitnessScalingFcn',@fitscalingrank);

%   Copyright 2003-2015 The MathWorks, Inc.

scores = scores(:);
[~,i] = sort(scores);

expectation = zeros(size(scores));
expectation(i) = 1 ./ ((1:length(scores))  .^ 0.5);

expectation = nParents * expectation ./ sum(expectation);

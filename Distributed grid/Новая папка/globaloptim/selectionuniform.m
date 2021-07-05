function parents = selectionuniform(expectation,nParents,options)
%SELECTIONUNIFORM Choose parents at random.
%   PARENTS = SELECTIONUNIFORM(EXPECTATION,NPARENTS,OPTIONS) chooses
%   PARENTS randomly using the EXPECTATION and number of parents NPARENTS. 
%
%   Parent selection is NOT a function of performance. This selection function 
%   is useful for debugging your own custom selection, or for comparison. It is 
%   not useful for actual evolution of high performing individuals. 
%
%   Example:
%   Create an options structure using SELECTIONUNIFORM as the selection
%   function.
%     options = optimoptions('ga', 'SelectionFcn', @selectionuniform);
%
%   (Note: If calling gamultiobj, replace 'ga' with 'gamultiobj') 

%   Copyright 2003-2015 The MathWorks, Inc.

expectation = expectation(:,1);
% nParents random numbers
parents = rand(1,nParents);

% integers on the interval [1, populationSize]
parents = ceil(parents * length(expectation));

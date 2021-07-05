function parents = selectionroulette(expectation,nParents,options)
%SELECTIONROULETTE Choose parents using roulette wheel.
%   PARENTS = SELECTIONROULETTE(EXPECTATION,NPARENTS,OPTIONS) chooses
%   PARENTS using EXPECTATION and number of parents NPARENTS. On each 
%   of the NPARENTS trials, every parent has a probability of being selected
%   that is proportional to their expectation.
%
%   Example:
%   Create an options structure using SELECTIONROULETTE as the selection
%   function
%     options = optimoptions('ga','SelectionFcn',@selectionroulette);
%
%   (Note: If calling gamultiobj, replace 'ga' with 'gamultiobj') 

%   Copyright 2003-2015 The MathWorks, Inc.

expectation = expectation(:,1);
wheel = cumsum(expectation) / nParents;

parents = zeros(1,nParents);
for i = 1:nParents
    r = rand;
    for j = 1:length(wheel)
        if(r < wheel(j))
            parents(i) = j;
            break;
        end
    end
end
    

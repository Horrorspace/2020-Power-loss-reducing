function o = gaoptimget(options,name,default,flag)
%GAOPTIMGET Get GA OPTIONS parameter value.
%   VAL = GAOPTIMGET(OPTIONS,'NAME') extracts the value of the named parameter
%   from optimization options structure OPTIONS, returning an empty matrix if
%   the parameter value is not specified in OPTIONS.  It is sufficient to
%   type only the leading characters that uniquely identify the
%   parameter.  Case is ignored for parameter names.  [] is a valid OPTIONS
%   argument.
%   
%   VAL = GAOPTIMGET(OPTIONS,'NAME') extracts the parameter NAME 
%   For example:
%     
%     opts = gaoptimset('Generations',200);
%     val = gaoptimget(opts,'Generations');
%   
%   returns val = 200.
%   
%   See also GAOPTIMSET.

%   Copyright 2003-2015 The MathWorks, Inc.

if nargin < 2
  error(message('globaloptim:gaoptimget:inputarg'));
end
if nargin < 3
  default = [];
end
if nargin < 4
   flag = [];
end

% convert to char array if input name is string
if isstring(name)
    name = char(name);
end

if isstring(default)
    default = char(default);
end

% undocumented usage for fast access with no error checking
if strcmp(flag, 'fast')
   o = gaoptimgetfast(options,name,default);
   return
end

if ~isempty(options) && ~isa(options,'struct')
  error(message('globaloptim:gaoptimget:firstargerror'));
end

if isempty(options)
  o = default;
  return;
end

optionsstruct = struct('PopulationType', [], ...
    'PopInitRange',[], ...
    'PopulationSize',[], ...
    'EliteCount',[], ...
    'CrossoverFraction',[], ...
    'ParetoFraction',[], ...    
    'MigrationDirection',[], ...
    'MigrationInterval',[], ...
    'MigrationFraction',[], ...
    'Generations',[], ...
    'TimeLimit',[], ...
    'FitnessLimit',[], ...
    'StallGenLimit',[], ...
    'StallTimeLimit',[], ...
    'StallTest',[], ...
    'TolFun', [], ...
    'TolCon',[], ...
    'InitialPopulation',[], ...
    'InitialScores',[], ...
    'NonlinConAlgorithm',[], ...
    'InitialPenalty', [], ...
    'PenaltyFactor', [], ...
    'PlotInterval',[], ...
    'FitnessScalingFcn',[], ...
    'SelectionFcn',[], ...
    'CrossoverFcn',[], ...
    'MutationFcn',[], ...
    'DistanceMeasureFcn',[], ...
    'Display',[], ...
    'PlotFcns',[], ...
    'OutputFcns',[], ...
    'CreationFcn',[], ...
    'HybridFcn',[], ...
    'Vectorized',[], ...
    'UseParallel',[]);      

Names = string(fieldnames(optionsstruct));
names = lower(Names);

lowName = strip(lower(name(:)'));
j = startsWith(names, lowName);
numMatches = sum(j);

if numMatches == 0 % if no matches
  error(message('globaloptim:gaoptimget:invalidproperty',name));
  
elseif numMatches > 1            % if more than one match
  % Check for any exact matches (in case any names are subsets of others)
  k = strcmp(lowName,names);

  % multiple matches
  if sum(k) == 1
      j = k;
  else
    allNames = '(' + join(Names(j), ', ') + ').';
    allNames = char(allNames);
    error(message('globaloptim:gaoptimget:ambiguousproperty',name,allNames));
  end
  
end

if any(strcmp(Names,Names(j)))
   o = options.(Names{j,:});
  if isempty(o) || any(strcmp(o, ''))
    o = default;
  end
else
  o = default;
end

%------------------------------------------------------------------
function value = gaoptimgetfast(options,name,defaultopt)
%OPTIMGETFAST Get OPTIM OPTIONS parameter with no error checking so fast.
%   VAL = OPTIMGETFAST(OPTIONS,FIELDNAME,DEFAULTOPTIONS) will get the
%   value of the FIELDNAME from OPTIONS with no error checking or
%   fieldname completion. If the value is [], it gets the value of the
%   FIELDNAME from DEFAULTOPTIONS, another OPTIONS structure which is 
%   probably a subset of the options in OPTIONS.
%

% We need to know if name is a valid field of options, but it is faster to use 
% a try-catch than to test if the field exists and if the field name is
% correct. If the options structure is from an older version of the
% toolbox, it could be missing a newer field.
try
    value = options.(name);
catch
    value = [];
end

if isstring(value)
    value = char(value);
end

if isempty(value)
    value = defaultopt.(name);
end



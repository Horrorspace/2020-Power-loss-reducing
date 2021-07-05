function [xmin,fmin,exitflag,output,trials] = surrogateopt(objfun,lb,ub,options)
%SURROGATEOPT searches for a minimum of an expensive objective function.
%
%   SURROGATEOPT attempts to solve problems of the form:
%    min F(X)
%    subject to:  LB < X < UB (bound constraints)
%
%   XMIN = SURROGATEOPT(FUN,LB,UB) searches for a minimum Xopt of the
%   function FUN, subject to bound LB(i) < X(i) < UB(i). FUN is a function
%   handle or function name. FUN accepts input vector X of length NVAR and
%   returns a scalar Fval evaluated at X. LB(i) and UB(i) must be finite
%   and satisfy LB(i) < UB(i).
%
%   XMIN = SURROGATEOPT(FUN,LB,UB,OPTIONS) searches for a minimum with the
%   default optimization parameters replaced by values in OPTIONS, an argument
%   created with the OPTIMOPTIONS function. For a list of options accepted
%   by SURROGATEOPT refer to the documentation.
%
%   XMIN = SURROGATEOPT(PROBLEM) searches for a minimum for PROBLEM.
%   PROBLEM is a structure with these fields:
%   PROBLEM.objective: The objective function handle FUN
%   PROBLEM.lb: the lower bounds LB
%   PROBLEM.ub: the upper bounds UB
%   PROBLEM.rngstate: Optional field to reset the state of RNG
%   PROBLEM.options: the options structure and
%   PROBLEM.solver: 'surrogateopt'
%
%   XMIN = SURROGATEOPT(CHECKPOINTFILE) continues search using information
%   from a checkpoint file. CHECKPOINTFILE must be a string or char
%   containing a valid path to a MAT file. Data in CHECKPOINTFILE is
%   written by SURROGATEOPT when OPTIONS.CheckpointFile is set to a file
%   name. The data in CHECKPOINTFILE is internal to SURROGATEOPT and is not
%   intended to be modified otherwise.
%
%   XMIN = SURROGATEOPT(CHECKPOINTFILE, OPTIONS) continues search using
%   information from checkpoint file and uses new OPTIONS to resume. Only
%   a subset of options can be changed when resuming from checkpoint state.
%   These options are listed below:
%   Maxtime 
%   MaxFunctionEvaluations
%   ObjectiveLimit 
%   UseParallel
%   PlotFcn
%   OutputFcn 
%   Display
%   CheckpointFile
%   MinSurrogatePoints
%
%   [XMIN,FMIN] = SURROGATEOPT(FUN,LB,UB,...) returns the value of the
%   objective function FUN at the solution XMIN.
%
%   [XMIN,FMIN,EXITFLAG] = SURROGATEOPT(FUN,LB,...) returns an EXITFLAG that
%   describes the exit condition. Possible values of EXITFLAG and the
%   corresponding exit conditions are listed below.
%
%     1  Best function value reached options.ObjectiveLimit
%     0  Number of function evaluations exceeded options.MaxFunctionEvaluations
%        or elapsed time exceeded options.MaxTime.
%    -1  Stopped by output/plot function.
%    -2  No feasible point found.
%        A lower bound lb(i) exceeds a corresponding upper bound ub(i).
%
%   [XMIN,FMIN,EXITFLAG,OUTPUT] = SURROGATEOPT(FUN,LB,...) returns a MATLAB
%   struct OUTPUT with these fields:
%      rngstate: State of the random number generator before the solver started.
%     funccount: Total number of function evaluations.
%       message: Reason why SURROGATEOPT stopped.
%   elapsedtime: Time spent running the solver in seconds, as measured by tic/toc.
%
%   [XMIN,FMIN,EXITFLAG,OUTPUT,TRIALS] = SURROGATEOPT(FUN,LB,...) returns a structure
%   TRIALS containing all the points (Npts) at which FUN was evaluated.
%   TRIALS is a MATLAB structure with these fields:
%   TRIALS.X: Matrix of size Npts-by-Nvar.
%             Each row of TRIALS.X represents one point that SURROGATEOPT evaluated.
%   TRIALS.Fval: Column vector, where each entry is the objective function
%                value of the corresponding row of TRIAL.X.
%
%   Examples
%     FUN can be specified using @:
%        X = surrogateopt(@humps,0,20)
%     In this case, F = humps(X) returns the scalar function value F of
%     the HUMPS function evaluated at X.
%
%     FUN can also be an anonymous function:
%        X = surrogateopt(@(x) (1-x(1)).^2 + 100*(x(2)-x(1).^2).^2,[-5; -5],[5; 5])
%
%   See also OPTIMOPTIONS, PATTERNSEARCH, FMINCON

%   Copyright 2018 The MathWorks, Inc.

%   REFERENCES
%       [1] A stochastic radial basis function method for the global
%           optimization of expensive functions, Rommel G. Regis and
%           Christine A. Shoemaker
%
%       [2] Combining radial basis function surrogates and dynamic
%           coordinate search in high-dimensional expensive black-box
%           optimization, Rommel G. Regis and Christine A. Shoemaker
%
%       [3] Stochastic radial basis function algorithms for large-scale
%           optimization involving expensive black-box objective and
%           constraint functions, Rommel G. Regis

if nargin < 1
    error(message('MATLAB:narginchk:notEnoughInputs'));
end

if nargin < 4
    options = [];
end

checkpointFileToRestore = [];

% One input argument is for problem structure or checkpoint resume
if nargin == 1
    if isstruct(objfun)
        [objfun,lb,ub,rngstate,options] = separateOptimStruct(objfun);
        % Reset the random number generators
        resetDfltRng(rngstate);
    elseif ischar(objfun)
        checkpointFileToRestore = objfun;
        options = struct();
    elseif isStringScalar(objfun)
        checkpointFileToRestore = char(objfun);
        options = struct();    
    else % Single input and non-structure/non-char (Throw)        
        error(message('globaloptim:surrogateopt:InvalidStructInput'));
    end
end

if nargin == 2
    if ischar(objfun)
        checkpointFileToRestore = objfun;
    elseif isStringScalar(objfun)
        checkpointFileToRestore = char(objfun);
        
    else
        error(message('globaloptim:surrogateopt:mustBeCharOrString'));
    end
    
    if (isa(lb, 'optim.options.SolverOptions') || isstruct(lb))
        options = lb;
    else % Second input in this case must be options
        error(message('globaloptim:surrogateopt:secondArgOptionsOrLB'));
    end
end

if isempty(options)
    options = optimoptions(@Surrogateopt);
end

if ~isa(options, 'optim.options.SolverOptions') && ~isstruct(options)
    % Either optimoptions or a struct.
    error(message('globaloptim:surrogateopt:optionsNotAStruct'));
end

% If options is an object, convert to a struct.
options = prepareOptionsForSolver(options, 'surrogateopt');

if ~isempty(checkpointFileToRestore)
    expensive = struct('CheckpointFile',checkpointFileToRestore);
    controller = globaloptim.bmo.BlackboxModelOptimizer(expensive,options);
else
    controller = createController(objfun,lb,ub,options);
end

% Run optimization loop
controller = controller.optimize();

[xmin,fmin,exitflag,output,trials] = controller.solution();

end

%==========================================================================
function controller = createController(objfun,lb,ub,options)

% if we have a string object input, we need to convert to char arrays
if isstring(objfun)
    if isscalar(objfun)
        objfun = char(objfun);
    else
        objfun = cellstr(objfun);
    end
end
% Only function_handle is allowed
if isempty(objfun) ||  ~(ischar(objfun) || isa(objfun,'function_handle'))
    error(message('globaloptim:surrogateopt:needFunctionHandleObj'));
end

[objfun, idandmsg] = fcnchk(objfun);
if ~isempty(idandmsg)
    error(message(idandmsg.identifier));
end

% Prepare for expensive 'model' API
expensive = struct('model', @(x) expensiveModel(x,objfun), ...
    'response', {{'Fval'}});

% Controller for a blackbox expensive model optimization using surrogates
controller = globaloptim.bmo.BlackboxModelOptimizer(expensive,lb,ub,options);
end

%==================================================================
function response = expensiveModel(x,objfun)

response.Fval = feval(objfun,x);

end

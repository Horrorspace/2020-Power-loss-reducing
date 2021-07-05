function [x, fval, exitflag, output] = simulannealbnd(FUN, x0, lb, ub, options)
%SIMULANNEALBND Bound constrained optimization using simulated annealing.
%
%   SIMULANNEALBND attempts to solve problems of the form:
%       min F(X)  subject to  LB <= X <= UB
%        X                     
%                              
%   X = SIMULANNEALBND(FUN,X0) starts at X0 and finds a local minimum X to
%   the objective function FUN. FUN accepts input X and returns a scalar
%   function value evaluated at X. X0 may be a scalar or a vector.
%
%   X = SIMULANNEALBND(FUN,X0,LB,UB) defines a set of lower and upper
%   bounds on the design variables, X, so that a solution is found in the
%   range LB <= X <= UB. Use empty matrices for LB and UB if no bounds
%   exist. Set LB(i) = -Inf if X(i) is unbounded below;  set UB(i) = Inf if 
%   X(i) is unbounded above.
%
%   X = SIMULANNEALBND(FUN,X0,LB,UB,options) minimizes with the default
%   optimization parameters replaced by values in the structure OPTIONS.
%   OPTIONS can be created with the OPTIMOPTIONS function. See OPTIMOPTIONS
%   for details. For a list of options accepted by SIMULANNEALBND refer to
%   the documentation.
%
%   X = SIMULANNEALBND(PROBLEM) finds the minimum for PROBLEM. PROBLEM is
%   a structure that has the following fields:
%      objective: <Objective function>
%             x0: <Starting point>
%             lb: <Lower bound on X>
%             ub: <Upper bound on X>
%        options: <Options created with optimoptions('simulannealbnd',...)>
%       rngstate: <State of the random number generator>
%
%   [X,FVAL] = SIMULANNEALBND(FUN, ...) returns FVAL, the value of the
%   objective function FUN at the solution X.
%
%   [X,FVAL,EXITFLAG] = SIMULANNEALBND(FUN, ...) returns EXITFLAG which
%   describes the exit condition of SIMULANNEALBND. Possible values of
%   EXITFLAG and the corresponding exit conditions are
%
%     1 Average change in value of the objective function over
%        options.MaxStallIterations iterations less than
%        options.FunctionTolerance.
%     5 options.ObjectiveLimit limit reached.
%     0 Maximum number of function evaluations or iterations exceeded.
%    -1 Optimization terminated by the output or plot function.
%    -2 No feasible point found.
%    -5 Time limit exceeded.
%
%   [X,FVAL,EXITFLAG,OUTPUT] = SIMULANNEALBND(FUN, ...) returns a
%   structure OUTPUT with the following information:
%      problemtype: Type of problem: unconstrained or bound constrained
%       iterations: Total iterations
%        funccount: Total function evaluations
%          message: Termination message of the solver
%      temperature: Temperature when solver terminated
%        totaltime: Time taken by the solver
%         rngstate: State of the random number generator before the solver started
%
%
%   Examples:
%    Minimization of Dejong's fifth function:
%     x0 = [0 0];
%     fun = @dejong5fcn;
%     [x,fval] = simulannealbnd(fun,x0)
%
%    Minimization of Dejong's fifth function subject to lower and upper
%    bounds:
%     x0 = [0 0];
%     fun = @dejong5fcn;
%     lb = [-64 -64];
%     ub = [64 64];
%     [x,fval] = simulannealbnd(fun,x0,lb,ub)
%
%     FUN can also be an anonymous function:
%     fun =  @(x) 3*sin(x(1))+exp(x(2));
%     x = simulannealbnd(fun,[1;1],[0 0])
%
%    Minimization of Dejong's fifth function while displaying plots:
%     x0 = [0 0];
%     fun = @dejong5fcn;
%     options = optimoptions('simulannealbnd', 'PlotFcn', ...
%        {@saplotbestx, @saplotbestf, @saplotx, @saplotf});
%     simulannealbnd(fun,x0,[],[],options)
%   
%   See also OPTIMOPTIONS, PATTERNSEARCH, GA, FMINSEARCH.

%   Copyright 2006-2017 The MathWorks, Inc.

% If just 'defaults' passed in, return the default options in X
if nargin == 1 && nargout <= 1 && strcmpi(FUN,'defaults')
    x = simulanneal('defaults');
    return
end
% Check number of input arguments
if nargin < 1
    errmsg = getString(message('MATLAB:narginchk:notEnoughInputs'));
elseif nargin > 5
    errmsg = getString(message('MATLAB:narginchk:tooManyInputs'));
else
    errmsg = '';
end

if ~isempty(errmsg)
    error(message('globaloptim:simulannealbnd:numberOfInputs', errmsg));
end

if nargin < 5
    options = [];
    if nargin < 4
        ub = [];
        if nargin < 3
            lb = [];
        end
    end
end

% One input argument is for problem structure
if nargin == 1
    if isa(FUN,'struct')
        [FUN,x0,lb,ub,rngstate,options] = separateOptimStruct(FUN);
        % Reset the random number generators
        resetDfltRng(rngstate);
    else % Single input and non-structure.
        error(message('globaloptim:simulannealbnd:invalidStructInput'));
    end
end

% Prepare the options for the solver
options = prepareOptionsForSolver(options, 'simulannealbnd');

% Ensure that any *Fcn options are function handles or cell arrays of
% function handles. Ideally this would be done in the /private/savalidate.m
% function (called from simulannealcommon). However, saoptimset is called
% below before the call to savalidate and this does not accept string
% values for the *Fcn options. Hence the replacement is performed here.
if isfield(options, 'AcceptanceFcn')
    options.AcceptanceFcn = replaceEnumStringWithFcnHdl(...
        'SimulannealbndOptions', 'AcceptanceFcn', options.AcceptanceFcn);
end
if isfield(options, 'AnnealingFcn')
   options.AnnealingFcn = replaceEnumStringWithFcnHdl(...
       'SimulannealbndOptions', 'AnnealingFcn', options.AnnealingFcn);
end 
if isfield(options, 'HybridFcn')
    options.HybridFcn = replaceEnumStringWithFcnHdl(...
        'SimulannealbndOptions', 'HybridFcn', options.HybridFcn);
end
if isfield(options, 'PlotFcns')
    options.PlotFcns = replaceEnumStringWithFcnHdl(...
        'SimulannealbndOptions', 'PlotFcn', options.PlotFcns);
end
if isfield(options, 'TemperatureFcn')
    options.TemperatureFcn = replaceEnumStringWithFcnHdl(...
        'SimulannealbndOptions', 'TemperatureFcn', options.TemperatureFcn);
end

% Check for non-double inputs
msg = isoptimargdbl('SIMULANNEALBND', {'LB','UB'}, lb,  ub);
if ~isempty(msg)
    error('globaloptim:simulannealbnd:dataType',msg);
end

[x, fval, exitflag, output] = simulanneal(FUN, x0, [], [], [], [], lb, ub, options);

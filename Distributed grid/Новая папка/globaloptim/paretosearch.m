function [X,FVAL,EXITFLAG,OUTPUT,RESIDUALS] = paretosearch(FUN,nvars,Aineq,bineq,Aeq,beq,lb,ub,nonlcon,options)
%PARETOSEARCH Multiobjective optimization using pattern search algorithm.
%   PARETOSEARCH attempts to solve multiobjective problems of the form:
%      min F(X)  subject to:  A*X  <= B, Aeq*X  = Beq (linear constraints)
%       X                     C(X) <= 0 (nonlinear constraints)
%                               LB <= X <= UB
% 
%   X = PARETOSEARCH(FUN,NVARS) finds a local Pareto set X of the objective
%   functions defined in FUN. NVARS is the dimension of the optimization
%   problem (number of decision variables). FUN accepts a vector X of size
%   1-by-NVARS and returns a vector of size 1-by-numberOfObjectives. X is a
%   matrix with NVARS columns. The number of rows in X is the same as the
%   number of Pareto solutions.
%
%   X = PARETOSEARCH(FUN,NVARS,A,b) finds a local Pareto set X of the
%   objective functions defined in FUN, subject to the linear
%   inequalities A*X <= b.
%
%   X = PARETOSEARCH(FUN,NVARS,A,b,Aeq,beq) finds a local Pareto set X of
%   the objective functions defined in FUN, subject to the linear
%   equalities Aeq*X = beq as well as the linear inequalities A*X <= b.
%   (Set A=[] and b=[] if no inequalities exist.)
%
%   X = PARETOSEARCH(FUN,NVARS,A,b,Aeq,beq,lb,ub) defines a set of lower
%   and upper bounds on the design variables, X, so that a local Pareto set
%   is found in the range lb <= X <= ub. Use empty matrices for lb and ub
%   if no bounds exist. Set lb(i) = -Inf if X(i) is unbounded below;  set
%   ub(i) = Inf if X(i) is unbounded above.
%
%   X = PARETOSEARCH(FUN,NVARS,A,b,Aeq,beq,lb,ub,NONLCON) finds a local
%   Pareto set X that satisfy the constraints defined in NONLCON. The
%   function NONLCON accepts X and returns the vectors C and Ceq,
%   representing the nonlinear inequalities and equalities respectively.
%   The Pareto set X must be such that C(X)<=0. Nonlinear equality
%   constraints are not currently supported. Set lb=[] and/or ub=[] if no
%   bounds exist.
%
%   X = PARETOSEARCH(FUN,NVARS,A,b,Aeq,beq,lb,ub,NONLCON,options)
%   finds a Pareto set X with the default optimization parameters replaced
%   by values in OPTIONS. OPTIONS can be created with the OPTIMOPTIONS
%   function. See OPTIMOPTIONS for details. For a list of options accepted
%   by PARETOSEARCH refer to the documentation.
%
%   X = PARETOSEARCH(PROBLEM) finds the minimum for PROBLEM. PROBLEM is a
%   structure that has the following fields:
%        objective: <Objective function>
%            nvars: <Number of design variables>
%            Aineq: <Matrix for inequality constraints>
%            bineq: <Vector for inequality constraints>
%              Aeq: <Matrix for equality constraints>
%              beq: <Vector for equality constraints>
%               lb: <Lower bound on X>
%               ub: <Upper bound on X>
%          nonlcon: <Nonlinear constraint function>
%          options: <Options created with optimoptions('paretosearch',...)>
%           solver: <solver name 'paretosearch'>
%         rngstate: <State of the random number generator>
%
%   [X,FVAL] = PARETOSEARCH(FUN,NVARS, ...) in addition returns a matrix
%   FVAL, the value of all the objective functions defined in FUN at all
%   the solutions in X. FVAL has numberOfObjectives columns and same number
%   of rows as does X.
%
%   [X,FVAL,EXITFLAG] = PARETOSEARCH(FUN,NVARS, ...) in addition returns
%   EXITFLAG which describes the exit condition of PARETOSEARCH. Possible
%   values of EXITFLAG and the corresponding exit conditions are
%
%     1  Change in the mesh size, average volume or average spread of 
%        Pareto set is smaller than options.MeshTolerance or
%        options.ParetoSetChangeTolerance.
%     0  Maximum number of iterations or function evaluations exceeded.
%    -1  Optimization terminated by the output or plot function.
%    -2  No feasible point found or problem is unbounded.
%    -5  Time limit exceeded.
%
%   [X,FVAL,EXITFLAG,OUTPUT] = PARETOSEARCH(FUN,NVARS, ...) returns a
%   structure OUTPUT with the following fields:
%       iterations:      <Number of iterations PARETOSEARCH ran for>
%       funccount:       <Total number of function evaluations>
%       volume:          <Total volume of polytope defined by Pareto points>
%       averagedistance: <Weighted average distance between Pareto points>
%       spread:          <Measure of how far apart Pareto points are from outliers in the Pareto set>
%       maxconstraint:   <Maximum constraint violation, if any>
%       message:         <PARETOSEARCH termination message>
%       rngstate:        <State of the random number generator before PARETOSEARCH started>
% 
%   [X,FVAL,EXITFLAG,OUTPUT,RESIDUALS] = PARETOSEARCH(FUN,NVARS, ...) 
%   returns a structure RESIDUALS with the following fields:
%       lower:           <Values of "lb - X">
%       upper:           <Values of "X - ub">
%       ineqlin:         <Values of "X*Aineq' - bineq">
%       eqlin:           <Values of "X*Aeq' - bineq">
%       ineqnonlin:      <Values of inequality constraints returned by nonlcon(X)>
%       eqnonlin:        <Empty field as nonlinear equality constraints are not supported at this time>
%
%   Example:
%    Multiobjective minimization of two shifted quadratic functions
%
%      fun1 = @(x) vecnorm(x-[1,2],2,2).^2;
%      fun2 = @(x) vecnorm(x+[1,2],2,2).^2;
%      % Combine two objectives 'fun1' and 'fun2'
%      funmulti = @(x) [fun1(x), fun2(x)];
%      % Bound constraints on X
%      lb = -10*ones(2,1); ub = 10*ones(2,1);
%      % Specify two initial points [0.5,0.5] and [0.75,0.25] for the problem
%      options = optimoptions('paretosearch','InitialPoints',[0.5,0.5;0.75,0.25]);
%      % Minimize using PARETOSEARCH
%      [x,fval] = paretosearch(funmulti,2,[],[],[],[],lb,ub,[],options)
%
%    Specify initial points and observe the functional and parameter
%    spaces.  View the convergence of the algorithm with respect to
%    the spread of the Pareto set.
%
%      options = optimoptions('paretosearch','InitialPoints',[0.5,0.5;0.75,0.25]);
%      options = optimoptions(options,'PlotFcn',{@psplotparetof,@psplotparetox,@psplotspread});
%      [x,fval,exitflag,output] = paretosearch(funmulti,2,[],[],[],[],lb,ub,[],options);
%
% 
%   See also PATTERNSEARCH, GA, GAMULTIOBJ, OPTIMOPTIONS
% 
%   Reference: Custodio, A. L., J. F. A. Madeira, A. I. F. Vaz, and L. N. Vicente.
%   Direct Multisearch for Multiobjective Optimization. SIAM J. Optim.,
%   21(3), 2011, pp. 1109-1140.
% 
%   Reference: Bratley, P., and B. L. Fox. Algorithm 659: Implementing Sobol's
%   quasirandom sequence generator. ACM Trans. Math. Software 14, 1988, pp.
%   88-100.
% 
%   Reference: Fleischer, M. The Measure of Pareto Optima: Applications to
%   Multi-Objective Metaheuristics. In "Proceedings of the Second
%   International Conference on Evolutionary Multi-Criterion
%   Optimization-EMO" April 2003 in Faro, Portugal. Published by
%   Springer-Verlag in the Lecture Notes in Computer Science series, Vol.
%   2632, pp. 519-53.

%   Copyright 2018 The MathWorks, Inc.

if nargin < 1
    error(message('globaloptim:paretosearch:NotEnoughInputs'));
end

% If just 'defaults' passed in, return the default options in struct form
if nargin == 1 && nargout <= 1 && strcmpi(FUN,'defaults')
    defaultopts = optimoptions('paretosearch');
    f = sort(properties(defaultopts)); % properties in alphabetical order
    for i = 1:numel(f)
        X.(f{i}) = defaultopts.(f{i});
    end
    return;
end

if nargin < 10,  options = [];
    if nargin < 9,  nonlcon = [];
        if nargin < 8, ub = [];
            if nargin < 7, lb = [];
                if nargin <6, beq = [];
                    if nargin <5, Aeq = [];
                        if nargin < 4, bineq = [];
                            if nargin <3, Aineq= [];
                            end
                        end
                    end
                end
            end
        end
    end
end

% One input argument is for problem structure
if nargin == 1
    if isa(FUN,'struct')
        [FUN,nvars,Aineq,bineq,Aeq,beq,lb,ub,nonlcon,rngstate,options] = separateOptimStruct(FUN);
        % Reset the random number generators
        resetDfltRng(rngstate);
    else % Single input and non-structure.
        error(message('globaloptim:paretosearch:invalidStructInput'));
    end
end


if isempty(options)
    options = optimoptions('paretosearch'); % default options
else 
    if isstruct(options)
        f = fieldnames(options);
        optsStruct = options;
        options = optimoptions('paretosearch');
        for i = 1:numel(f)
            options.(f{i}) = optsStruct.(f{i});
        end
    elseif ~isa(options, 'optim.options.SolverOptions')
        error(message('globaloptim:paretosearch:OptionsNotAStruct'));
    end
end

options = globaloptim.paretosearch.OptionsCheck(options);

% For calling an OutputFcn or PlotFcn, make an options object (to be
% updated later) that can be passed in
if ~isempty(options.OutputFcns) || ~isempty(options.PlotFcns)
    options.OutputPlotFcnOptions = copyForOutputAndPlotFcn(...
        optim.options.Paretosearch, options);
end

[objfun,nonlcon,nvars,OUTPUT,optimState] = ...
    globaloptim.patternsearch.psArgCheck('paretosearch',FUN,nvars,Aineq,bineq,Aeq,beq,lb,ub,nonlcon);

% more precise option checking
globaloptim.paretosearch.checkLinearConstrIllegalTypes(Aineq, bineq, Aeq, beq, lb, ub);


% Determine if we have linearly dependent constraints (or if the linear
% constraints are inconsistent)
X0 = rand(nvars,1);
[Aineq,bineq,Aeq,beq,lb,ub,~,EXITFLAG,options,OUTPUT,optimState] = ...
    globaloptim.patternsearch.pscommon('paretosearch',objfun,X0,...
    Aineq,bineq,Aeq,beq,lb,ub,nonlcon,options,OUTPUT,optimState);

if EXITFLAG < 0
    X = [];
    FVAL = [];
    RESIDUALS = struct('lower',[],'upper',[],'ineqlin',[],'eqlin',[],'ineqnonlin',[],'eqnonlin',[]);
    return;
end

AeqNull = globaloptim.patternsearch.eqconstrnullspace(Aeq,optimState.numberOfVariables);
linConstr = struct('Aineq',Aineq,'bineq',bineq,'Aeq',Aeq,'beq',beq,'lb',lb, ...
    'ub',ub,'AeqNull',AeqNull);

% Call solver
[X,FVAL,EXITFLAG,OUTPUT,CINEQ,CEQ] = globaloptim.paretosearch.driver(objfun,nonlcon,optimState,linConstr,options,OUTPUT);

% return residuals
if nargout >= 4
    [OUTPUT, RESIDUALS] = globaloptim.paretosearch.computeResiduals(X, EXITFLAG, OUTPUT, ...
        Aineq, bineq, Aeq, beq, lb, ub, CINEQ, CEQ, options.ConstraintTolerance);
end

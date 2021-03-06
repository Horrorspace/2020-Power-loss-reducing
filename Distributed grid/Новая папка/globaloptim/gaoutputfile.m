function [state, options,optchanged]  = gaoutputfile(options,state,flag,fileName,interval)
%GAOUTPUTFILE Output function for GA.
%   [STOP, OPTIONS, OPTCHANGED] = GAOUTPUTFILE(OPTIONS,STATE,FLAG,FILE, ...
%   INTERVAL) is an output function for writing GA iterative output.
%
%   OPTIONS: Options structure used by GA.
%
%   STATE: A structure containing the following information about the state
%   of the optimization:
%             Population: Population in the current generation
%                  Score: Scores of the current population
%             Generation: Current generation number
%              StartTime: Time when GA started
%               StopFlag: String containing the reason for stopping
%              Selection: Indices of individuals selected for elite,
%                         crossover and mutation
%            Expectation: Expectation for selection of individuals
%                   Best: Vector containing the best score in each generation
%        LastImprovement: Generation at which the last improvement in
%                         fitness value occurred
%    LastImprovementTime: Time at which last improvement occurred
%             NonlinIneq: Nonlinear inequality constraints at best
%                         individual
%               NonlinEq: Nonlinear equality constraints at best
%                         individual
%
%   FLAG: Current state in which OutPutFcn is called. Possible values are:
%         init: initialization state
%         iter: iteration state
%         done: final state
%
%   FILENAME: A file name where iterative output is written.
%   INTERVAL: Every 'INTERVAL' iterations are written; default = 1.
%
%   STATE: Structure containing information about the state of the
%          optimization.
%   OPTCHANGED: Boolean indicating if the options have changed.
%
%   Example:
%    Create options that use GAOUTPUTFILE as the output function
%      options = optimoptions('ga','OutputFcn', @gaoutputfile)
%
%    (Note: If calling gamultiobj, replace 'ga' with 'gamultiobj') 
%
%   See also GA, OPTIMOPTIONS, GAOUTPUTFCNTEMPLATE.

% Copyright 2005-2015 The MathWorks, Inc.

optchanged = false;
mode = 'a';
if nargin <5
    interval = 1;
end
if (rem(state.Generation,interval) ~=0)
    return;
end
% Is this problem constrained?
constrtype = isfield(state,'NonlinIneq') || isfield(state,'NonlinEq');
% Maximum constraint violation
maxConstr = 0;
if constrtype && ~isempty(state.NonlinIneq)
    maxConstr = max([0;state.NonlinIneq(:)]);
end
if constrtype && ~isempty(state.NonlinEq)
    maxConstr = max([maxConstr; abs(state.NonlinEq(:))]);
end
% Make sure that it is a valid file name.
[fid,theMessage] = fopen(fileName,mode);
if fid==-1
    error(message('globaloptim:gaoutputfile:fileWriteError', fileName, theMessage))
end

switch flag
    case 'init'
        msg = sprintf('\nIterative output generated by the GA solver at %s time', ...
            datestr(datenum(now)));
        fprintf(fid,msg);
        if ~constrtype
            fprintf(fid,'\n                                  Best           Mean      Stall\n');
            fprintf(fid,'Generation      Func-count        f(x)           f(x)    Generations\n');
        else
            fprintf(fid,'\n                              Best       Max        Stall\n');
            fprintf(fid,'Generation  Func-count        f(x)     constraint  Generations\n');
        end
    case 'iter'
        Gen      = state.Generation;
        FunEval  = Gen*length(state.Score);
        BestFval = state.Best(Gen);
        MeanFval = mean(state.Score);
        StallGen = Gen  - state.LastImprovement;
        if ~constrtype
            fprintf(fid,'%5.0f         %8.0f    %12.4g    %12.4g    %5.0f\n', ...
                Gen, FunEval, BestFval, MeanFval, StallGen);
        else
            maxConstr = max(0,max(state.NonlinIneq)) + norm(state.NonlinEq);
            fprintf(fid,'%5.0f       %8.0f  %12.6g %12.4g    %3.0f\n', ...
                Gen, FunEval, BestFval, maxConstr, StallGen);
        end
    case 'done'
        Gen      = state.Generation;
        FunEval  = Gen*length(state.Score);
        BestFval = state.Best(Gen);
        MeanFval = mean(state.Score);
        StallGen = Gen  - state.LastImprovement;
        if ~constrtype
            fprintf(fid,'%5.0f         %8.0f    %12.4g    %12.4g    %5.0f\n', ...
                Gen, FunEval, BestFval, MeanFval, StallGen);
        else
            maxConstr = max(0,max(state.NonlinIneq)) + norm(state.NonlinEq);
            fprintf(fid,'%5.0f       %8.0f  %12.6g %12.4g    %3.0f\n', ...
                Gen, FunEval, BestFval, maxConstr, StallGen);
        end
        % Find the best individual
        [unused,best] = min(state.Score);
        % Print results
        fprintf(fid,'\nOptimization terminated.\n');
        fprintf(fid,'Best function value : %g\n',BestFval);
        fprintf(fid,'Best X found by GA solver\n[');
        fprintf(fid,' %g \n',state.Population(best,:));
        fprintf(fid,']');
end
% Close file
st = fclose(fid);
if st ~= 0
    error(message('globaloptim:gaoutputfile:fileCloseError', 'Error closing file ', fileName))
end

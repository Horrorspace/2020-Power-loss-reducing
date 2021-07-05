classdef (Sealed) CustomStartPointSet < AbstractStartPointSet
%CustomStartPointSet A start point set that contains custom start points.
%   CustomStartPointSet is a set of start points that are a collection of
%   custom points for a specific optimization problem.
%
%   CS = CustomStartPointSet(STARTPOINTS) constructs a new custom start
%   point set with STARTPOINTS. STARTPOINTS is a 2 dimensional array that
%   contains each start point in each row.
%
%   CS = CustomStartPointSet(OLDCS) creates a copy of the
%   CustomStartPointSet, OLDCS.
%
%   CustomStartPointSet properties:
%       StartPointsDimension - dimension of the start points in the set
%       NumStartPoints       - number of start points in the set
%
%   CustomStartPointSet method:
%       list                - lists the start points in the set
%
%   Example:
%      Create a set with 3 custom start points.
%
%      csps = CustomStartPointSet([1 2 3 4; 2 2 2 2; 3 3 3 3]);
%
%   See also RANDOMSTARTPOINTSET

%   Copyright 2009-2015 The MathWorks, Inc.

    properties(Access = private)
        StartPoints = [];
    end
    properties(Dependent, SetAccess = private)
%STARTPOINTSDIMENSION Dimension of the start points in the set
%   The StartPointsDimension property indicates the dimension of the start
%   points. It is equivalent to the number of variables in the optimization
%   problem.
%
%   See also RANDOMSTARTPOINTSET, LIST
        StartPointsDimension;        
        
%NUMSTARTPOINTS Number of start points in the set
%   The NumStartPoints property indicates the number of the start
%   points. 
%
%   See also RANDOMSTARTPOINTSET, LIST
        NumStartPoints;                   
    end
    
    % Hidden version 1 properties
    properties(Dependent, Hidden, SetAccess = private)
        
        % DIMSTARTPOINTS Alias to StartPointsDimension
        DimStartPoints
        
    end
    
    methods
        function ctps = CustomStartPointSet(startPoints)
%CustomStartPointSet Construct a set of custom start points.
%
%   CS = CustomStartPointSet(STARTPOINTS) constructs a new custom start
%   point set with STARTPOINTS. STARTPOINTS is a 2 dimensional array that
%   contains each start point in each row.
%
%   CS = CustomStartPointSet(OLDCS) creates a copy of the
%   CustomStartPointSet, OLDCS.
%
%   CustomStartPointSet has the following method: 
%
%       list                - lists the start points in the set
%
%   See also RANDOMSTARTPOINTSET, LIST

           % Record the version of the class
           ctps.Version = 1;
           if nargin ~= 1
               errid = 'globaloptim:CustomStartPointSet:IncorrectNumArgs';
               error(message(errid));
           else
               if isa(startPoints,'CustomStartPointSet')
                   ctps = startPoints;
               elseif isnumeric(startPoints) && isreal(startPoints) && ...
                       ismatrix(startPoints) && (numel(startPoints) ~= 0)
                   ctps.StartPoints = startPoints;
               else
                   errid = 'globaloptim:CustomStartPointSet:InvalidInput';
                   error(message(errid));
               end
           end
        end
        function numStartPoints = get.NumStartPoints(obj)
            numStartPoints = size(obj.StartPoints,1);
        end
        function dimStartPoints = get.DimStartPoints(obj)
            dimStartPoints = size(obj.StartPoints,2);
        end
        function dimStartPoints = get.StartPointsDimension(obj)
            dimStartPoints = size(obj.StartPoints,2);
        end
        function startPoints = list(obj,problem)
%LIST List the start points in the set. 
%  
%   STARTPOINTS = LIST(CS) returns a CS.NumStartPoints by CS.DimStartPoints
%   array of the custom start points.
%  
%   See also CUSTOMSTARTPOINTSET, DIMSTARTPOINTS, NUMSTARTPOINTS

            % CustomStartPointSet object must be scalar. This check also
            % stops empty objects being passed to the list method.
            if ~isscalar(obj)
                error(message('globaloptim:CustomStartPointSet:list:ObjectNotScalar'));
            end

            if nargin == 2
                % Check whether problem is a structure
                if ~isstruct(problem)
                    error(message('globaloptim:CustomStartPointSet:list:ProblemNotAStruct'))
                end
                % Check x0 field in problem
                obj.checkProblemX0Field(problem);
                dimX0 = numel(problem.x0);
                if obj.DimStartPoints ~= dimX0
                    error(message('globaloptim:CustomStartPointSet:list:InvalidDimStartPointSet'));
                end
            end

            startPoints = obj.StartPoints;
        end
    end
end
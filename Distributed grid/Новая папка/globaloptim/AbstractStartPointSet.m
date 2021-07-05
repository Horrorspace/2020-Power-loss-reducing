classdef (Hidden) AbstractStartPointSet
%AbstractStartPointSet Start point set class.
%   AbstractStartPointSet is an abstract class representing a start point
%   set. You cannot create instances of this class directly.  You must
%   create a derived class such as CustomStartPointSet or
%   RandomStartPointSet, by calling the class constructor.
%
%   All start point sets that inherit from AbstractStartPointSet have the
%   following method:
%
%   AbstractStartPointSet method:
%       list                - lists the start points in the set
%
%   See also ABSTRACTGENERATEDSTARTPOINTSET, CUSTOMSTARTPOINTSET

%   Copyright 2009-2011 The MathWorks, Inc.
        
    properties(Access = protected)
        % Protected property to keep track of the version for the objects
        Version
    end
    methods (Abstract)
        startPoints = list(obj,problem)
    end
    methods (Access = protected, Static)
        function checkProblemX0Field(problem)
            % Check if x0 is a field in problem
            if ~isfield(problem,'x0')
                errid = 'globaloptim:AbstractStartPointSet:checkProblemX0Field:X0NotAField';
                error(message(errid,'x0'));
            % Check the content of x0
            elseif isempty(problem.x0)
                errid = 'globaloptim:AbstractStartPointSet:checkProblemX0Field:MissingX0';
                error(message(errid,'x0'));                           
            elseif ~isnumeric(problem.x0)
                errid = 'globaloptim:AbstractStartPointSet:checkProblemX0Field:NonNumericX0';
                error(message(errid,'x0'));
            end
        end
    end
    
end % classdef

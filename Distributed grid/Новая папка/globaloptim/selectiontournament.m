function parents = selectiontournament(expectation,nParents,options,tournamentSize)
%SELECTIONTOURNAMENT Each parent is the best of a random set.
%   PARENTS = SELECTIONTOURNAMENT(EXPECTATION,NPARENTS,OPTIONS,TOURNAMENTSIZE)
%   chooses the PARENTS by selecting the best TOURNAMENTSIZE players out of
%   NPARENTS with EXPECTATION and then choosing the best individual
%   out of that set.
%
%   Example:
%   Create an options structure using SELECTIONTOURNAMENT as the selection
%   function and use the default TOURNAMENTSIZE of 4
%     options = optimoptions('ga','SelectionFcn',@selectiontournament);
%
%   Create an options structure using SELECTIONTOURNAMENT as the
%   selection function and specify TOURNAMENTSIZE to be 3.
%
%     tournamentSize = 3;
%     options = optimoptions('ga','SelectionFcn', ...
%               {@selectiontournament, tournamentSize});
%
%   (Note: If calling gamultiobj, replace 'ga' with 'gamultiobj')

%   Copyright 2003-2017 The MathWorks, Inc.

% How many players in each tournament?
if nargin < 4 || isempty(tournamentSize)
    tournamentSize = 4;
end

% Choose the players
playerlist = ceil(size(expectation,1) * rand(nParents,tournamentSize));
% Play tournament
parents = tournament(playerlist,expectation);

function champions = tournament(playerlist,expectation)
%tournament between players based on their expectation

playerSize = size(playerlist,1);
champions = zeros(1,playerSize);
% For each set of players
for i = 1:playerSize
    players = playerlist(i,:);
    % For each tournament
    winner = players(1); % Assume that the first player is the winner
    for j = 2:length(players) % Winner plays against each other consecutively
        score1 = expectation(winner,:);
        score2 = expectation(players(j),:);
        if score2(1) > score1(1)
            winner = players(j);
        elseif score2(1) == score1(1) && ... % score(1) is an integer rank
                (length(score1) > 1 && score2(2) > score1(2))
            % socre(2) may not be present for single objective problems
            winner = players(j);
        end
    end
    champions(i) = winner;
end


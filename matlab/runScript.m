%% Set data
clear; clc;

playerNum = 1;
gameNum = 10;

% currentGames_player = [2, 1, 2, 2, 2, 2, 3, 2];   % Current games of player
 currentGames_player = [2, 1, 2, 2, 2, 2, 3, 2, 2, 2];

%% Create Name array

playerNameArray   = ["Struff_JL","Rodionov_J","Shevchenko_A","Alcaraz_C"];
opponentNameArray = ["Ruud_C","Baez_S","Medjedovic_H","Hanfmann_Y"];

%% Run the appropriate script

playerName   = playerNameArray(playerNum);
opponentName = opponentNameArray(1,playerNum);

playerName = convertStringsToChars(playerName);
opponentName = convertStringsToChars(opponentName);

if gameNum == 6
    run games_6_Prediction
elseif gameNum == 8
    run games_8_prediction
elseif gameNum == 10
    run games_10_prediction
elseif gameNum == 12
    run games_12_prediction
else
    % Do nothing
end

clearvars -except playerName opponentName dataMatrix_player dataMatrix_opponent currentGames_player














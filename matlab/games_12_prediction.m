
playerName = 'Moutet_C';
opponentName = 'Zverev_A';
% 
% playerName = 'Zverev_A';
% opponentName = 'Kotov_P';
% 

currentGames_player = [3, 1, 2, 2, 2, 2, 2, 2, 2, 2, 3, 1];   % Current games of player

currentGames = currentGames_player;
%% Train neural network

% Define the name of the folder where the file is located
folderName = strcat('Tennis_',playerName);
% Use fullfile to create the full file path
fullFilePath = fullfile(folderName, playerName);
% Load the file using the full file path
load(fullFilePath);
eval([playerName ' = dataMatrix;']);
clear dataMatrix

% Define the name of the folder where the file is located
folderName = strcat('Tennis_',opponentName);
% Use fullfile to create the full file path
fullFilePath = fullfile(folderName, opponentName);
% Load the file using the full file path
load(fullFilePath);
eval([opponentName ' = dataMatrix;']);
clear dataMatrix

dataMatrix_player = eval(playerName);
dataMatrix_opponent = eval(opponentName);


ind_Player = find(sum(dataMatrix_player(:,1:12),2) == 24);
dataMatrix_player = dataMatrix_player(ind_Player,:);

ind_Opponent = find(sum(dataMatrix_opponent(:,1:12),2) == 24);
dataMatrix_opponent = dataMatrix_opponent(ind_Opponent,:);


% Player
T = array2table(dataMatrix_player, 'VariableNames',{'g1','g2','g3','g4','g5','g6','g7','g8','g9','g10','g11','g12','g13','g14',...
    'g15','g16','g17','g18','g19','resultNumeric'});
result = {};
for i=1:1:size(dataMatrix_player,1)
    if dataMatrix_player(i,20) == 1
        result{i,1} = 'win';
    else
        result{i,1} = 'loss';
    end
end
T = addvars(T,result,'After',"resultNumeric");
T = removevars(T,'g13'); T = removevars(T,'g14'); T = removevars(T,'g15'); 
T = removevars(T,'g16'); T = removevars(T,'g17'); T = removevars(T,'g18'); T = removevars(T,'g19'); T = removevars(T,'resultNumeric');

T.result = categorical(T.result,["win","loss"],"Ordinal",true);
T.g1 = categorical(T.g1,[3,2,1,0],"Ordinal",true); T.g2 = categorical(T.g2,[3,2,1,0],"Ordinal",true); T.g3 = categorical(T.g3,[3,2,1,0],"Ordinal",true); 
T.g4 = categorical(T.g4,[3,2,1,0],"Ordinal",true); T.g5 = categorical(T.g5,[3,2,1,0],"Ordinal",true); T.g6 = categorical(T.g6,[3,2,1,0],"Ordinal",true);
T.g7 = categorical(T.g7,[3,2,1,0],"Ordinal",true); T.g8 = categorical(T.g8,[3,2,1,0],"Ordinal",true); T.g9 = categorical(T.g9,[3,2,1,0],"Ordinal",true);
T.g10 = categorical(T.g10,[3,2,1,0],"Ordinal",true); T.g11 = categorical(T.g11,[3,2,1,0],"Ordinal",true); T.g12 = categorical(T.g12,[3,2,1,0],"Ordinal",true);
rng("default")
c = cvpartition(T.result,"Holdout",0.20);
trainingIndices = training(c); % Indices for the training set
testIndices = test(c); % Indices for the test set
creditTrain = T(trainingIndices,:);
creditTest = T(testIndices,:);
Md_player = fitcnet(creditTrain,"result");
testAccuracy_player = 1 - loss(Md_player,creditTest,"result","LossFun","classiferror");


% Opponent
T = array2table(dataMatrix_opponent, 'VariableNames',{'g1','g2','g3','g4','g5','g6','g7','g8','g9','g10','g11','g12','g13','g14',...
    'g15','g16','g17','g18','g19','resultNumeric'});
result = {};
for i=1:1:size(dataMatrix_opponent,1)
    if dataMatrix_opponent(i,20) == 1
        result{i,1} = 'win';
    else
        result{i,1} = 'loss';
    end
end
T = addvars(T,result,'After',"resultNumeric");
T = removevars(T,'g13'); T = removevars(T,'g14'); T = removevars(T,'g15'); 
T = removevars(T,'g16'); T = removevars(T,'g17'); T = removevars(T,'g18'); T = removevars(T,'g19'); T = removevars(T,'resultNumeric');

T.result = categorical(T.result,["win","loss"],"Ordinal",true);
T.g1 = categorical(T.g1,[3,2,1,0],"Ordinal",true); T.g2 = categorical(T.g2,[3,2,1,0],"Ordinal",true); T.g3 = categorical(T.g3,[3,2,1,0],"Ordinal",true); 
T.g4 = categorical(T.g4,[3,2,1,0],"Ordinal",true); T.g5 = categorical(T.g5,[3,2,1,0],"Ordinal",true); T.g6 = categorical(T.g6,[3,2,1,0],"Ordinal",true);
T.g7 = categorical(T.g7,[3,2,1,0],"Ordinal",true); T.g8 = categorical(T.g8,[3,2,1,0],"Ordinal",true); T.g9 = categorical(T.g9,[3,2,1,0],"Ordinal",true);
T.g10 = categorical(T.g10,[3,2,1,0],"Ordinal",true); T.g11 = categorical(T.g11,[3,2,1,0],"Ordinal",true); T.g12 = categorical(T.g12,[3,2,1,0],"Ordinal",true);
rng("default")
c = cvpartition(T.result,"Holdout",0.20);
trainingIndices = training(c); % Indices for the training set
testIndices = test(c); % Indices for the test set
creditTrain = T(trainingIndices,:);
creditTest = T(testIndices,:);
Md_opponent = fitcnet(creditTrain,"result");
testAccuracy_opponent = 1 - loss(Md_opponent,creditTest,"result","LossFun","classiferror");

%% Use neural network for prediction

% Prediction for the player
clc

currentGamesArray = array2table(currentGames, 'VariableNames',{'g1','g2','g3','g4','g5','g6','g7','g8','g9','g10','g11','g12'});
currentGamesArray.g1 = categorical(currentGamesArray.g1,[3,2,1,0],"Ordinal",true); currentGamesArray.g2 = categorical(currentGamesArray.g2,[3,2,1,0],"Ordinal",true); 
currentGamesArray.g3 = categorical(currentGamesArray.g3,[3,2,1,0],"Ordinal",true);  currentGamesArray.g4 = categorical(currentGamesArray.g4,[3,2,1,0],"Ordinal",true);
currentGamesArray.g5 = categorical(currentGamesArray.g5,[3,2,1,0],"Ordinal",true); currentGamesArray.g6 = categorical(currentGamesArray.g6,[3,2,1,0],"Ordinal",true);
currentGamesArray.g7 = categorical(currentGamesArray.g7,[3,2,1,0],"Ordinal",true); currentGamesArray.g8 = categorical(currentGamesArray.g8,[3,2,1,0],"Ordinal",true);
currentGamesArray.g9 = categorical(currentGamesArray.g9,[3,2,1,0],"Ordinal",true); currentGamesArray.g10 = categorical(currentGamesArray.g10,[3,2,1,0],"Ordinal",true);
currentGamesArray.g11 = categorical(currentGamesArray.g11,[3,2,1,0],"Ordinal",true); currentGamesArray.g12 = categorical(currentGamesArray.g12,[3,2,1,0],"Ordinal",true);
result = {};result{1,1} = 'win';
currentGamesArray = addvars(currentGamesArray,result,'After',"g6");

predictedResult = predict(Md_player,currentGamesArray(1,:));
predictedResult = string(predictedResult);
disp('Player prediction is:') ; disp(predictedResult);
disp('Prediction accuracy of player'); disp(testAccuracy_player);

% Prediction for the opponent
opponentGames = 4*ones(1,length(currentGames));
currentGames = opponentGames - currentGames;


currentGamesArray = array2table(currentGames, 'VariableNames',{'g1','g2','g3','g4','g5','g6','g7','g8','g9','g10','g11','g12'});
currentGamesArray.g1 = categorical(currentGamesArray.g1,[1,0],"Ordinal",true); currentGamesArray.g2 = categorical(currentGamesArray.g2,[1,0],"Ordinal",true); 
currentGamesArray.g3 = categorical(currentGamesArray.g3,[1,0],"Ordinal",true);  currentGamesArray.g4 = categorical(currentGamesArray.g4,[1,0],"Ordinal",true);
currentGamesArray.g5 = categorical(currentGamesArray.g5,[1,0],"Ordinal",true); currentGamesArray.g6 = categorical(currentGamesArray.g6,[1,0],"Ordinal",true);
currentGamesArray.g7 = categorical(currentGamesArray.g7,[1,0],"Ordinal",true); currentGamesArray.g8 = categorical(currentGamesArray.g8,[1,0],"Ordinal",true);
currentGamesArray.g9 = categorical(currentGamesArray.g9,[1,0],"Ordinal",true); currentGamesArray.g10 = categorical(currentGamesArray.g10,[1,0],"Ordinal",true);
currentGamesArray.g11 = categorical(currentGamesArray.g11,[1,0],"Ordinal",true); currentGamesArray.g12 = categorical(currentGamesArray.g12,[1,0],"Ordinal",true);
result = {};result{1,1} = 'win';
currentGamesArray = addvars(currentGamesArray,result,'After',"g4");

predictedResult = predict(Md_opponent,currentGamesArray(1,:));
predictedResult = string(predictedResult);
disp('Opponent prediction is:') ; disp(predictedResult);
disp('Prediction accuracy of opponent'); disp(testAccuracy_opponent);
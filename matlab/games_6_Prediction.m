
% playerName = 'Murray_A';
% opponentName = 'Karatsev_A';

% playerName = 'Thompson_J';
% opponentName = 'Safiullin_R';
% 
% currentGames_player = [2, 2, 2, 2, 2, 2];   % Current games of player
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
T = removevars(T,'g7'); T = removevars(T,'g8'); T = removevars(T,'g9'); T = removevars(T,'g10'); 
T = removevars(T,'g11'); T = removevars(T,'g12');T = removevars(T,'g13'); T = removevars(T,'g14'); T = removevars(T,'g15'); 
T = removevars(T,'g16'); T = removevars(T,'g17'); T = removevars(T,'g18'); T = removevars(T,'g19'); T = removevars(T,'resultNumeric');

T.result = categorical(T.result,["win","loss"],"Ordinal",true);
T.g1 = categorical(T.g1,[3,2,1,0],"Ordinal",true); T.g2 = categorical(T.g2,[3,2,1,0],"Ordinal",true); T.g3 = categorical(T.g3,[3,2,1,0],"Ordinal",true); 
T.g4 = categorical(T.g4,[3,2,1,0],"Ordinal",true); T.g5 = categorical(T.g5,[3,2,1,0],"Ordinal",true); T.g6 = categorical(T.g6,[3,2,1,0],"Ordinal",true);
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
T = removevars(T,'g7'); T = removevars(T,'g8'); T = removevars(T,'g9'); T = removevars(T,'g10'); 
T = removevars(T,'g11'); T = removevars(T,'g12');T = removevars(T,'g13'); T = removevars(T,'g14'); T = removevars(T,'g15'); 
T = removevars(T,'g16'); T = removevars(T,'g17'); T = removevars(T,'g18'); T = removevars(T,'g19'); T = removevars(T,'resultNumeric');

T.result = categorical(T.result,["win","loss"],"Ordinal",true);
T.g1 = categorical(T.g1,[3,2,1,0],"Ordinal",true); T.g2 = categorical(T.g2,[3,2,1,0],"Ordinal",true); T.g3 = categorical(T.g3,[3,2,1,0],"Ordinal",true); 
T.g4 = categorical(T.g4,[3,2,1,0],"Ordinal",true); T.g5 = categorical(T.g5,[3,2,1,0],"Ordinal",true); T.g6 = categorical(T.g6,[3,2,1,0],"Ordinal",true);
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

currentGamesArray = array2table(currentGames, 'VariableNames',{'g1','g2','g3','g4','g5','g6'});
currentGamesArray.g1 = categorical(currentGamesArray.g1,[3,2,1,0],"Ordinal",true); currentGamesArray.g2 = categorical(currentGamesArray.g2,[3,2,1,0],"Ordinal",true); 
currentGamesArray.g3 = categorical(currentGamesArray.g3,[3,2,1,0],"Ordinal",true);  currentGamesArray.g4 = categorical(currentGamesArray.g4,[3,2,1,0],"Ordinal",true);
currentGamesArray.g5 = categorical(currentGamesArray.g5,[3,2,1,0],"Ordinal",true); currentGamesArray.g6 = categorical(currentGamesArray.g6,[3,2,1,0],"Ordinal",true);
result = {};result{1,1} = 'win';
currentGamesArray = addvars(currentGamesArray,result,'After',"g6");

predictedResult = predict(Md_player,currentGamesArray(1,:));
predictedResult = string(predictedResult);
disp('Player prediction is:') ; disp(predictedResult);
disp('Prediction accuracy of player'); disp(testAccuracy_player);

% Prediction for the opponent
opponentGames = 4*ones(1,length(currentGames));
currentGames = opponentGames - currentGames;


currentGamesArray = array2table(currentGames, 'VariableNames',{'g1','g2','g3','g4','g5','g6'});
currentGamesArray.g1 = categorical(currentGamesArray.g1,[3,2,1,0],"Ordinal",true); currentGamesArray.g2 = categorical(currentGamesArray.g2,[3,2,1,0],"Ordinal",true); 
currentGamesArray.g3 = categorical(currentGamesArray.g3,[3,2,1,0],"Ordinal",true);  currentGamesArray.g4 = categorical(currentGamesArray.g4,[3,2,1,0],"Ordinal",true);
currentGamesArray.g5 = categorical(currentGamesArray.g5,[3,2,1,0],"Ordinal",true); currentGamesArray.g6 = categorical(currentGamesArray.g6,[3,2,1,0],"Ordinal",true);
result = {};result{1,1} = 'win';
currentGamesArray = addvars(currentGamesArray,result,'After',"g4");

predictedResult = predict(Md_opponent,currentGamesArray(1,:));
predictedResult = string(predictedResult);
disp('Opponent prediction is:') ; disp(predictedResult);
disp('Prediction accuracy of opponent'); disp(testAccuracy_opponent);

%% Prediction accuracy of the exact result
% % For player
% logicalMask = all(dataMatrix_player(:,1:6) == currentGames_player, 2);
% ind = find(logicalMask);
% totalResult = 0;
% for i=1:1:length(ind)
%     totalResult = totalResult + dataMatrix_player(ind(i),20);
% end
% winPercentage = totalResult/length(ind); 
% % disp('Win percentage of actual result for player is: '); disp(winPercentage);
% 
% currentGames_opponent = 4*ones(1,length(currentGames_player));
% currentGames_opponent = currentGames_opponent - currentGames_player;
% logicalMask = all(dataMatrix_opponent(:,1:6) == currentGames_opponent, 2);
% ind = find(logicalMask);
% totalResult = 0;
% for i=1:1:length(ind)
%     totalResult = totalResult + dataMatrix_opponent(ind(i),20);
% end
% winPercentage = totalResult/length(ind); 
% % disp('Win percentage of actual result for opponent is: '); disp(winPercentage);


%% Should a bet be placed- determination


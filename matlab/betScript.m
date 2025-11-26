%% Create Data Matrix

% Convert string 'a' to array var
n = 1;
addMinus = 0;
var = zeros(1,10);
for i=1:1:length(a)
    currentCharacter = a(i); commaString = ','; minusString = '-';
    if strcmp(currentCharacter,commaString) == 1
        continue  % Go to next character
    else
        if strcmp(currentCharacter,minusString) == 1
            addMinus = 1;
            continue
        else
            if addMinus == 1
                var(n) = -1;
                addMinus = 0;
            else
                var(n) = str2double(currentCharacter);
            end
            n = n + 1;
        end
    end
end

%var = cat(2,var1,var3);


dataMatrix = zeros(5000,20);

rowNum = 1;
columnNum = 1;

for i=1:1:length(var)
    currentValue = var(i);
    if currentValue ~= -1
       dataMatrix(rowNum,columnNum) =  currentValue;
       columnNum = columnNum + 1;
    else
        % Check if set was won or loss
        setValue = var(i-1);
        if setValue == 9
            dataMatrix(rowNum,20) = 1;  % Set was won
        else
            dataMatrix(rowNum,20) = 0;  % Set was lost
        end
        dataMatrix(rowNum,columnNum-1) = 0;

        rowNum = rowNum + 1;
        columnNum = 1;
    end
end

dataMatrix = dataMatrix(any(dataMatrix,2),:);

%% Train neural network
load('dataMatrix.mat')
T = array2table(dataMatrix, 'VariableNames',{'g1','g2','g3','g4','g5','g6','g7','g8','g9','g10','g11','g12','g13','g14',...
    'g15','g16','g17','g18','g19','resultNumeric'});
result = {};
for i=1:1:size(dataMatrix,1)
    if dataMatrix(i,20) == 1
        result{i,1} = 'win';
    else
        result{i,1} = 'loss';
    end
end
T = addvars(T,result,'After',"resultNumeric");
T = removevars(T,'g7'); T = removevars(T,'g8'); T = removevars(T,'g9'); T = removevars(T,'g10'); T = removevars(T,'g11'); T = removevars(T,'g12');
T = removevars(T,'g13'); T = removevars(T,'g14'); T = removevars(T,'g15'); T = removevars(T,'g16'); T = removevars(T,'g17'); T = removevars(T,'g18');
T = removevars(T,'g19'); T = removevars(T,'resultNumeric');

T.result = categorical(T.result,["win","loss"],"Ordinal",true);
rng("default")
c = cvpartition(T.result,"Holdout",0.20);
trainingIndices = training(c); % Indices for the training set
testIndices = test(c); % Indices for the test set
creditTrain = T(trainingIndices,:);
creditTest = T(testIndices,:);
Mdl = fitcnet(creditTrain,"result");
testAccuracy = 1 - loss(Mdl,creditTest,"result","LossFun","classiferror");
disp(testAccuracy);

% predictRow = 2;
% predict(Mdl,creditTest(predictRow,:));

% predictResults = {};
% for j=1:1:size(creditTest,1)
%     predictRow = j;
%     predictResults{j,1} = predict(Mdl,creditTest(predictRow,:));
% end
%% Use neural network for prediction

currentGames = [1 , 1, 1, 1, 2, 2];

currentGamesArray = array2table(currentGames, 'VariableNames',{'g1','g2','g3','g4','g5','g6'});
result = {};result{1,1} = 'win';
currentGamesArray = addvars(currentGamesArray,result,'After',"g6");

predict(Mdl,currentGamesArray(1,:))

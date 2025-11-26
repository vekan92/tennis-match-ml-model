%%  Set data
clear
clc

% Specify the URL and names array
namesArray = {'Tomas Martin Etcheverry','Carlos Alcaraz','Tallon Griekspoor','Marketa Vondrousova'};  % Names of player (Always choose the right hand name on url)

% Array of corresponding URLs
urlArray = {'https://www.tennislive.net/atp/match/tomas-martin-etcheverry-VS-casper-ruud/china-open-beijing-2023/';
    'https://www.tennislive.net/atp/match/carlos-alcaraz-garfia-VS-lorenzo-musetti/china-open-beijing-2023/';
    'https://www.tennislive.net/atp/match/tallon-griekspoor-VS-sebastian-korda/astana-open-astana-2023/';
    ''};

%% Create Name array

playerNameArray   = ["Etcheverry_TM","Alcaraz_C","Griekspoor_T","Vondrousova_M"];
opponentNameArray = ["Ruud_C","Musetti_L","Korda_S","Kalinina_A"];

%% Run loop consistently

betPlacedArray = zeros(1,length(namesArray));
setNumberArray = ones(1,length(namesArray));

a = 0;
while(a == 0)

    for i=1:1:length(namesArray)
        
        playerName = namesArray{1,i};
        url = urlArray{i,1};
        if isempty(url)
            continue;
        else
        end

        setNumber = getSetNumber(url);
        prevSet = setNumberArray(1,i);
        if setNumber > prevSet
            % New set is being played
            setNumberArray(1,i) = setNumber;
            betPlacedArray(1,i) = 0;
        else
        end

        betPlaced = betPlacedArray(1,i);
        if betPlaced == 1
            continue;
        else
        end


        currentGames_player = getCurrentScore(url,playerName); % Get current games of the player
        disp(currentGames_player);

        playerName   = playerNameArray(1,i);     playerName = convertStringsToChars(playerName);
        opponentName = opponentNameArray(1,i);   opponentName = convertStringsToChars(opponentName);

        gameNum = length(currentGames_player);
        if gameNum == 6 && sum(currentGames_player) == 12
            [predictedResult_player,predictedResult_opponent] = getPredictedResultGame6(playerName,opponentName,currentGames_player);
        elseif gameNum == 8 && sum(currentGames_player) == 16
            [predictedResult_player,predictedResult_opponent] = getPredictedResultGame8(playerName,opponentName,currentGames_player);
        elseif gameNum == 10 && sum(currentGames_player) == 20
            [predictedResult_player,predictedResult_opponent] = getPredictedResultGame10(playerName,opponentName,currentGames_player);
        elseif gameNum == 12 && sum(currentGames_player) == 24
            [predictedResult_player,predictedResult_opponent] = getPredictedResultGame12(playerName,opponentName,currentGames_player);
        else
            continue;
        end

        if strcmp(predictedResult_player,predictedResult_opponent) == 1
            % Same results predicted - Do nothing
        else
            % Different results predicted - Place a bet
            if strcmp(predictedResult_player,'win') == 1
                disp('Place a bet on player: '); disp(playerName);
                disp('currentGames of player: '); disp(currentGames_player);
            else
                disp('Place a bet on opponent: '); disp(opponentName);
                disp('currentGames of player: '); disp(currentGames_player);
            end
            makeMultipleBeeps(); % Make a sound

            % Prompt the user for input
            userInput = input('Please enter "yes" to continue: ', 's');  % 's' reads input as a string         
            % Loop until the user enters 'yes'
            while ~strcmpi(userInput, 'yes')
                fprintf('You entered "%s". Please enter "yes" to continue: ', userInput);
                userInput = input('', 's');
            end           
            % Continue with the script
            fprintf('User entered "yes". Continuing with the script...\n');            
            pause(2)
            clc
            betPlacedArray(1,i) = 1;
        end

    end

    pause(5);
    clc

end


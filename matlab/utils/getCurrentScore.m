function currentGames_player = getCurrentScore(url,playerName)
html = webread(url);

% Parse the HTML content
tree = htmlTree(html);

% Use the CSS selector to locate elements
selector = 'td[class="mp_info_txt"]';
elements = findElement(tree, selector);


str = extractHTMLText(elements);
ind= find(str == '0-0');  % Find indexes of set starts
startEntry = ind(length(ind));  % Start with the latest set

currentGames_player = [];
count = 1;
prevScore = 0;

% Determine serving order
elementCurrent = elements(startEntry);
parentElement = elementCurrent.Parent; 
parentElementServe = findElement(parentElement,'td[class="mp_serve"]');
%parentElementServe = findElement(parentElement,'img[src="https://www.tennislive.net/styles/images/tennis_ball.gif"]');
serveNames = extractHTMLText(parentElementServe);  % Find nodes that contain the serve name
serveNames(find(serveNames == "")) = [];  % Remove empty entry
if strcmp(serveNames,playerName) == 1
    % Player begins serving
    serve = 1;
else
    % Oponent begins serve
    serve = 0;
end

for i=startEntry+1:1:length(elements)
    elementCurrent = elements(i);
    currentScore = convertStringsToChars(extractHTMLText(elementCurrent));
    playerScore = str2double (currentScore(1));  % Result of cuurent game

    if serve == 1
        % playerNameServe is serving
        if playerScore > prevScore
            % Serving point has been won
            currentGames_player(1,count) = 2;
        else
            % Serving point has been lost
            currentGames_player(1,count) = 1;
        end
        serve = 0;
    else
        if playerScore > prevScore
            % Break point has been won
            currentGames_player(1,count) = 3;
        else
            % Break point has been won
            currentGames_player(1,count) = 2;
        end
        serve = 1;
    end
    prevScore = playerScore;
    count = count + 1;
end

if length(currentGames_player)> 12
    currentGames_player = currentGames_player(1,1:12);
else
    % Do nothing
end

end

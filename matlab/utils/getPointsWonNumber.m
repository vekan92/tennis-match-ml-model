function pointsWonNumber = getPointsWonNumber(digitsArray)

prevPoint = 1;
pointsWonNumber = 0;
opponentAdvantage = 0;

% Go through all entries of the point list
for i = 1:length(digitsArray)

    currentPoint = digitsArray(i);
    
    if currentPoint > prevPoint
        pointsWonNumber = pointsWonNumber + 1;
    else
        if currentPoint == 4 && prevPoint == 4 && i > 6
            if opponentAdvantage == 1
                pointsWonNumber = pointsWonNumber + 1;
                opponentAdvantage = 0;
            else
                opponentAdvantage = 1;
            end
        else
        end
    end
    prevPoint = currentPoint;
end

if pointsWonNumber*2 > length(digitsArray)
    pointsWonNumber = pointsWonNumber + 1; % Final point won as well
else
    % Final point was lost
end
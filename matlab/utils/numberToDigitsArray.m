function digitsArray = numberToDigitsArray(number)
    % Convert the number to a string
    numberStr = num2str(number);

    % Initialize an array to store the digits
    digitsArray = zeros(1, numel(numberStr));

    % Convert each character of the string to a numerical value
    for i = 1:numel(numberStr)
        digitsArray(i) = str2double(numberStr(i));
    end
end
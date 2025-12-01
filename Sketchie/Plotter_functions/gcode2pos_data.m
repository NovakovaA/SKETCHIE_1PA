function [xData, yData] = gcode2pos_data(values, pen_color)
    xData = [];
    yData = [];
    
    % plotting params
    axis equal;
    axis([0 148 0 210]); % A5


    for i = 1:length(values)
        newline = strtrim(values(i));

        if startsWith(newline, "G0") || startsWith(newline, "G1")
            %{
            Searches the text in newline for the pattern 'X<number>',
            the number can be decimal, the part after 'X' is captured as a token (number after X)
            and returned in `xStr`
            %}
            xStr = regexp(newline, 'X([0-9]*\.?[0-9]+)', 'tokens');
            yStr = regexp(newline, 'Y([0-9]*\.?[0-9]+)', 'tokens');
    
            if ~isempty(xStr)
                x = str2double(xStr{1}{1});
            else
                x = [];
            end

            if ~isempty(yStr)
                y = str2double(yStr{1}{1});
            else
                y = [];
            end


            xData = [xData, x]; % rewriting start values
            yData = [yData, y];
        end
    end

    % plotting the result
    plot(xData, yData, pen_color, LineWidth = 2);
end
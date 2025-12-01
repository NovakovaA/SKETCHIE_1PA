function [x_move, y_move] = steps_data2move_data(xSteps, ySteps)
    x_move = [];
    y_move = [];
    start = [0, 0]; % where the pen is located at the start in steps

    % encoder
    for i = 1:length(xSteps)
        if i == 1 % moving from start to first position
            x_difference = xSteps(i) - start(1);
            x_move = [x_move, x_difference];
            y_difference = ySteps(i) - start(2);
            y_move = [y_move, y_difference];
        else
            x_difference = xSteps(i) - xSteps(i-1);
            x_move = [x_move, x_difference];
            y_difference = ySteps(i) - ySteps(i-1);
            y_move = [y_move, y_difference];
        end
    end
end
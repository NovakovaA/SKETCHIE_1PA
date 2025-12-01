function [starts_with_increment, increments] = xy_steps2line_increments(x_move, y_move, longer_distance)
    %{
    The fist part of this function takes the number of steps in x and y axis and makes a line
    equation from them in the form of y = kx. The y values are stored in a list.
    
    visualisation of what the first part of the function does:
             ...
          ...   
       ...      
    ...            => [0,0,0,1,1,1,2,2,2,3,3,3]
    %}
    
    % need only positive values
    x_move = abs(x_move);
    y_move = abs(y_move);

    values = [];

    %defining k of the line equation kx+q
    if x_move == longer_distance
        k = y_move/x_move;
    else
        k = x_move/y_move;
    end

    % finding the value of the line at every step of the bigger value
    for x = 1:longer_distance
        values = [values, round(k*x)];
    end

    
    %{
    The second part of this function takes the list and makes a binary list
    that shows when the value changed. It also checks if it starts with 1.

    visualisation of what the second part of the function does:
    [0,0,0,1,1,1,2,2,2,3,3,3] => [0,0,0,1,0,0,1,0,0,1,0,0]
    %}
    
    binary_values = [values(1)];
    for i = 2:length(values)
        binary_values = [binary_values, values(i) - values(i-1)];
    end
    
    starts_with_increment = false;
    if binary_values(1) == 1
        starts_with_increment = true;
    end


    % The third part of this function groups up the binary values:
    % [0,0,0,1,0,0,1,0,0,1,0,0] => [3,1,2,1,2,1,2]

    increments = [1];
    for i = 2:length(binary_values)
        if binary_values(i) == binary_values(i-1)
            increments(end) = increments(end) + 1;
        else
            increments = [increments, 1];
        end
    end
end
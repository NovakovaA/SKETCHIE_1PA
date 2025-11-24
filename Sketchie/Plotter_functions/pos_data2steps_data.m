function [x_steps, y_steps] = pos_data2steps_data(xData, yData, k)
    % 2048 steps in one rotation
    step = k/2048;
    
    x_steps = round(xData./step);
    y_steps = round(yData./step);
end
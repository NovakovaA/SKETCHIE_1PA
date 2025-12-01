clc, clear, close all;


% initializing mechduino
Arduino = Mechduino('COM3');


% initializing steppers
stepper_x = Arduino.get_Stepper(2, 4, 6, 8);
stepper_x.set_speed(255); % max speed but still slow
% 1 rotation takes approximately 6,38 s (~3 ms for 1 step)

stepper_y = Arduino.get_Stepper(3, 5, 7, 9);
stepper_y.set_speed(255);



line_values = readlines("shark_hammerhead.gcode");

pen_color = 'k';
[xData, yData] = gcode2pos_data(line_values, pen_color);

% k is koeficient which defines length of move in one rotation
k = 36.8; % mm (~18 μm for 1 step)
% defines absolute position in number of steps
[xSteps, ySteps] = pos_data2steps_data(xData, yData, k);

% defines relative move in number of steps
[xMove, yMove] = steps_data2move_data(xSteps, ySteps);

% moves between points in straight line
move_steppers_xy(xMove, yMove, stepper_x, stepper_y);

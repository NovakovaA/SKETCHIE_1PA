clc, clear, close all;

% adding the path to access functions and Gcodes
addpath('Plotter_functions');
addpath('Gcodes');

% initializing mechduino
Arduino = Mechduino('COM4');


% initializing steppers
stepper_x = Arduino.get_Stepper(2, 4, 6, 8);
stepper_x.set_speed(255); % max speed but still slow
% rotation takes approximately 6,38 s

stepper_y = Arduino.get_Stepper(3, 5, 7, 9);
stepper_y.set_speed(255);



line_values = readlines("shark_hammerhead.gcode");

pen_color = 'k';
[xData, yData] = gcode2pos_data(line_values, pen_color);

% k is koeficient which defines length of move in one rotation
k = 36.8; % mm
% defines absolute position in number of steps
[xSteps, ySteps] = pos_data2steps_data(xData, yData, k);

% defines relative move in number of steps
[xMove, yMove] = steps_data2move_data(xSteps, ySteps);


% moving the steppers
%{
for i = 1:length(xMove)
    % checking which way to move
    if xMove(i) > 0
        stepper_x.step(abs(xMove(i)));
    elseif xMove(i) < 0
        stepper_x.step(abs(xMove(i)), 'Direction', 'Backward');
    end

    if yMove(i) > 0
        stepper_y.step(abs(yMove(i)));
    elseif xMove(i) < 0
        stepper_y.step(abs(yMove(i)), 'Direction', 'Backward');
    end
end
%}

stepper_x.step(2048, 'Direction', 'Backward');
%stepper_y.step(512, 'Direction', 'Forward');
% waiting for it to finish
while stepper_x.is_moving()
end
Arduino.pause(1000);
%stepper_x.step(2048, 'Direction', 'Forward');
%stepper_y.step(512, 'Direction', 'Backward');

%this is the best program for our ultimate plotting machine Sketchie
clc, clear, close all

%port for mechduino
COM  = '/dev/cu.usbserial-110';

% New Arduino controller
Sketchie = Mechduino(COM);

% Steppers configuration
stepper_x = Sketchie.get_Stepper(2,4,6,8); % axis x
stepper_y = Sketchie.get_Stepper(3,5,7,9); % sxis y 

%Servos configuration
servo_z = Sketchie.get_Servo(10);% axis z 
servo_g = Sketchie.get_Servo(13);% grabber for fix

%Constants
mm_to_steps = 69; %to transform mm to steps      #TODO


%Functions
function MoveX(mm,direction)
    stepper_x.step(mm*mm_to_steps)
end

%function to move Y axis 
%Params
% - mm - desired distance in mm, must be positive
% - direction - direction to where motor should go two values 'Forward' or 'Backward'
function MoveY(mm,direction)   %#TODO
stepper_y.step(mm*mm_to_steps,'Direction',direction)
end




%main code

stepper_x.step(500)


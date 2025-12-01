function move_steppers_diagonal(major_move, minor_move, major_stepper, minor_stepper, i, swi, increments)
    % time in ms for 1 step
    TIME_CONSTANT = (6.38/2048)*1000;

    % checking which way to move the longer axis
    if major_move(i) > 0
        major_stepper.step(abs(major_move(i)), 'Direction', 'Forward');
    elseif major_move(i) < 0
        major_stepper.step(abs(major_move(i)), 'Direction', 'Backward');
    end

    % moving the shorter axis by switching it on and off
    for j = 1:length(increments)
        if swi
            if minor_move(i) > 0
                minor_stepper.step(increments(j), 'Direction', 'Forward');
            else
                minor_stepper.step(increments(j), 'Direction', 'Backward')
            end
            swi = false;
        else
            % waiting for the length of x steps
            tic;
            while toc < TIME_CONSTANT*increments(j)
            end
            swi = true;
        end
                    
        % waiting for the minor_stepper to stop moving
        while minor_stepper.is_moving()
        end
    end
end
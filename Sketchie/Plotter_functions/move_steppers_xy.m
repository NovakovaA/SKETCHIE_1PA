function move_steppers_xy(x_move, y_move, x_stepper, y_stepper)
    % moving the steppers
    for i = 1:length(x_move)

        % checking if it should move
        if x_move(i) == 0 && y_move(i) == 0
            continue

        % when moving in both directions
        elseif x_move(i) ~= 0 && y_move(i) ~= 0
            longer_distance = max(x_move(i), y_move(i));
    
            [swi, increments] = xy_steps2line_increments(x_move(i), y_move(i), longer_distance);
            
            % checking which direction is bigger
            if longer_distance == x_move(i)
                move_steppers_diagonal(x_move, y_move, x_stepper, y_stepper, i, swi, increments);
            else
                move_steppers_diagonal(y_move, x_move, y_stepper, x_stepper, i, swi, increments)
            end
        
        % moving only in one direction
        else
            if x == 0
                if y_move(i) > 0
                    y_stepper.step(abs(y_move(i)), 'Direction', 'Forward');
                elseif y_move(i) < 0
                    y_stepper.step(abs(y_move(i)), 'Direction', 'Backward');
                end
            else
                if x_move(i) > 0
                    x_stepper.step(abs(x_move(i)), 'Direction', 'Forward');
                elseif x_move(i) < 0
                    x_stepper.step(abs(x_move(i)), 'Direction', 'Backward');
                end
            end
        end

        % waiting for the moves to finish
        while x_stepper.is_moving() || y_stepper.is_moving()
        end
    end
end
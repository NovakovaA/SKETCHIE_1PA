function move_steppers_diagonal(major_move, minor_move, major_stepper, minor_stepper, i, swi, increments)
    % round in ms, then convert to s
    TIME_CONSTANT = round((6.38/2048)*1000);
    TIME_CONSTANT = TIME_CONSTANT/1000;

    % checking which way to move the longer axis
    if major_move(i) > 0
        major_stepper.step(abs(major_move(i)), 'Direction', 'Forward');
    elseif major_move(i) < 0
        major_stepper.step(abs(major_move(i)), 'Direction', 'Backward');
    end

    % moving the shorter axis by switching it on and off
    tic; % using timer to align movement with estimated time
    moves_passed = 0; % how many moves already passed stepwise
    moves_skipped = 0; % how many moves have been skipped by joining
    is_slow = false; % if the code should join together moves
    
    for j = 1:length(increments)
        running = true;
        % until the stepper starts moving because of the timer
        while running
            % dont do anything if it skipped moves
            if moves_skipped > 0
                moves_skipped = moves_skipped - 1;
                continue;
            end
            
            if swi && toc >= moves_passed*TIME_CONSTANT
                if length(increments) >= j+2
                    next_moves_passed = moves_passed + increments(j) + increments(j+1);
                    is_slow = true;
                else
                    is_slow = false;
                end

                % checking if there are any increments left and if its too
                % slow
                if is_slow && toc >= next_moves_passed*TIME_CONSTANT
                    steps = increments(j) + increments(j+2);

                    if minor_move(i) > 0
                        minor_stepper.step(steps, 'Direction', 'Forward');
                    else
                        minor_stepper.step(steps, 'Direction', 'Backward')
                    end
                    moves_passed = moves_passed + increments(j) + increments(j+1) + increments(j+2);
                    moves_skipped = 2;
                else
                    if minor_move(i) > 0
                        minor_stepper.step(increments(j), 'Direction', 'Forward');
                    else
                        minor_stepper.step(increments(j), 'Direction', 'Backward')
                    end
                    moves_passed = moves_passed + increments(j);
                end
                swi = false;
                running = false;
            elseif ~swi
                % adding moves that are supposed to be skipped
                moves_passed = moves_passed + increments(j);
                swi = true;
                running = false;
            end
        end

        % waiting for the minor_stepper to stop moving
        while minor_stepper.is_moving()
        end
    end
end
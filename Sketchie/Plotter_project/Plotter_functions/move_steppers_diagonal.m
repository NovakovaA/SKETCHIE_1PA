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
    last_move = false; % allowing the last move and then breaking cycle
    
    j = 0;
    while j <= length(increments)
        % excluding the last step
        if j < length(increments)
            j = j + 1;
        elseif last_move
            break;
        else
            last_move = true;
        end

        % dont do anything if it skipped moves
        if moves_skipped > 0
            % the continue skips one move as well
            j = j + moves_skipped - 1;
            moves_skipped = 0;
            continue;
        end
        
        running = true;
        % until the stepper starts moving because of the timer
        while running  
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
                    time_passed = toc;
                    [moves_skipped, moves_passed, steps] = join_moves(increments, j, moves_passed, TIME_CONSTANT, time_passed);

                    if minor_move(i) > 0
                        minor_stepper.step(steps, 'Direction', 'Forward');
                    else
                        minor_stepper.step(steps, 'Direction', 'Backward');
                    end
                else
                    if minor_move(i) > 0
                        minor_stepper.step(increments(j), 'Direction', 'Forward');
                    else
                        minor_stepper.step(increments(j), 'Direction', 'Backward');
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
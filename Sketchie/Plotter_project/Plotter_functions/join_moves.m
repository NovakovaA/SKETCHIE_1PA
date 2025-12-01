function [moves_skipped, moves_passed, steps] = join_moves(increments, j, moves_passed, TIME_CONSTANT, time_passed)
    i = 1;
    moves_skipped = 0;
    steps = increments(j);
    moves_passed = moves_passed + increments(j);

    while time_passed >= moves_passed*TIME_CONSTANT
        if length(increments) >= j+(2*i)
            moves_passed = moves_passed + sum(increments(j+(2*i-1):j+(2*i)));
            moves_skipped = moves_skipped + 2;
            steps = steps + increments(j+(2*i));
        else
            break;
        end

        i = i+1;
    end
end
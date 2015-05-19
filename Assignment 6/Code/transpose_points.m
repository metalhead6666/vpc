function Po = transpose_points(Pi, T)
    Po(4,:) = 1;
    Pi(4,:) = 1;

    Po = T * Pi;

    Po=Po(1:3,:);
end
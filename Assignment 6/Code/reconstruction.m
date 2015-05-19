function reconstruction()
    P = [0 0 0
         0 1 0
         0 1 1
         0 0 1
         1 0 0
         1 1 0
         1 1 1
         1 0 1]';

    R = euler_rotation(degtorad(20), degtorad(15), degtorad(10));
    T = [R [0 0 0]'; 0 0 0 1];
    P2 = transpose_points(P, T);
    P3 = transpose_points(P2, T);


    S = [P P2 P3];
    R = [0 0 0; 0 0 0; [R(1, 1:3); R(2, 1:3)]; [R(1, 1:3); R(2, 1:3)]];

    W = R * S;

    figure
    plot3(P(1, :), P(2, :), P(3, :), 'r*')
    axis square
    pause;
    plot3(P2(1, :), P2(2, :), P2(3, :), 'r*')
    pause;
    plot3(P3(1, :), P3(2, :), P3(3, :), 'r*')
    
    close all;
end
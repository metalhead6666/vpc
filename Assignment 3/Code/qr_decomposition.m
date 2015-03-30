function qr_decomposition(M)
    [R, K] = qr(inv(M(1:3, 1:3)));
    
    if K(1, 1) < 0
        S = [-1 0 0; 0 1 0; 0 0 1];
        R = R * S;
        K = S * K;
    end

    if K(2, 2) < 0
        S = [1 0 0; 0 -1 0; 0 0 1];
        R = R * S;
        K = S * K;
    end

    if K(3, 3) < 0
        S = [1 0 0; 0 1 0; 0 0 -1];
        R = R * S;
        K = S * K;
    end
    
    % Translation Vector
    t = K * M(1:3, 4);

    % if R is a rotation matrix, then det(R) = 1.
    if det(R) < 0 
        t = -t;
        R = -R;
    end

    % Rotation Matrix
    R = inv(R);

    % Intrinsic Matrix
    K = inv(K);
    K = K / K(3, 3);
end
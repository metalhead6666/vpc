function R = euler_rotation(alfa, beta, gama)
    Rx = [1 0 0; 0 cos(gama) -sin(gama); 0 sin(gama) cos(gama)];
    Ry = [cos(beta) 0 sin(beta); 0 1 0; -sin(beta) 0 cos(beta)];
    Rz = [cos(alfa) -sin(alfa) 0; sin(alfa) cos(alfa) 0; 0 0 1];

    R = Rz * Ry * Rx;
end
function qr_decomposition(M)
    [Q, R] = qr(flipud(M)');
    
    R = rot90(R', 2);
    Q = flipud(Q');
end
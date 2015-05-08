function E = essential_matrix(F)
%% part two
% parametros intrisecos das cameras
    Kesq = [1317.24980 0 512.23259; 0 1316.83041 413.07903; 0 0 1];
    Kdir = [1312.94890 0 533.80481; 0 1313.02652 397.59032; 0 0 1];
    
%% exercise 5
% determinação da matriz essencial
    E = Kdir' * F * Kesq
    
% rotação e translação 
    W = [0 -1 0; 1 0 0; 0 0 1];
    [U D V] = svd(E);
    R = U*W*V'

    
    
end
                    
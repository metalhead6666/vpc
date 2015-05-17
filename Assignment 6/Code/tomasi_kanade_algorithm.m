function [] = tomasi_kanade_algorithm()
clear all
clc 

    % Definition of the points in the different frames
        frame0 = [133 281; 186 81; 310 345; 325 133; 261 114];
        frame10 = [129 281; 191 86; 313 342; 338 135; 272 115];
        frame20 = [130 277; 196 89; 316 342; 352 137; 283 117];
        frame30 = [131 279; 187 84; 310 341; 364 139; 295 115];
        frame40 = [123 275; 200 91; 317 342; 372 139; 307 112];
        frame50 = [125 271; 207 91; 319 341; 385 142; 315 115];
        frame60 = [123 264; 215 92; 324 336; 388 137; 318 110];
        frame70 = [119 267; 211 97; 330 324; 391 130; 317 109];
        frame80 = [115 266; 206 101; 336 315; 392 126; 319 108];
        frame90 = [112 266; 198 103; 340 307; 392 123; 315 106];
        frame100 = [106 265; 190 111; 340 299; 390 124; 313 107];

    % Matrix W
        W = [frame0(:,1)'; frame10(:,1)'; frame20(:,1)'; frame30(:,1)'; 
             frame40(:,1)'; frame50(:,1)'; frame60(:,1)'; frame70(:,1)';
             frame80(:,1)'; frame90(:,1)'; frame100(:,1)'
             frame0(:,2)'; frame10(:,2)'; frame20(:,2)'; frame30(:,2)'; 
             frame40(:,2)'; frame50(:,2)'; frame60(:,2)'; frame70(:,2)';
             frame80(:,2)'; frame90(:,2)'; frame100(:,2)'];

    % Registered_measurement_matrix 
        registered_measurement_matrix  = zeros(22,5);
        for i=1 : 11
           average = mean(W(i,:));
           registered_measurement_matrix(i,:) = W(i,:) - average; 
        end
        
    % Decomposition of W_factorized in singular values 
        [U, S, V] = svd(registered_measurement_matrix);
        
    % S and R matrixs calculation
        R_matrix = U(:,1:3) * (sqrt(S(1:3,1:3)));
        S_matrix = (sqrt(S(1:3,1:3))) * V(:,1:3)';
        
    % Metric Transformation - matrix A
        N=11;
        A=zeros(N*3,6);
        for i=1:N
            A(i,:) = [R_matrix(i,1)^2 2*R_matrix(i,1)*R_matrix(i,2) 2*R_matrix(i,1)*R_matrix(i,3) R_matrix(i,2)^2 2*R_matrix(i,2)*R_matrix(i,3) R_matrix(i,3)^2];
            A(N+i,:) = [R_matrix(N+i,1)^2 2*R_matrix(N+i,1)*R_matrix(N+i,2) 2*R_matrix(N+i,1)*R_matrix(N+i,3) R_matrix(N+i,2)^2 2*R_matrix(N+i,2)*R_matrix(N+i,3) R_matrix(N+i,3)^2];
            A(2*N+1,:) = [R_matrix(i,1)*R_matrix(N+i,1) R_matrix(i,1)*R_matrix(N+i,2)+R_matrix(i,2)*R_matrix(N+i,1) R_matrix(i,1)*R_matrix(N+i,3)+R_matrix(i,3)*R_matrix(N+i,1) R_matrix(i,2)*R_matrix(N+i,2) R_matrix(i,2)*R_matrix(N+i,3)+R_matrix(i,3)*R_matrix(N+i,2) R_matrix(i,3)*R_matrix(N+i,3)];
        end
        
     % Metric Transformation - matrix L
        c = [ones(22,1); zeros(11,1)];
        l = pinv(A)*c;
        
        L_matrix = [l(1) l(2) l(3); l(2) l(4) l(5); l(3) l(5) l(6)];
       
     % Matrix Q
        [V D] = eig(L_matrix);
        D(1,1) = 1E-10;
        L_matrix = V*D*V';

        Q = (chol(L_matrix))';
        R_matrix=R_matrix*Q;
        S_matrix=inv(Q)*S_matrix;
end
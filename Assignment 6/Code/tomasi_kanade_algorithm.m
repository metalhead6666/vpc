function [] = tomasi_kanade_algorithm()
clear all
clc 

    % Definition of the points in the different frames
        frame0 = [133 281; 186 81; 310 345; 328 133; 351 114; 480 177];  
        frame10 = [129 281; 191 86; 313 342; 338 135; 364 118; 485 194];
        frame20 = [130 277; 196 89; 316 342; 352 137; 376 123; 490 212];
        frame30 = [131 279; 187 84; 310 341; 364 139; 388 128; 491 230];
        frame40 = [123 275; 200 91; 317 342; 372 139; 400 130; 492 247];
        frame50 = [125 271; 207 91; 319 341; 385 142; 410 137; 493 262];
        frame60 = [123 264; 215 92; 324 336; 388 137; 413 130; 487 263];
        frame70 = [119 267; 211 97; 330 324; 391 130; 413 127; 483 267];
        frame80 = [115 266; 206 101; 336 315; 392 126; 414 125; 475 273];
        frame90 = [112 266; 198 103; 340 307; 392 123; 412 123; 463 279];
        frame100 = [106 265; 190 111; 340 299; 390 124; 408 125; 457 283];

        images = {'hotel.seq0.png', 'hotel.seq10.png', 'hotel.seq20.png', 'hotel.seq30.png', 'hotel.seq40.png', 'hotel.seq50.png', 'hotel.seq60.png', 'hotel.seq70.png', 'hotel.seq80.png', 'hotel.seq90.png', 'hotel.seq100.png'};
        images2 = {'hotelseq0.png', 'hotelseq10.png', 'hotelseq20.png', 'hotelseq30.png', 'hotelseq40.png', 'hotelseq50.png', 'hotelseq60.png', 'hotelseq70.png', 'hotelseq80.png', 'hotelseq90.png', 'hotelseq100.png'};
        frames = {frame0, frame10, frame20, frame30, frame40, frame50, frame60, frame70, frame80, frame90, frame100};
        for i=1:11
            str = strcat('../hotel/', images{i});
            image = imread(str);
            imshow(image);
            hold on;
            plot(frames{i}(:,1), frames{i}(:,2), 'g*');
            str = strcat('Imagem: ', images{i});
            title(str);
            str = strcat('../Output/', images2{i});
            saveas(gcf, str);
            pause();
        end
        
        
    % Matrix W
        W = [frame0(:,1)'; frame10(:,1)'; frame20(:,1)'; frame30(:,1)'; 
             frame40(:,1)'; frame50(:,1)'; frame60(:,1)'; frame70(:,1)';
             frame80(:,1)'; frame90(:,1)'; frame100(:,1)'
             frame0(:,2)'; frame10(:,2)'; frame20(:,2)'; frame30(:,2)'; 
             frame40(:,2)'; frame50(:,2)'; frame60(:,2)'; frame70(:,2)';
             frame80(:,2)'; frame90(:,2)'; frame100(:,2)'];

    % Registered_measurement_matrix 
        registered_measurement_matrix  = zeros(22,6);
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
        
     close all;
end
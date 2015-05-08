function F = fundamental_matrix()
%% part one
% read images, save corners and show the corners position in the images
    right_image_02 = readImage('Cam_dir_02.ppm');
    right_image_05 = readImage('Cam_dir_05.ppm');
    left_image_02 = readImage('Cam_esq_02.ppm');
    left_image_05 = readImage('Cam_esq_05.ppm');

    right_image_corners_02 = [378 339; 659 413; 412 586; 642 669; 429 452; 431 477; 497 503; 518 488; 597 516; 596 541];
    right_image_corners_05 = [128 397; 564 408; 191 666; 545 696; 219 511; 222 538; 331 545; 358 518; 478 527; 478 553];
    left_image_corners_02 = [236 94; 881 106; 291 494; 805 511; 364 263; 363 305; 530 308; 573 268; 742 273; 741 314];
    left_image_corners_05 = [90 136; 778 108; 186 693; 717 541; 269 354; 271 409; 465 375; 507 321; 664 300; 664 344];
        
    warning('off', 'Images:initSize:adjustingMag');
    showImage(right_image_02, right_image_corners_02, 'RightCamera02');
    showImage(right_image_05, right_image_corners_05, 'RightCamera05');
    showImage(left_image_02, left_image_corners_02, 'LeftCamera02');
    showImage(left_image_05, left_image_corners_05, 'LeftCamera05');

    %% exercise one   
    % calculate the fundamental matrix with 8 points algorithm
    % normalization of the coordinates
    left_points = [left_image_corners_02(:, 1) left_image_corners_02(:, 2); left_image_corners_05(:, 1) left_image_corners_05(:, 2)];
    left_points = [left_points ones(20, 1)];
    right_points = [right_image_corners_02(:, 1) right_image_corners_02(:, 2); right_image_corners_05(:, 1) right_image_corners_05(:, 2)];
    right_points = [right_points ones(20, 1)];

    xe = mean(left_points(:, 1));
    ye = mean(left_points(:, 2));
    xd = mean(right_points(:, 1));
    yd = mean(right_points(:, 2));
    
    d_e = sum(sqrt((left_points(:, 1) - xe) .^ 2 + (left_points(:, 2) - ye) .^ 2)) ./ (20 * sqrt(2));
    d_d = sum(sqrt((right_points(:, 1) - xd) .^ 2 + (right_points(:, 2) - yd) .^ 2)) ./ (20 * sqrt(2));
    
    Te = [1 0 -xe; 0 1 -ye; 0 0 d_e];
    Td = [1 0 -xd; 0 1 -yd; 0 0 d_d];
    
    left_points_normalized = Te * left_points';
    left_points_normalized = (left_points_normalized / 168.9889)';
    right_points_normalized = Td * right_points';
    right_points_normalized = (right_points_normalized / 108.1601)';
    
    A = zeros(length(left_points_normalized), 9);
    
    for i = 1 : length(left_points_normalized)
        A(i, :) = [right_points_normalized(i, 1)*left_points_normalized(i, 1) right_points_normalized(i, 1)*left_points_normalized(i, 2) right_points_normalized(i, 1) ...
                   right_points_normalized(i, 2)*left_points_normalized(i, 1) right_points_normalized(i, 2)*right_points_normalized(i, 2) right_points_normalized(i, 2) ...
                   left_points_normalized(i, 1) left_points_normalized(i, 2) 1];
    end
    
    [~, D, V] = svd(A);
    
    [~, index] = min(sum(D));
    F_normalized = reshape(V(:, index), 3, 3);
    
    [U, D, V] = svd(F_normalized);
    
    [~, index] = min(sum(D));
    D(:, index) = 0;
    
    F_normalized = U * D * V';
    
    F = Td' * F_normalized * Te
end

function image = readImage(str)
    str = strcat('../Input/', str);
    image = imread(str);
    image = rgb2gray(image);
end

function showImage(image, corners, str)
    figure;
    imshow(image);
    hold on;
    plot(corners(:, 1), corners(:, 2), 'r+');
    title(str);
    str = strcat('../Output/', str);
    saveas(gcf, str, 'jpg');
    close all;
end
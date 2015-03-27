function [B, M, Xw, Yw, Zw, xf, yf] = calculate_matrix_M(A, b, values_array)
    % exercise 3
    % save the values of the matrix A obtained in the 4 images to create the
    % pseudo inverse
    A = [A{1}; A{2}; A{3}; A{4}];
    b = [b{1}; b{2}; b{3}; b{4}];

    % save the matrix unaltered to be used later
    B = A;

    % eliminate the 12th value
    A = A(:, 1 : 11);

    % pseudo inverse of A
    pInverse = pinv(A);
    
    % exercise 4
    % matrix M
    M = pInverse * b;
    
    % insert the 12th value, M_12 = 1
    M = [M; 1];

    % transform the matrix M to a 3x4 matrix
    M = [M(1) M(2) M(3) M(4); M(5) M(6) M(7) M(8); M(9) M(10) M(11) M(12)];
    
    % save the elements obtained in the file for facility of use
    v1 = values_array{1};
    v2 = values_array{2};
    v3 = values_array{3};
    v4 = values_array{4};
    
    Xw = [v1(:, 3); v2(:, 3); v3(:, 3); v4(:, 3)];
    Yw = [v1(:, 4); v2(:, 4); v3(:, 4); v4(:, 4)];
    Zw = [v1(:, 5); v2(:, 5); v3(:, 5); v4(:, 5)];
    xf = [v1(:, 2); v2(:, 2); v3(:, 2); v4(:, 2)];
    yf = [v1(:, 1); v2(:, 1); v3(:, 1); v4(:, 1)];

    % exercise 5
    % projection of the 3D point of the calibration in the image
    Pw = [Xw'; Yw'; Zw'; ones(1, numel(Xw))];
    P = M * Pw;
    
    x = P(1, :) ./ P(3, :);
    y = P(2, :) ./ P(3, :);
    
    % disparity calculus
    disparity = sqrt((xf - x') .^ 2 + (yf - y') .^ 2);
    
    % exercise 6
    maximum = max(disparity);
    minimum = min(disparity);
    mean_d = mean(disparity);
    median_d = median(disparity);
    deviation = sqrt(var(disparity));
        
    file = fopen('../Output/results.txt', 'w');
    fprintf(file, 'Part One, exercise 6:\nMax: %f\nMin: %f\nMean: %f\nMedian: %f\nDeviation: %f\n\n', maximum, minimum, mean_d, median_d, deviation);    
    fclose(file);
    
    % exercise 7
    hist(disparity);
    title('Histogram of the values of the disparity');
    saveas(gcf, '../Output/histogram_disparity', 'jpg');
    close all;
end

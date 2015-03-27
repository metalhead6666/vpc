function second_part(M, Xw, Yw, Zw, xf, yf)
	% exercise 1
    % decomposition in singular values of the previously 
    % saved matrix without M_12 = 1
    [U, S, V] = svd(M);

    % exercise 2
    % calculate the parameters
    [~, indexes] = min([S(1, 1), S(2, 2), S(3, 3), S(4, 4), S(5, 5), S(6, 6), S(7, 7), S(8, 8), S(9, 9), S(10, 10), S(11, 11), S(12, 12)]);

    m = V(:, indexes);
    q = zeros(3, 3);
    it = 1;
    
    for iterator = 1 : 4 : 11
        q(it, :) = m(iterator : iterator + 2);
        it = it + 1;
    end
    
    m = [m(1) m(2) m(3) m(4); m(5) m(6) m(7) m(8); m(9) m(10) m(11) m(12)];

    % intrinsic parameters
    Cx = q(1, :)' * q(3, :);
    Cy = q(2, :)' * q(3, :);
    fx = sqrt(q(1, :)' * q(1, :) - Cx^2);
    fy = sqrt(q(2, :)' * q(2, :) - Cy^2);
    
    % extrinsic parameters    
    r1 = zeros(9, 3);
    r2 = zeros(9, 3);
    r3 = zeros(3);
    it = 1;

    for iterator = 1 : 3 : 9        
    	r3(it) = q(3, it);        
        r1(iterator : iterator + 2, :) = (m(1, it) - Cx * r3(it)) ./ fx;
        r2(iterator : iterator + 2, :) = (m(2, it) - Cy * r3(it)) ./ fy;
        
        it = it + 1;
    end
        
    Tz = m(3, 4);
    Tx = (m(1, 4) - Cx * Tz) ./ fx;
    Ty = (m(2, 4) - Cy * Tz) ./ fy;    
    
    % exercise 3
    % calculate the disparity like in part 1
    Pw = [Xw'; Yw'; Zw'; ones(1, numel(Xw))];
    P = m * Pw;
    
    x = P(1, :) ./ P(3, :);
    y = P(2, :) ./ P(3, :);
    
    disparity = sqrt((xf - x') .^ 2 + (yf - y') .^ 2);
    
    maximum = max(disparity);
    minimum = min(disparity);
    mean_d = mean(disparity);
    median_d = median(disparity);
    deviation = sqrt(var(disparity));
    
    file = fopen('../Output/results.txt', 'a');
    fprintf(file, 'Part Two, exercise 3:\nMax: %f\nMin: %f\nMean: %f\nMedian: %f\nDeviation: %f\n', maximum, minimum, mean_d, median_d, deviation);
    fclose(file);
    
    % exercise 4
    hist(disparity);
    title('Histogram of the values of the disparity');
    saveas(gcf, '../Output/histogram_disparity_part2', 'jpg');
    close all;
end

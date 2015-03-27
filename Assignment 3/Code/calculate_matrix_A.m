function [A, b, values_array] = calculate_matrix_A(image, file, name)
    % exercise 1
    image = imread(image);    
    
    file = fopen(file);
    numbers = fscanf(file, '%f');
    fclose(file);
    
    % show image
    figure;
    imshow(image);
    hold on;
    
    % delete first line of the matrix
    elements = numbers(1);
    numbers(1) = [];
    numbers = round(numbers);
    
    % save yf, xf, Xw, Yw and Zw in an array
    values_array = zeros(elements, 5);
    
    for iterator = 1 : 5
        values_array(:, iterator) = numbers(iterator + 1 : 6 : numel(numbers));
    end
    
    % plot of the center points in the original image
    for iterator = 2 : 6 : numel(numbers)
        plot(numbers(iterator + 1), numbers(iterator), 'r*');
    end
        
    title('Image with center points');
    str = strcat(name, 'centerpoints');
    saveas(gcf, str, 'jpg');
    close all;
    
    % exercise 2
    % fill the matrix A with the values previously obtained in the file
    A = zeros(2 * elements, 12);
    b = zeros(2 * elements, 1);
    
    for iterator = 1 : elements
        yf = values_array(iterator, 1);
        xf = values_array(iterator, 2);
        Xw = values_array(iterator, 3);
        Yw = values_array(iterator, 4);
        Zw = values_array(iterator, 5);
        xfXW = -xf * Xw;
        xfYW = -xf * Yw;
        xfZW = -xf * Zw;
        yfXW = -yf * Xw;
        yfYW = -yf * Yw;
        yfZW = -yf * Zw;
        
        A(2*iterator - 1 : 2*iterator, :) = [Xw Yw Zw 1 0 0 0 0 xfXW xfYW xfZW -xf;
                                             0 0 0 0 Xw Yw Zw 1 yfXW yfYW yfZW -yf];
               
        b(2*iterator - 1 : 2*iterator, :) = [xf; yf];
    end
end

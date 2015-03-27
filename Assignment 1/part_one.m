function [] = part_one()
    clear all
    clc
    
    %exercise 1    
    [image, map] = imread('peppers.png');
    %transform image into gray color
    image_gray = rgb2gray(image);
    [x, y] = size(image_gray);
    
    imshow(image_gray, map);
    %maximize show window
    set(gcf, 'units', 'normalized', 'outerposition', [0 0 1 1]);
    title('Peppers.png');
    saveas(gcf, 'peppers_gray', 'jpg');
    disp('Exercise 1 saved correctly');
    close all;
    
    %exercise 2
    mean = 0;
    variance = 0.01;
    density = 0.05;
    variance_speckle = 0.04;
    
    image_gaussian_array = zeros(x, y, 5);
    image_salt_pepper_array = zeros(x, y, 5);
    image_speckle_array = zeros(x, y, 5);
    
    for i = 1 : 5
        %save all images in the 3D array to apply filters later
        image_gaussian_array(:,:,i) = imnoise(image_gray, 'gaussian', mean, variance);
        image_salt_pepper_array(:,:,i) = imnoise(image_gray, 'salt & pepper', density);
        image_speckle_array(:,:,i) = imnoise(image_gray, 'speckle', variance_speckle);       
        
        show_gaussian_image(i, mean, variance, image_gray, image_gaussian_array(:,:,i), map);
        show_salt_pepper_image(i, density, image_gray, image_salt_pepper_array(:,:,i), map);
        show_speckle_image(i, variance_speckle, image_gray, image_speckle_array(:,:,i), map);
        
        mean = mean + 0.01;
        variance = variance + 0.02;
        density = density + 0.1;
        variance_speckle = variance_speckle + 0.15;
    end
    disp('Exercise 2 saved correctly');
    close all;
    
    %exercise 3
    Hsize = [3 3];
    Sigma = 0.5;
    N_temp = 1:x;
    M = repmat([1,x], 1, x/2);
    
    improfile(image_gaussian_array(:,:,2), N_temp, M);
    title('Gaussian with noise');
    saveas(gcf, 'gaussian_noise_improfile', 'jpg');
    
    improfile(image_salt_pepper_array(:,:,2), N_temp, M);
    title('Salt & pepper with noise');
    saveas(gcf, 'salt_pepper_noise_improfile', 'jpg');
    
    improfile(image_speckle_array(:,:,2), N_temp, M);
    title('Speckle with noise');
    saveas(gcf, 'speckle_noise_improfile', 'jpg');
    
    image_medfilt2_gaussian = medfilt2(image_gaussian_array(:,:,2));
    image_medfilt2_salt_pepper = medfilt2(image_salt_pepper_array(:,:,2));
    image_medfilt2_speckle = medfilt2(image_speckle_array(:,:,2));
    
    mask = {fspecial('average', Hsize) fspecial('gaussian', Hsize, Sigma)};
    
    image_imfilter_gaussian_array = zeros(x, y, 2);
    image_imfilter_salt_pepper_array = zeros(x, y, 2);
    image_imfilter_speckle_array = zeros(x, y, 2);
    
    for i = 1 : 2
        image_imfilter_gaussian_array(:,:,i) = imfilter(image_gaussian_array(:,:,2), mask{i});
        image_imfilter_salt_pepper_array(:,:,i) = imfilter(image_salt_pepper_array(:,:,2), mask{i});
        image_imfilter_speckle_array(:,:,i) = imfilter(image_speckle_array(:,:,2), mask{i});
    end
              
    improfile(image_imfilter_gaussian_array(:,:,1), N_temp, M);
    title('Gaussian filtered with Average');
    saveas(gcf, 'gaussian_filtered_average', 'jpg');

    improfile(image_imfilter_salt_pepper_array(:,:,1), N_temp, M);
    title('Salt & pepper filtered with Average');
    saveas(gcf, 'salt_pepper_filtered_average', 'jpg');

    improfile(image_imfilter_speckle_array(:,:,1), N_temp, M);
    title('Speckle filtered with Average');
    saveas(gcf, 'speckle_filtered_average', 'jpg');
    
    %
    
    improfile(image_imfilter_gaussian_array(:,:,2), N_temp, M);
    title('Gaussian filtered with Gaussian');
    saveas(gcf, 'gaussian_filtered_gaussian', 'jpg');

    improfile(image_imfilter_salt_pepper_array(:,:,2), N_temp, M);
    title('Salt & pepper filtered with Gaussian');
    saveas(gcf, 'salt_pepper_filtered_gaussian', 'jpg');

    improfile(image_imfilter_speckle_array(:,:,2), N_temp, M);
    title('Speckle filtered with Gaussian');
    saveas(gcf, 'speckle_filtered_gaussian', 'jpg');
    
    %
    
    improfile(image_medfilt2_gaussian, N_temp, M);
    title('Gaussian filtered with medfilt2');
    saveas(gcf, 'gaussian_filtered_medfilt2', 'jpg');

    improfile(image_medfilt2_salt_pepper, N_temp, M);
    title('Salt & pepper filtered with medfilt2');
    saveas(gcf, 'salt_pepper_filtered_medfilt2', 'jpg');

    improfile(image_medfilt2_speckle, N_temp, M);
    title('Speckle filtered with medfilt2');
    saveas(gcf, 'speckle_filtered_medfilt2', 'jpg');

    disp('Exercise 3 saved correctly');
    close all;
    
    %exercise 3b
    j = 1;
    
    for i = 0.01 : 0.1 : 1
        image_test_gaussian = imfilter(image_gray, fspecial('gaussian', Hsize, i));
        imshow(image_test_gaussian);
        str = sprintf('image_test_gaussian_%d', j);
        saveas(gcf, str, 'jpg');
        j = j + 1;
    end
    
    %exercise 4
    image_filtered = med_filter(image_gaussian_array(:,:,2), 3);
    subplot(1, 2, 1), imshow(image_medfilt2_gaussian, map);
    title('Gaussian filtered with medfilt2');
    subplot(1, 2, 2), imshow(image_filtered, map);
    title('Median algorithm gaussian n=3');
    set(gcf, 'units', 'normalized', 'outerposition', [0 0 1 1]);
    saveas(gcf, 'median_gaussian_medfilt2', 'jpg');
    
    %
   
    subplot(1, 2, 1), imshow(image_imfilter_gaussian_array(:,:,1), map);
    title('Gaussian filtered with Average');
    subplot(1, 2, 2), imshow(image_filtered, map);
    title('Median algorithm gaussian n=3');
    set(gcf, 'units', 'normalized', 'outerposition', [0 0 1 1]);
    saveas(gcf, 'median_gaussian_average', 'jpg');
    
    %
    
    subplot(1, 2, 1), imshow(image_imfilter_gaussian_array(:,:,2), map);
    title('Gaussian filtered with Gaussian');
    subplot(1, 2, 2), imshow(image_filtered, map);
    title('Median algorithm gaussian n=3');
    set(gcf, 'units', 'normalized', 'outerposition', [0 0 1 1]);
    saveas(gcf, 'median_gaussian_gaussian', 'jpg');
    
    %
    
    image_filtered = med_filter(image_salt_pepper_array(:,:,2), 3);
    subplot(1, 2, 1), imshow(image_medfilt2_salt_pepper, map);
    title('Salt & pepper filtered with medfilt2');
    subplot(1, 2, 2), imshow(image_filtered, map);
    title('Median algorithm salt & pepper n=3');
    set(gcf, 'units', 'normalized', 'outerposition', [0 0 1 1]);
    saveas(gcf, 'median_salt_pepper_medfilt2', 'jpg');
    
    %
    
    subplot(1, 2, 1), imshow(image_imfilter_salt_pepper_array(:,:,1), map);
    title('Salt & pepper filtered with Average');
    subplot(1, 2, 2), imshow(image_filtered, map);
    title('Median algorithm salt & pepper n=3');
    set(gcf, 'units', 'normalized', 'outerposition', [0 0 1 1]);
    saveas(gcf, 'median_salt_pepper_average', 'jpg');
    
    %
    
    subplot(1, 2, 1), imshow(image_imfilter_salt_pepper_array(:,:,2), map);
    title('Salt & pepper filtered with Gaussian');
    subplot(1, 2, 2), imshow(image_filtered, map);
    title('Median algorithm salt & pepper n=3');
    set(gcf, 'units', 'normalized', 'outerposition', [0 0 1 1]);
    saveas(gcf, 'median_salt_pepper_gaussian', 'jpg');
    
    %
    
    image_filtered = med_filter(image_speckle_array(:,:,2), 3);
    subplot(1, 2, 1), imshow(image_medfilt2_speckle, map);
    title('Speckle filtered with medfilt2');
    subplot(1, 2, 2), imshow(image_filtered, map);
    title('Median algorithm speckle n=3');
    set(gcf, 'units', 'normalized', 'outerposition', [0 0 1 1]);
    saveas(gcf, 'median_speckle_medfilt2', 'jpg');
    
    %
    
    subplot(1, 2, 1), imshow(image_imfilter_speckle_array(:,:,1), map);
    title('Speckle filtered with Average');
    subplot(1, 2, 2), imshow(image_filtered, map);
    title('Median algorithm speckle n=3');
    set(gcf, 'units', 'normalized', 'outerposition', [0 0 1 1]);
    saveas(gcf, 'median_speckle_average', 'jpg');
    
    %
    
    subplot(1, 2, 1), imshow(image_imfilter_speckle_array(:,:,2), map);
    title('Speckle filtered with Gaussian');
    subplot(1, 2, 2), imshow(image_filtered, map);
    title('Median algorithm speckle n=3');
    set(gcf, 'units', 'normalized', 'outerposition', [0 0 1 1]);
    saveas(gcf, 'median_speckle_gaussian', 'jpg');
    
    disp('Exercise 4 saved correctly');
    close all;
end

function [] = show_gaussian_image(i, mean, variance, image_gray, image_gaussian, map)
    subplot(1, 2, 1), imshow(image_gray, map);
    title('Peppers.png');
    subplot(1, 2, 2), imshow(image_gaussian, map);
    %maximize show window
    set(gcf, 'units', 'normalized', 'outerposition', [0 0 1 1]);
    str_gaussian = sprintf('Peppers.png with gaussian noise\n mean = %.2f, variance = %.2f', mean, variance);
    title(str_gaussian);

    save_image_gaussian = sprintf('gaussian_noise_%d', i);
    saveas(gcf, save_image_gaussian, 'jpg');
end

function [] = show_salt_pepper_image(i, density, image_gray, image_salt_pepper, map)
    subplot(1, 2, 1), imshow(image_gray, map);
    title('Peppers.png');
    subplot(1, 2, 2), imshow(image_salt_pepper, map);
    str_salt_pepper = sprintf('Peppers.png with salt & pepper noise\n density = %.2f', density);
    title(str_salt_pepper);

    save_image_salt_pepper = sprintf('salt_pepper_noise_%d', i);
    saveas(gcf, save_image_salt_pepper, 'jpg');
end

function [] = show_speckle_image(i, variance_speckle, image_gray, image_speckle, map)
    subplot(1, 2, 1), imshow(image_gray, map);
    title('Peppers.png');
    subplot(1, 2, 2), imshow(image_speckle, map);
    str_speckle = sprintf('Peppers.png with speckle noise\n variance = %.2f', variance_speckle);
    title(str_speckle);

    save_image_speckle = sprintf('speckle_noise_%d', i);
    saveas(gcf, save_image_speckle, 'jpg');
end
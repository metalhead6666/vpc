%exercise 4
function [final_image] = med_filter(image, n)
    [x, y] = size(image);
    final_image_double = zeros(x, y);
    half = floor(n / 2);
    
    for i = 1 + half : x - half
        for j = 1 + half : y - half
            temp_vect = image(i - half : i + half, j - half : j + half);
            final_image_double(i - half, j - half) = median(median(temp_vect)); 
        end
    end

    final_image = uint8(final_image_double);
end
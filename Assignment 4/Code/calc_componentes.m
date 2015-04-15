function[] = calc_componentes()
    clear all
    clc
    
    %exercise 1    
    [image, map] = imread('peppers.png');
    imshow(image);
    title('Imagem peppers.png original');
    pause();
    
    %exercise 2
    h_shift_image = circshift(image,[0 2]);
    imshow(h_shift_image);
    pause();
    
    
    close all
end
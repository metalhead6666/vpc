function[] = calc_componentes()
    clear all
    clc
    
    %exercise 1    
        [image, map] = imread('peppers.png');
        image = rgb2gray(image);
        imshow(image);
        title('Imagem peppers.png original');
        saveas(gcf, '../Output/original_image', 'jpg');
    
    %exercise 2
        %shift de 2 pixels na horizontal
        h_shift_image = circshift(image,[0 2]);
        imshow(h_shift_image);
        title('Imagem peppers.png com shift horizontal');
        saveas(gcf, '../Output/h_shift_image', 'jpg');

        %shift de 2 pixels na vertical
        v_shift_image = circshift(image,[2 0]);
        imshow(v_shift_image);
        title('Imagem peppers.png com shift vertical');
        saveas(gcf, '../Output/v_shift_image', 'jpg');
                
        %shift de 2 pixels na diagonal
        d_shift_image = circshift(image,[2 2]);
        imshow(d_shift_image);
        title('Imagem peppers.png com shift diagonal');
        saveas(gcf, '../Output/d_shift_image', 'jpg');
        
    %exercise 3, 4, 5 e 6
        calc_fluxo(image, h_shift_image, 'shift horizontal');
        calc_fluxo(image, v_shift_image, 'shift vertical');
        calc_fluxo(image, d_shift_image, 'shift diagonal');
        
    close all
    
end
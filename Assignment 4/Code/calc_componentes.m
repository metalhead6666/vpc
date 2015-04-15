function[] = calc_componentes()
    clear all
    clc
    
    %exercise 1    
        [image, map] = imread('peppers.png');
        imshow(image);
        title('Imagem peppers.png original');
        saveas(gcf, '../Output/original_image', 'jpg');
    
    %exercise 2
        %shift de 2 pixels na horizontal
        h_shift_image = circshift(image,[0 2]);
        title('Imagem peppers.png com shift horizontal');
        saveas(gcf, '../Output/h_shift_image', 'jpg');
        imshow(h_shift_image);

        %shift de 2 pixels na vertical
        v_shift_image = circshift(image,[2 0]);
        title('Imagem peppers.png com shift vertical');
        saveas(gcf, '../Output/v_shift_image', 'jpg');
        imshow(v_shift_image);

        %shift de 2 pixels na diagonal
        d_shift_image = circshift(image,[2 2]);
        title('Imagem peppers.png com shift diagonal');
        saveas(gcf, '../Output/d_shift_image', 'jpg');
        imshow(d_shift_image);
        
        
    close all
    
end
function [] = part_two()

    %exercise 5
    clear all
    clc
    
    [image_original, map] = imread('peppers.png');
    
    %transform image into gray color
    image = rgb2gray(image_original);
    [x, y] = size(image);
    
    %maximize show window
    set(gcf, 'units', 'normalized', 'outerposition', [0 0 1 1]);
     
    convolucoes_array = zeros(x, y, 5); 
    convolucoes_array(:,:,5) = edge(image,'canny');
    mask = {fspecial('sobel') fspecial('prewitt') fspecial('laplacian') fspecial('log')};
    title_names = {'Sobel' 'Prewitt' 'Laplaciano' 'Laplaciano da Gaussiana' 'Canny'};
   
    for i = 1 : 5
        if(i<5)
            convolucoes_array(:,:,i)=imfilter(image, mask{i});
        end
        
        subplot(1,1,1);
        imshow(convolucoes_array(:,:,i));
        title(title_names(i));
        pause();
        
        F = fft2(convolucoes_array(:,:,i));
        
        subplot(2,1,1);
        imagesc(100*log(1+abs(fftshift(F)))); 
        colormap(gray); 
        title(title_names(i));
        xlabel('Modulo');
        
        subplot(2,1,2);
        imagesc(angle(F)); 
        colormap(gray);
        xlabel('Fase');

        pause();
    end 
    
    
    %exercise 6
    image2 = imfilter(image, fspecial('gaussian'));
    
    convolucoes_array2 = zeros(x, y, 5); 
    convolucoes_array2(:,:,5) = edge(image2,'canny');
   
    for i = 1 : 5
        if(i<5)
            convolucoes_array2(:,:,i)=imfilter(image2, mask{i});
        end
        
        subplot(1,2,1);
        imshow(convolucoes_array(:,:,i));
        title(strcat(title_names(i),' sem filtro gaussiano'));
        
        subplot(1,2,2);
        imshow(convolucoes_array2(:,:,i));
        title(strcat(title_names(i),' com filtro gaussiano'));
        pause();
        
        F = fft2(convolucoes_array(:,:,i));
        F2 = fft2(convolucoes_array2(:,:,i));
        
        subplot(2,2,1);
        imagesc(100*log(1+abs(fftshift(F)))); 
        colormap(gray); 
        title(title_names(i));
        xlabel('Modulo');
        
        subplot(2,2,2);
        imagesc(100*log(1+abs(fftshift(F2)))); 
        colormap(gray); 
        title(strcat(title_names(i), ' com filtro Gaussiano'));
        xlabel('Modulo com filtro Gaussiano');
        
        subplot(2,2,3);
        imagesc(angle(F)); 
        colormap(gray);
        xlabel('Fase');
        
        subplot(2,2,4);
        imagesc(angle(F2)); 
        colormap(gray);
        xlabel('Fase com filtro Gaussiano');

        pause();
    end
    
    %exercise 7
    subplot(1,1,1);
    x = 0:45:315;
    aux = size(x);
    for i = 1 : 5 
        a = edge(convolucoes_array(:,:,i), 'sobel');
        imshow(a);
        title(title_names(i));
        pause();
        [H,T,R] = hough(a);
        P = houghpeaks(H, 150);
        lines = houghlines(a, T, R, P);
        aux = zeros(size(x));
        for k=1 : length(lines)
            if(lines(k).theta==0 || lines(k).theta==45 || lines(k).theta==90 || lines(k).theta==135 || lines(k).theta==180 || lines(k).theta==-45 || lines(k).theta==-90 || lines(k).theta==-135 || lines(k).theta==-180)
                if(lines(k).theta < 0)
                    var=360+lines(k).theta;
                    aux(var/45) =  aux(var/45) + 1;
                else
                    var=lines(k).theta; 
                    aux(var/45) =  aux(var/45) + 1;
                end
            end
        end
        bar(x,aux);
        title(title_names(i));
        pause();
    end
    
    
    %exercise 8
    I = imfilter(image,fspecial('gaussian'));
    
    mask_x = [-1 -2 -1; 0 0 0; 1 2 1];
    mask_y = [-1 0 1; -2 0 2; -1 0 1];
    
    Ix = conv2(double(I), double(mask_x));
    Iy = conv2(double(I), double(mask_y));
    
    G = sqrt(Ix.^2 +Iy.^2);
    
    limiar = 127;
    [x,y] = size(G);
    O = zeros(x,y);
    
    for i=1 : x
        for j=1 : y
            if(G(i,j)>limiar)
                O(i,j)= 255;
            else
                O(i,j)=0;
            end
        end
    end
    
    imshow(O);
    title('Algoritmo SOBEL');
    pause();
    
    close all;
    
end
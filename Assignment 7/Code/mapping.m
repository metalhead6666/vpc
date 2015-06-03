function mapping()
%  1.1
%  generate a squared mesh with the coordinates from -10 to 10
    [p, q] = meshgrid(-10:10);
    mesh_points = [p(:) q(:)];
    
%  representing the squared mesh
    plot_and_save_mesh(mesh_points, 'squared mesh');
    
%  1.2
	x = mesh_points(:, 1);
	y = mesh_points(:, 2);

%  x' = 2 + 3x^2 + 5y^2
%  y' = 5 + 1/2x^2 + 3y^2
    transformed_mesh_1 = zeros(size(mesh_points));
    
    transformed_mesh_1(:, 1) = 2 + 3.*(x.^2) + 5.*(y.^2);
    transformed_mesh_1(:, 2) = 5 + (1/2).*(x.^2) + 3.*(y.^2);
    
    plot_and_save_mesh(transformed_mesh_1, 'transformed mesh 1');
    
%  x' = 2 + 3e^(-x) + 5e^(-y)
%  y' = 1/3 + 2e^(-2x) + 3e^(-y/2)
    transformed_mesh_2 = zeros(size(mesh_points));
    
    transformed_mesh_2(:, 1) = 2 + 3.*exp(-x) + 5.*exp(-y);
    transformed_mesh_2(:, 2) = 1/3 + 2.*exp(-2.*x) + 3.*exp(-y./2);
    
    plot_and_save_mesh(transformed_mesh_2, 'transformed mesh 2');
    
%  x' = x^2 + y^3
%  y' = cos(x) + sin(y)
    transformed_mesh_3 = zeros(size(mesh_points));
    
    transformed_mesh_3(:, 1) = x.^2 + y.^3;
    transformed_mesh_3(:, 2) = cos(x) + sin(y);
    
    plot_and_save_mesh(transformed_mesh_3, 'transformed mesh 3');
    
%  1.3
    n = 441;
	homography_matrix(mesh_points,transformed_mesh_1, n); 
	homography_matrix(mesh_points,transformed_mesh_2, n);
	homography_matrix(mesh_points,transformed_mesh_3, n);
   
    dif_mesh_1 = zeros(n:2);
    dif_mesh_2 = zeros(n:2);
    dif_mesh_3 = zeros(n:2);
    for i=1:n
        dif_mesh_1(i,:) = mesh_points(i,:) - transformed_mesh_1(i,:);
        dif_mesh_2(i,:) = mesh_points(i,:) - transformed_mesh_2(i,:);
        dif_mesh_3(i,:) = mesh_points(i,:) - transformed_mesh_3(i,:);
    end
    
    %Valor médio e desvio-padrão
    media_x_mesh1 = mean(dif_mesh_1(:,1));
    media_y_mesh1 = mean(dif_mesh_1(:,2));
    desvio_x_mesh1 = std(dif_mesh_1(:,1));
    desvio_y_mesh1 = std(dif_mesh_1(:,2));
    plot_tab(media_x_mesh1, media_y_mesh1, desvio_x_mesh1, desvio_y_mesh1, 'a');
    
    media_x_mesh2 = mean(dif_mesh_2(:,1));
    media_y_mesh2 = mean(dif_mesh_2(:,2));
    desvio_x_mesh2 = std(dif_mesh_2(:,1));
    desvio_y_mesh2 = std(dif_mesh_2(:,2));
    plot_tab(media_x_mesh2, media_y_mesh2, desvio_x_mesh2, desvio_y_mesh2, 'b');
    
    media_x_mesh3 = mean(dif_mesh_3(:,1));
    media_y_mesh3 = mean(dif_mesh_3(:,2));
    desvio_x_mesh3 = std(dif_mesh_3(:,1));
    desvio_y_mesh3 = std(dif_mesh_3(:,2));
    plot_tab(media_x_mesh3, media_y_mesh3, desvio_x_mesh3, desvio_y_mesh3, 'c');
    
%2
    right_image_02 = imread('../Input/Cam_dir_02.ppm');
    right_image_05 = imread('../Input/Cam_dir_05.ppm');
    left_image_02 = imread('../Input/Cam_esq_02.ppm');
    left_image_05 = imread('../Input/Cam_esq_05.ppm');
    images = {right_image_02; right_image_05; left_image_02; left_image_05};
    
%3
    right_points_02 = [375 337; 390 583; 670 720; 670 405];  
    right_points_05 = [120 390; 155 670; 585 708; 575 400];  
    left_points_02 = [220 80; 240 505; 855 525; 895 90]; 
    left_points_05 = [70 115; 120 715; 755 540; 785 95];
    
    images2 = {'rightImage02', 'rightImage05', 'leftImage02', 'leftImage05'};
    vec_images = {right_points_02, right_points_05, left_points_02, left_points_05};
    for i=1:4
        imshow(images{i});
        hold on;
        plot(vec_images{i}(:,1), vec_images{i}(:,2), 'g*');
        str = strcat('Imagem:_', images2{i});
        str = strcat(str, ' com os pontos');
        title(str);
        str = strcat('../Output/', images2{i});
        saveas(gcf, str, 'jpg');
    end
    close all;
    
    homografia_02 = homography_matrix( left_points_02, right_points_02, 4)
    homografia_05 = homography_matrix( left_points_05, right_points_05, 4)

    
    
end

function plot_and_save_mesh(mesh, str)
    plot(mesh(:, 1), mesh(:, 2), 'r*');
    title(str);
    str = strcat('../Output/', str);    
    saveas(gcf, str, 'jpg');
    close all;
end

function [H] = homography_matrix( mesh_points, transformed_mesh, n)
	x1 = transformed_mesh(:, 1);
	y1 = transformed_mesh(:, 2);
	x2 = mesh_points(:, 1); 
	y2 = mesh_points(:, 2);
    A = zeros(2*n:9);
    j=1;
    for i=1:2:2*n
        A(i,:) = [-x1(j) -y1(j) -1 0 0 0 x2(j)*x1(j) x2(j)*y1(j) x2(j)];
        A(i+1,:) = [0 0 0 -x1(j) -y1(j) -1 y2(j)*x1(j) y2(j)*y1(j) y2(j)];
        j=j+1;
    end
    
    % Decomposition of A in singular values 
    [U, S, V] = svd(A);
    
    % Criation of Matrix H
    V=V';
    h = V(:,9);
    H = [h(1) h(2) h(3)
         h(4) h(5) h(6)
         h(7) h(8) h(9)];
end

function plot_tab(media_x, media_y, desvio_x, desvio_y, str)
    Media = [media_x; media_y];
    DesvioPadrao = [desvio_x; desvio_y];
    Variables = {'x';'y'};
    if(strcmp(str,'a')==1)
        a = table(Media, DesvioPadrao,'RowNames',Variables)
    elseif(strcmp(str,'b')==1)
        b = table(Media, DesvioPadrao,'RowNames',Variables)
    elseif(strcmp(str,'c')==1)
        c = table(Media, DesvioPadrao,'RowNames',Variables)
   
    end
end

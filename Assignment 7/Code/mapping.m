function mapping()
%  1.1
%  generate a squared mesh with the coordinates from -10 to 10
    [p, q] = meshgrid(-10:10);
    mesh_points = [p(:) q(:)];
    
%  representing the squared mesh
    plot_and_save_mesh(mesh_points, 'squared mesh');
    
%  1.2
%  x' = 2 + 3x^2 + 5y^2
%  y' = 5 + 1/2x^2 + 3y^2
    transformed_mesh_1 = zeros(size(mesh_points));
    
    transformed_mesh_1(:, 1) = 2 + 3 .* (mesh_points(:, 1)).^2 + 5 .* (mesh_points(:, 2)).^2;
    transformed_mesh_1(:, 2) = 5 + (1/2) .* (mesh_points(:, 1)).^2 + 3 .* (mesh_points(:, 2)).^2;
    
    plot_and_save_mesh(transformed_mesh_1, 'transformed mesh 1');
    
%  x' = 2 + 3e^(-x) + 5e^(-y)
%  y' = 1/3 + 2e^(-2x) + 3e^(-y/2)
    transformed_mesh_2 = zeros(size(mesh_points));
    
    transformed_mesh_2(:, 1) = 2 + 3 .* exp(-mesh_points(:, 1)) + 5 .* exp(-mesh_points(:, 2));
    transformed_mesh_2(:, 2) = 1/3 + 2 .* exp(-2 .* mesh_points(:, 1)) + 3 .* exp(-(mesh_points(:, 2)./2));
    
    plot_and_save_mesh(transformed_mesh_2, 'transformed mesh 2');
    
%  x' = x^2 + y^3
%  y' = cos(x) + sin(y)
    transformed_mesh_3 = zeros(size(mesh_points));
    
    transformed_mesh_3(:, 1) = mesh_points(:, 1).^2 + mesh_points(:, 2).^3;
    transformed_mesh_3(:, 2) = cos(mesh_points(:, 1)) + sin(mesh_points(:, 2));
    
    plot_and_save_mesh(transformed_mesh_3, 'transformed mesh 3');
    
%  1.3
        
end

function plot_and_save_mesh(mesh, str)
    plot(mesh(:, 1), mesh(:, 2), 'r*');
    title(str);
    str = strcat('../Output/', str);    
    saveas(gcf, str, 'jpg');
    close all;
end
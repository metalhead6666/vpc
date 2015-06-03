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
	homography_matrix(mesh_points,transformed_mesh_1); 
	homography_matrix(mesh_points,transformed_mesh_2);
	homography_matrix(mesh_points,transformed_mesh_3);
end

function plot_and_save_mesh(mesh, str)
    plot(mesh(:, 1), mesh(:, 2), 'r*');
    title(str);
    str = strcat('../Output/', str);    
    saveas(gcf, str, 'jpg');
    close all;
end

function homography_matrix( mesh_points, transformed_mesh)
	x1 = transformed_mesh(:, 1);
	y1 = transformed_mesh(:, 2);
	x2 = mesh_points(:, 1); 
	y2 = mesh_points(:, 2);
    n = 441;
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
         h(7) h(8) h(9)]

    
end

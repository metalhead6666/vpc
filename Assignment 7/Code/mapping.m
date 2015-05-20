function mapping()
%  1.1
%  generate a squared mesh with the coordinates from -10 to 10
    [p, q] = meshgrid(-10:10);
    mesh_points = [p(:) q(:)];
    
%  representing the squared mesh
    plot(mesh_points(:, 1), mesh_points(:, 2), 'r*');
    saveas(gcf, '../Output/squared_mesh', 'jpg');
    close all;
    
%  1.2
    
end
function [histogram_values, list] = corner_detection(image, N, sigma, verbose)    
    [width, height] = size(image);
    
    %calculate gradient
    Sobel_hor_mask = [-1 -2 -1; 0 0 0; 1 2 1];
    Sobel_ver_mask = [-1 0 1; -2 0 2; -1 0 1];

    Ix = imfilter(image, Sobel_hor_mask);
    Iy = imfilter(image, Sobel_ver_mask);

    Ix = double(Ix);
    Iy = double(Iy);
    
    %number of pixels calculated by neighborhood -> 2N + 1
    limit = 2*N+1;
    
    %list to save the coordinates of point P of which lambda2 is higher
    %than sigma
    list = [];
    histogram_values = [];
    plot_C = [];
    
    %calculate matrix C for each neighborhood Q
    for px = 1 + limit : width - limit
        for py = 1 + limit : height - limit
            %sum of the gradient points in the neighborhood to save in the
            %matrix C
            Q_Ix_Iy = sum(sum(Ix(px - limit : px + limit, py - limit : py + limit) .* Iy(px - limit : px + limit, py - limit : py + limit)));
            Q_Ix_2 = sum(sum(Ix(px - limit : px + limit, py - limit : py + limit).^2));
            Q_Iy_2 = sum(sum(Iy(px - limit : px + limit, py - limit : py + limit).^2));
            
            %calculate the eigenvector of C
            C = [Q_Ix_2 Q_Ix_Iy; Q_Ix_Iy Q_Iy_2];
            C = eig(C);
            plot_C = [plot_C; C];
            
            %save the lowest value of lambda2 in the matrix C
            minimum = min(C);
            histogram_values = [histogram_values; minimum];
            
            %if the minor value of lambda2 is equal or higher than sigma,
            %then we save the value and the coordinates of the point P in
            %the list
            if minimum >= sigma
                list = [list; minimum px py];                
            end                        
        end
    end
    
    if verbose == 1
        plot(plot_C, 'k');
        str = sprintf('Tension Vector of Matrix C, %d*%d', limit, limit);
        title(str);
        str = sprintf('tension_%d_%d', limit, limit);
        saveas(gcf, str, 'jpg');
        close all;
    end
    
    %sort list by descending order (-1) on first row
    list = sortrows(list, -1);
    [x, ~] = size(list);
    deleteFromList = [];    
    
    for iterator = 1 : x
        %saves the point existent in the iteration
        px = list(iterator, 2);
        py = list(iterator, 3);
        
        %verifies if it exists some point in the list which belongs to the neighborhood
        firstPoint = exists(list(1:iterator, 2), px - limit:px + limit);
        secondPoint = exists(list(1:iterator, 3), py - limit:py + limit);
        
        %if some point belongs in the neighborhood, then it's saved in the
        %list of deleted points to be deleted later        
        if firstPoint == 1 && secondPoint == 1
             deleteFromList = [deleteFromList; iterator];             
        end       
    end
    
    %deletes the existent points
    list(deleteFromList, :) = [];
end

function found = exists(list, array)
    found = 0;
    
    [m, n] = size(list);
    k = size(array);
    
    if m < 1 || n < 1
        return;
    end

    for i = 1 : m   
        for j = 1 : n        
            for q = 1 : k            
                if(list(i,j) == array(q))
                    found = 1;
                    return;
                end
            end
        end
    end
end
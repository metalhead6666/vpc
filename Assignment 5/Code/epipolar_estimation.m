function epipolar_estimation(F, corners, images, p)
%% part one
%% exercise two
    [U, D, V] = svd(F);
    [~, index] = min(sum(D));
    
% left epipole
    left_epipole = V(:, index);
    left_epipole = left_epipole ./ left_epipole(3);
    
% right epipole
    right_epipole = U(:, index);
    right_epipole = right_epipole ./ right_epipole(3);
    
%% exercise three    
% show epipoles
    showInImage(corners{1}, images{1}, left_epipole, 'LeftImage02', p{1}, 1, length(p{1}) / 2);
    showInImage(corners{2}, images{2}, left_epipole, 'LeftImage05', p{1}, 11, length(p{1}));
    showInImage(corners{3}, images{3}, right_epipole, 'RightImage02', p{2}, 1, length(p{1}) / 2);
    showInImage(corners{4}, images{4}, right_epipole, 'RightImage05', p{2}, 11, length(p{1}));
end

function showInImage(corner, image, epipole, str, p, n, length_loop)
    figure;
    imshow(image);
    title(str);
    hold on;
    plot(corner(:, 1), corner(:, 2), 'r*');
    hold on;
    plot(epipole(1), epipole(2), '*g');
    hold on;
    
%% exercise four
    xmin = min(0, epipole(1));
    xmax = max(epipole(1), size(image, 2));
    ymin = min(0, epipole(2));
    ymax = max(epipole(2), size(image, 1));
    
    axis([xmin xmax ymin ymax]);
    hold on;
    
    for i = n : length_loop
        line([epipole(1) p(i, 1)], [epipole(2) p(i, 2)]);
    end
    
    str = strcat('../Output/', str);
    saveas(gcf, str, 'jpg');
    close all;
end
function [] = linesDetection(image)
    [rho, theta, houghSpace] = houghTransform(image, 0.1);
    P = houghpeaks(houghSpace, 5, 'threshold', ceil(0.3 * max(houghSpace(:))));
    lines = houghlines(im2bw(image, 0.5), theta, rho, P, 'FillGap', 5, 'MinLength', 7);

    figure, imshow(image), hold on

    for k = 1:length(lines)
       xy = [lines(k).point1; lines(k).point2];
       plot(xy(:, 1), xy(:, 2), 'LineWidth', 2, 'Color', 'green');
    end

    saveas(gcf, '../Output/hough_lines', 'jpg');
    close all;
end
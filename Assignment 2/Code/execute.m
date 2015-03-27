clear all
clc

image = imread('../Images/chess_2.png');    
image = rgb2gray(image);

%exercise 1

%the function receives an image, a N, used to calculate the neighborhood
%(2N+1) and sigma value to define which lambda2 is saved on the list
%returns the list with the lambda2 values filtered with the neighborhood and their points
[histogram_values, list] = corner_detection(image, 1, 250000, 1);

%exercise 2
[n, h] = hist(histogram_values, 15);
bar(h, n);
title('Histogram of \lambda_2 along the image chess2.png');
set(gca,'YScale','log');
saveas(gcf, '../Output/histogram_chess2_3_3', 'jpg');

%exercise 3
imshow(image);
hold on;
plot(list(:,3), list(:,2), 'r+');
title('Image with corners detected');
saveas(gcf, '../Output/corners_chess2_3_3', 'jpg');
close all;

%chess_2, 5*5
[histogram_values, list] = corner_detection(image, 2, 250000, 1);

[n, h] = hist(histogram_values, 15);
bar(h, n);
title('Histogram of \lambda_2 along the image chess2.png');
set(gca,'YScale','log');
saveas(gcf, '../Output/histogram_chess2_5_5', 'jpg');

%exercise 3
imshow(image);
hold on;
plot(list(:,3), list(:,2), 'r+');
title('Image with corners detected');
saveas(gcf, '../Output/corners_chess2_5_5', 'jpg');
close all;

%corners, 3*3
image = imread('../Images/corners.jpg');
[histogram_values, list] = corner_detection(image, 1, 50000, 0);

[n, h] = hist(histogram_values, 15);
bar(h, n);
title('Histogram of \lambda_2 along the image corners.jpg');
set(gca,'YScale','log');
saveas(gcf, '../Output/histogram_corners_3_3', 'jpg');

%exercise 4
imshow(image);
hold on;
plot(list(:,3), list(:,2), 'r+');
title('Image with corners detected');
saveas(gcf, '../Output/corners_corners_3_3', 'jpg');
close all;

%corners, 5*5
[histogram_values, list] = corner_detection(image, 2, 50000, 0);

[n, h] = hist(histogram_values, 15);
bar(h, n);
title('Histogram of \lambda_2 along the image corners.jpg');
set(gca,'YScale','log');
saveas(gcf, '../Output/histogram_corners_5_5', 'jpg');

%exercise 4
imshow(image);
hold on;
plot(list(:,3), list(:,2), 'r+');
title('Image with corners detected');
saveas(gcf, '../Output/corners_corners_5_5', 'jpg');

close all;
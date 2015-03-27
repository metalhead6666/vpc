clear all
clc

image = imread('../Images/lines_circles_2.jpg');
image = rgb2gray(image);

%Hough Transform Lines
linesDetection(image);

%Hough Transform Circles
circlesDetection(image, 20, 50 ,0.5, 10);

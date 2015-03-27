function [rho, theta, houghSpace] = houghTransform(theImage, thetaSampleFrequency)
    [width, height] = size(theImage);
 
    rhoLimit = norm([width height]);
    rho = (-rhoLimit:1:rhoLimit);          
    theta = (0:thetaSampleFrequency:pi);
 
    numThetas = numel(theta);
    houghSpace = zeros(numel(rho),numThetas);
 
    [xIndicies,yIndicies] = find(theImage);
 
    numEdgePixels = numel(xIndicies);
    accumulator = zeros(numEdgePixels,numThetas);
 
    cosine = (0:width-1)'*cos(theta); 
    sine = (0:height-1)'*sin(theta); 
 
    accumulator((1:numEdgePixels),:) = cosine(xIndicies,:) + sine(yIndicies,:);

    for i = (1:numThetas)
        houghSpace(:,i) = hist(accumulator(:,i),rho);
    end
 
    %accumulator 3D graphic
    surf(theta, rho, houghSpace);
    colormap([1 0 0]);
    saveas(gcf, '../Output/Accumulator_3d_hough', 'jpg');
    close all;

    %plot of hough space
    pcolor(theta, rho, houghSpace);
    shading flat;
    title('Hough Transform');
    xlabel('\theta (radians)');
    ylabel('\rho (pixels)');
    colormap('gray');
    saveas(gcf, '../Output/hough_space', 'jpg');
    close all;
end
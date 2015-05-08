function F = fundamental_matrix()
%% part one
% read images, save corners and show the corners position in the images
    right_image_02 = readImage('Cam_dir_02.ppm');
    right_image_05 = readImage('Cam_dir_05.ppm');
    left_image_02 = readImage('Cam_esq_02.ppm');
    left_image_05 = readImage('Cam_esq_05.ppm');

    right_image_corners_02 = [378 339; 659 413; 412 586; 642 669; 429 452; 431 477; 497 503; 518 488; 597 516; 596 541];
    right_image_corners_05 = [128 397; 564 408; 191 666; 545 696; 219 511; 222 538; 331 545; 358 518; 478 527; 478 553];
    left_image_corners_02 = [236 94; 881 106; 291 494; 805 511; 364 263; 363 305; 530 308; 573 268; 742 273; 741 314];
    left_image_corners_05 = [90 136; 778 108; 186 693; 717 541; 269 354; 271 409; 465 375; 507 321; 664 300; 664 344];
        
    warning('off', 'Images:initSize:adjustingMag');
    showImage(right_image_02, right_image_corners_02, 'RightCamera02');
    showImage(right_image_05, right_image_corners_05, 'RightCamera05');
    showImage(left_image_02, left_image_corners_02, 'LeftCamera02');
    showImage(left_image_05, left_image_corners_05, 'LeftCamera05');

%% exercise one   
% calculate the fundamental matrix with 8 points algorithm
% normalização das coordenadas
pe = [left_image_corners_02(:,1) left_image_corners_02(:,2) left_image_corners_05(:,1) left_image_corners_05(:,2)];
pe = [pe ones(10,1)];
pd = [right_image_corners_02(:,1) right_image_corners_02(:,2) right_image_corners_05(:,1) right_image_corners_05(:,2)];
pd = [pd ones(10,1)];


    
end

function image = readImage(str)
    str = strcat('../Input/', str);
    image = imread(str);
    image = rgb2gray(image);
end

function showImage(image, corners, str)
    figure;
    imshow(image);
    hold on;
    plot(corners(:, 1), corners(:, 2), 'r+');
    title(str);
    str = strcat('../Output/', str);
    saveas(gcf, str, 'jpg');
    close all;
end
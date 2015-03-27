function circlesDetection(im, minR, maxR, thresh, delta)

% Inputs:
%   - im: imagem
%   - minR: raio minimo
%   - maxR: raio maximo
%   - thresh: racio minimo de numero de bordas detectadas 
%   - delta: maxima diferen�a entre 2 circulos 


if minR<0 || maxR<0 || minR>maxR || thresh<0 || thresh>1 || delta<0
  disp('Input conditions: 0<minR, 0<maxR, minR<=maxR, 0<thresh<=1, 0<delta');
  return;
end

[width,height] = size(im);

origim = im;

%Array que especifica os centros e raios ds circulos
maxR2 = 2*maxR;
hough = zeros(size(im,1)+maxR2, size(im,2)+maxR2, maxR-minR+1);

[X Y] = meshgrid(0:maxR2, 0:maxR2);
Rmap = round(sqrt((X-maxR).^2 + (Y-maxR).^2));
Rmap(Rmap<minR | Rmap>maxR) = 0;

edgeim = edge(im, 'canny', [0.15 0.2]);
[Ey Ex] = find(edgeim);
[Cy Cx R] = find(Rmap);
 
for i = 1:length(Ex);
  Index = sub2ind(size(hough), Cy+Ey(i)-1, Cx+Ex(i)-1, R-minR+1);
  hough(Index) = hough(Index)+1;
end

% Armazenar circulos candidatos
twoPi = 0.9*2*pi;
circles = zeros(0,4);   
for radius = minR:maxR   
  slice = hough(:,:,radius-minR+1); 
  twoPiR = twoPi*radius;
  slice(slice<twoPiR*thresh) = 0;  
  [y x count] = find(slice);
  circles = [circles; [x-maxR, y-maxR, radius*ones(length(x),1), count/twoPiR]];
end

% Eliminar Circulos vizinhos 
circles = sortrows(circles,-4); 
i = 1;
while i<size(circles,1)
  j = i+1;
  while j<=size(circles,1)
    if sum(abs(circles(i,1:3)-circles(j,1:3))) <= delta
      circles(j,:) = [];
    else
      j = j+1;
    end
  end
  i = i+1;
end

% Desenhar circulos
if nargout==0   
  figure, imshow(origim), hold on;
  for i = 1:size(circles,1)
    x = circles(i,1)-circles(i,3);
    y = circles(i,2)-circles(i,3);
    w = 2*circles(i,3);
    rectangle('Position', [x y w w], 'EdgeColor', 'green', 'Curvature', [1 1], 'LineWidth',2.5);
    plot(circles(i,1),circles(i,2),'*r');
  end
  hold off;
  title('Circles Detection with Hough Transform');
  saveas(gcf, '../Output/hough_circles', 'jpg');
  close all;
end
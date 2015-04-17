function [] = calc_fluxo(image, shift_image, image_name)
    %criação das estruturas para as derivadas parciais
    [n_rows n_columns] = size(image);
    Ix = zeros(n_rows, n_columns);
    Iy = zeros(n_rows, n_columns);
    It = zeros(n_rows, n_columns);
    v_const=[];
    v_afim=[];

    %obtenção das derivadas parciais para cada uma das imagens
    for i=1:n_rows-1
        for j=1:n_columns-1
            Ix(i,j)= (1/4)*(image(i+1,j)+shift_image(i+1,j)+image(i+1,j+1)+shift_image(i+1,j+1))-(1/4)*(image(i,j)+shift_image(i,j)+image(i,j+1)+shift_image(i,j+1));
            Iy(i,j)= (1/4)*(image(i,j+1)+shift_image(i,j+1)+image(i+1,j+1)+shift_image(i+1,j+1))-(1/4)*(image(i,j)+shift_image(i,j)+image(i+1,j)+shift_image(i+1,j));
            It(i,j)= (1/4)*(shift_image(i,j)+shift_image(i,j+1)+shift_image(i+1,j)+shift_image(i+1,j+1))-(1/4)*(image(i,j)+image(i,j+1)+image(i+1,j)+image(i+1,j+1));
        end
    end
    
    step = 20;
    window = 10;
    half_window = window/2;
  
    for i=window:step:n_rows-window
       for j=window:step:n_columns-window
           x = i-half_window:i+half_window;
           y = j-half_window:j+half_window;
           
           ix = Ix(x,y);
           ix = reshape(ix',[],1);
           iy = Iy(x,y);
           iy = reshape(iy',[],1);
           it = It(x,y);
           it = reshape(it',[],1);
           
           %Modelo constante 
           model_const = [ix iy];
           b = -it;
           r = pinv(model_const)*b;
           vx=r(1);
           vy=r(2);
           v_const=[v_const;j,i,vx,vy];
           
           %Modelo afim
           model_afim = [ix i*ix j*ix iy i*iy j*iy];
           r = pinv(model_afim)*b;
           vx=r(1)+i*r(2)+j*r(3);
           vy=r(4)+i*r(5)+j*r(6);
           v_afim=[v_afim;j,i,vx,vy];
       end
    end
    
    %vectores medios de movimento
    vx_medio_const = mean(v_const(:,3))
    vy_medio_const = mean(v_const(:,4))
    vx_medio_afim = mean(v_afim(:,3))
    vy_medio_afim = mean(v_afim(:,4))
    
    %desvio padrão em módulo e direcção
    vx_desvio_const = std(v_const(:,3))
    vy_desvio_const = std(v_const(:,4))
    vx_desvio_afim = std(v_afim(:,3))
    vy_desvio_afim = std(v_afim(:,4))
    
    vx_modulo_const = abs(vy_desvio_const)
    vy_modulo_const = abs(vy_desvio_const)
    vx_modulo_afim = abs(vx_desvio_afim)
    vy_modulo_afim = abs(vx_desvio_afim)
    
    vx_fase_const = angle(vy_desvio_const)
    vy_fase_const = angle(vy_desvio_const)
    vx_fase_afim = angle(vx_desvio_afim)
    vy_fase_afim = angle(vx_desvio_afim)
    
    
    
    %Desenho dos vectores de movimento
    %Modelo Constante
    imshow(shift_image);
    hold on
        for i=1:length(v_const)
            quiver(v_const(i,1),v_const(i,2),v_const(i,3),v_const(i,4),step/2,'g');
        end
        title(['Vectores do Modelo Constante -> ' image_name]);
    hold off
    if(strcmp(image_name,'shift horizontal')==1)
        saveas(gcf, '../Output/h_shift_vector', 'jpg');
    elseif(strcmp(image_name,'shift vertical')==1)
        saveas(gcf, '../Output/v_shift_vector', 'jpg');
    elseif(strcmp(image_name,'shift diagonal')==1)
        saveas(gcf, '../Output/d_shift_vector', 'jpg');
    end

    %Modelo Afim
    imshow(shift_image);
    hold on
        for i=1:length(v_afim)
            quiver(v_afim(i,1),v_afim(i,2),v_afim(i,3),v_afim(i,4),step/2,'b');
        end
        title(['Vectores do Modelo Afim -> ' image_name]);
    hold off
    if(strcmp(image_name,'shift horizontal')==1)
        saveas(gcf, '../Output/h_shift_vector_afim', 'jpg');
    elseif(strcmp(image_name,'shift vertical')==1)
        saveas(gcf, '../Output/v_shift_vector_afim', 'jpg');
    elseif(strcmp(image_name,'shift diagonal')==1)
        saveas(gcf, '../Output/d_shift_vector_afim', 'jpg');
    end

end
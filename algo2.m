%% Función que a partir de una imagen, los histogramas, de piel y fondo, y los Edges que se han usado para construir dichos histogramas, devuelve la máscara %%
%% de decisión de los píxeles de piel %%
function [mask_image] = algo2(im, treshold,xv,yv,histcountPielNormalized, histcountFondoNormalized) 
    
    %% Se pasa la imagen al espacio de trabajo %%
    imagen_prueba = rgb2ycbcr(im);
    cb_im = double(imagen_prueba(:,:,2));
    cr_im = double(imagen_prueba(:,:,3));
    [N,Xedges,Yedges,binX,binY] = histcounts2(cb_im,cr_im,xv,yv); %% Se crea el histograma de la imagen, usando los Edges determinados %%
    [li, wi, di] = size(imagen_prueba);
    mask_image=zeros(li, wi);  %% Se inicializa la máscara, a crear, de la imagen %%
   
   %% número de píxeles del radio de los elementos estructurantes usados para el post-procesado %%
    r_o =4; 
    r_a = 5;
    
    %% Bucle principal de decisión; si un pixel de la imágen es piel o fondo %%
    for i = 1 : wi
        for j = 1 : li
            pos_x = binX(j,i); %% Localizamos cada píxel de la imagen %%
            pos_y = binY(j,i);
            
            %% Detectamos el valor de cada histograma(puede ser interpetado como una probabilidad) para el valor Cb Cr de ese píxel %%
            prob = histcountPielNormalized (pos_x, pos_y);
            prob_b = histcountFondoNormalized(pos_x, pos_y);
            
             %% Si se cumple que la razón entre la probabilidad de piel de ese nivel y la probabilidad de fondo supera cierto treshold decidiremos piel %%
            if(log(prob)-log(prob_b)>= treshold  )  
                mask_image(j,i) = 1;  %% Actualizamos máscara para decidir piel en el pixel correspondiente %%
            end
        end
    end
    
    %% Hacemos un post-procesado para mejorar las prestaciones de la decisión. Realizamos un cierre y una apertura morfológica usando un disco como elemento estructurante %%
    SE = strel('disk',r_o);
    SE2 = strel ('disk', r_a);
    mask_image = imclose(mask_image, SE);
    mask_image = imopen(mask_image, SE2);

end
   
   
    
    
    
    

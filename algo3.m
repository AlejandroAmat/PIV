%% Función que crea las máscaras de un grupo de imágenes(imágenes de validación) y las guarda en "./new_masks". %%
%% Como argumentos se le pasa un treshold para tomar la decisión, los histogramas y los Edges. %%
function algo3 (treshold, xv, yv, histCountPiel, histCountFondo)
    %% Nos colocamos en el directorio de trabajo y cargamos las imágenes de validación. %%
    cd ('.\images_val'); 
    list_validation = dir ('*.jpg');
    images_val = cell(1, length(list_validation));
    image_prueba = cell(1, length(list_validation));
    mask_file_val = cell (1,length(list_validation)); 

    for k = 1 : length (list_validation)
        image_val = imread(list_validation(k).name);
        images_val{k} = image_val;
        image_prueba{k} = image_val;
    end
   
    cd ('..\masks_val');
    list_masks_val=dir('*.bmp');

    for i = 1 : length(list_validation)
        masks_file_val = imread(list_masks_val(i).name);
        mask_file_val{i}=int8(masks_file_val);
    end
    
    %% Creamos las máscaras para cada imagen de validación y guardamos el resultado. %% 
    for k = 1 :  length(list_validation)
        cd ('..');
        [mask_image] = algo2(images_val{k}, treshold, xv, yv, histCountPiel, histCountFondo);
        cd('./new_masks');
        filename = list_masks_val(k).name;
        imwrite(mask_image, filename);
    end
    
    cd('..');
    
 end

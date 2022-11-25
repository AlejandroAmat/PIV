
function [histCountPiel, histCountFondo,xv,yv] = algo1() %% Función que nos devuelve los histogramas normalizados de piel y fondo %%
                                                         %% También devuelve vectores utilizados para crear estos histogramas(basandose en el número de Bins) %%
    
    %% Nos ponemos en el directorio de trabajo %%
    cd('C:\Users\gobbe\OneDrive\Escritorio\Cfis\4a\project_PIV');
    cd ('.\Images');
    %% Creamos celdas para guardar imágenes originales, máscaras ideales y resultado de aplicar las máscaras a las imágenes %%
    list_images=dir('*.jpg');
    images = cell(1, length(list_images));
    images_b = cell(1, length(list_images));
    mask_file = cell (1,length(list_images));
    bins = 256; %% Haciendo pruebas este número de bins era el que nos daba mejor resultado %%
    
    %% Cargamos imágenes y las guardamos %%
    for i = 1 : length(list_images)
        image_file = imread(list_images(i).name);
        images{i}=image_file;
    end

    cd ('..\Masks-Ideal');
    list_masks=dir('*.bmp');
    total_pixels_piel = 0; %% Contador para poder normalizar los histogramas de piel %%
    total_pixels_fondo = 0; %% Contador para poder normalizar los histogramas del fondo %%
    
    %% Bucle principal que aplica las mascaras ideales a las imágenes. De esta forma tendremos imagenes del fondo y de piel separadas %%
    %% Cambiamos de espacio de representación de RGB a CbCr %%
    %% Calculamos el histograma normalizado de las imagenes de piel y , por separado, del fondo %%
    for i = 1 : length(list_images)

        masks_file = imread(list_masks(i).name);
        mask_file{i}=int8(masks_file);

        images_b{i}(:,:,1) = images{i}(:,:,1).*uint8(masks_file);
        images_b{i}(:,:,2) = images{i}(:,:,2).*uint8(masks_file);
        images_b{i}(:,:,3) = images{i}(:,:,3).*uint8(masks_file);

        images{i}(:,:,1) = images{i}(:,:,1).*uint8(1-masks_file);
        images{i}(:,:,2) = images{i}(:,:,2).*uint8(1-masks_file);
        images{i}(:,:,3) = images{i}(:,:,3).*uint8(1-masks_file);

        images{i} = rgb2ycbcr(images{i});
        images_b{i} = rgb2ycbcr(images_b{i});
       
        %% Componentes Cb y Cr de las imágenes %%       
        cb = images{i}(:,:,2);
        cr = images{i}(:,:,3);

        cbb = images_b{i}(:,:,2);
        crb = images_b{i}(:,:,3);

        [l,w,d] = size(images{i});

        total_pixels_fondo = total_pixels_fondo +  sum(mask_file{i}(:));
        total_pixels_piel = total_pixels_piel + sum(1-mask_file{i}(:));


        xv = 1:bins+1; %% Vectores para crear los histogramas basándose en el número de bins(Edges) %%
        yv = 1:bins+1;

        if(i == 1)
            histcount = histcounts2(cb,cr,xv,yv); 
            histcount(histcount==max(histcount(:))) = max(histcount(:))-sum(mask_file{i}(:));  %% Eliminamos del máximo los valores negros que resultan de haber %%
                                                                                               %% aplicado las mascaras ideales a las imágenes %%

            histcount_b = histcounts2(cbb,crb,xv,xv);
            histcount_b(histcount_b==max(histcount_b(:))) = max(histcount_b(:))-sum(1-mask_file{i}(:));
        else
            [histcount_aux, Xedges,Yedges, binX, binY] = histcounts2(cb,cr,xv,xv);
            histcount_aux(histcount_aux==max(histcount_aux(:))) =max(histcount_aux(:))-sum(mask_file{i}(:));
            histcount = histcount + histcount_aux; %% Sumamos al histograma total el histograma de cada imagen %%

            histcount_aux = histcounts2(cbb,crb,xv,xv);
            histcount_aux(histcount_aux==max(histcount_aux(:))) = max(histcount_aux(:))- sum(1-mask_file{i}(:));
            histcount_b = histcount_b + histcount_aux;    
        end    
    end
    
    %% Normalización de los histogramas por el número de pixeles de piel y fondo respectivamente %%
    histCountPiel = histcount/total_pixels_piel;
    histCountFondo = histcount_b/total_pixels_fondo;

    end

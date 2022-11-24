
function algo3 (treshold, xv, yv, histCountPiel, histCountFondo)

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

    for k = 1 :  length(list_validation)
        cd ('..');
        [mask_image] = algo2(images_val{k}, treshold, xv, yv, histCountPiel, histCountFondo);
        cd('./new_masks');
        filename = list_masks_val(k).name;
        imwrite(mask_image, filename);
    end
    
    cd('..');
    
 end
%% Función que calcula el F-Score, Precision y Recall de nuestro algoritmo principal dado un grupo de imágenes %%
function algo4()
    
    %% Cargamos las máscaras, calculadas con anterioridad, de un grupo de imágenes. %%
    %% Cargamos las máscaras ideales de este grupo de imágenes %%
    cd ('.\masks_val');
    list_masks_val=dir('*.bmp');
    mask_file_val = cell (1,length(list_masks_val));
    mask_file_new_val = cell (1,length(list_masks_val));

    for i = 1 : length(list_masks_val)
        masks_file_val = imread(list_masks_val(i).name);
        mask_file_val{i}=logical(masks_file_val);
    end

    cd ('..\new_masks');
    list_masks_new_val=dir('*.bmp');

    for i = 1 : length(list_masks_val)
        masks_file_new_val = imread(list_masks_new_val(i).name);
        mask_file_new_val{i}=logical(masks_file_new_val/255);
    end
    
    %% Inicializamos parámetros necesarios para calcular F-Score, Precision y Recall %%
    True_positives = 0; 
    P_TOTAL =0;
    T_TOTAL = 0;
    
    %% Calculamos los true positives totales asi com los Positives y los True %%
    for k = 1 : length(list_masks_val)
        [li, wi] = size(mask_file_new_val{k});
        for i = 1 : wi
            for j = 1 : li
                %% Si los dos valores de las dos mascaras son iguales, detectamos correctamente %%
                if ((mask_file_new_val{k}(j,i) == 1) && (1-mask_file_val{k}(j,i)==1))  
                    True_positives = True_positives +1; %Tp general
                end 
            end
        end
        %% Positives y True totales de todas las imágenes %% 
        T_TOTAL = T_TOTAL + sum(1-mask_file_val{k}(:));
        P_TOTAL = P_TOTAL + sum(mask_file_new_val{k}(:)); %P general
    end
    
    %% Calculamos parámetros principales y los mostramos por pantalla %%
    Precision_total = 100 *True_positives/P_TOTAL;
    Recall_total = 100 *True_positives/T_TOTAL;
    f_score = 2*Precision_total * Recall_total /(Precision_total + Recall_total);
    fprintf(1, 'Precision:  %d  . Recall: %d-----> F-score: %d \n',Precision_total, Recall_total, f_score );
    
    
end



%%cd('C:\Users\alejandro.amat\Desktop\PIV-main');

cd ('C:\Users\gobbe\OneDrive\Escritorio\Cfis\4a\project_PIV\');
FD = fopen('output.txt');
cd ('.\Images');


list_images=dir('*.jpg');
images = cell(1, length(list_images));
images_b = cell(1, length(list_images));
mask_file = cell (1,length(list_images));



bins = 256;


for i = 1 : length(list_images)
    image_file = imread(list_images(i).name);
    images{i}=image_file;
    %%images_val{i} = images{i};
    %%image_prueba{i}= images{i};
    
    
    
end



cd ('..\Images_val');
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

cd ('..\Masks-Ideal');
list_masks=dir('*.bmp');
total_pixels_piel = 0;
total_pixels_fondo = 0;

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
    
    cb = images{i}(:,:,2);
    cr = images{i}(:,:,3);
    
    cbb = images_b{i}(:,:,2);
    crb = images_b{i}(:,:,3);
   
    
    [l,w,d] = size(images{i});
    
    
    total_pixels_fondo = total_pixels_fondo +  sum(mask_file{i}(:));
    total_pixels_piel = total_pixels_piel + sum(1-mask_file{i}(:));
   
    
    xv = 1:bins+1;
    yv = 1:bins+1;
    
    if(i == 1)
        histcount = histcounts2(cb,cr,xv,yv);
         
        histcount(histcount==max(histcount(:))) = max(histcount(:))-sum(mask_file{i}(:));
        
        histcount_b = histcounts2(cbb,crb,xv,xv);
        histcount_b(histcount_b==max(histcount_b(:))) = max(histcount_b(:))-sum(1-mask_file{i}(:));
        
        
    else
        
        [histcount_aux, Xedges,Yedges, binX, binY] = histcounts2(cb,cr,xv,xv);
        
        histcount_aux(histcount_aux==max(histcount_aux(:))) =max(histcount_aux(:))-sum(mask_file{i}(:));
        
        histcount = histcount + histcount_aux; 
        
       
        
        
     
        histcount_aux = histcounts2(cbb,crb,xv,xv);
        histcount_aux(histcount_aux==max(histcount_aux(:))) = max(histcount_aux(:))- sum(1-mask_file{i}(:));
        histcount_b = histcount_b + histcount_aux;
       
        
        
    end
    
    
end
    
p = 1:bins;
r = 1:bins;
subplot(1,2,1);
histcountPielNormalized = histcount/ total_pixels_piel;
surface(p,r,histcountPielNormalized);
% grid on;
% zlim([0,0.4]);
% grid off;

subplot(1,2,2);
histcountFondoNormalized = histcount_b/total_pixels_fondo;
surface(p,r,histcountFondoNormalized);
% grid on;
% zlim([0,0.004]);
% grid off;

prob_skin = total_pixels_piel / ( total_pixels_piel + total_pixels_fondo);
prob_fondo = total_pixels_fondo / ( total_pixels_piel + total_pixels_fondo);

treshold = 0.0549;
%f_score_max1=0;
%treshold_max1 = 0;

%f_score_max2=0;
%treshold_max2 = 0;
%0.055

%while (treshold<0.065)
True_positives_total = zeros( 1, length(list_validation));
True_positives = 0;
Precision =zeros(1, length(list_validation));
Recall = zeros(1, length(list_validation));

Precision_total =0;
Recall_total = 0;
P_TOTAL =0;
T_TOTAL = 0;






 for k = 1 :  length(list_validation)
     
    imagen_prueba = rgb2ycbcr(images_val{k});
    cb_im = double(imagen_prueba(:,:,2));
    cr_im = double(imagen_prueba(:,:,3));
    [N,Xedges,Yedges,binX,binY] = histcounts2(cb_im,cr_im,xv,yv);
    bin_cb = round(((cb_im - 16)/(240-16)) * bins);
    bin_cr = round(((cr_im - 16)/(240-16)) * bins);
    [li, wi, di] = size(imagen_prueba);
    histcount_validation_Normalized = N/(wi*di);
    mask_image=zeros(li, wi);
    
%for i = 2 : li-1
%     for j = 2 : wi-1
%          pos1 = bin_cb(i,j);
%          pos_y1 = bin_cr(i,j);
%         
%            
%          prob = histcountPielNormalized (pos1, pos_y1);
%          prob_b = histcountFondoNormalized(pos1, pos_y1);
%          
%          prob2 = histcountPielNormalized (pos1-1, pos_y1);
%          prob_b2 = histcountFondoNormalized(pos1-1, pos_y1);
%          prob3 = histcountPielNormalized (pos1+1, pos_y1);
%          prob_b3 = histcountFondoNormalized(pos1+1, pos_y1);
%          prob4 = histcountPielNormalized (pos1, pos_y1 +1);
%          prob_b4 = histcountFondoNormalized(pos1, pos_y1+1);
%          
%          
%          
%          
%          if((prob+prob2+prob3+prob4)*0.5 < (prob_b + prob_b2 + prob_b3+ prob_b4))
%             mask_image(i,j) = 1; 
%          end
%          
%     end

for i = 1 : wi
    for j = 1 : li
        pos_x = binX(j,i);
        pos_y = binY(j,i);
        
       
        
        prob = histcountPielNormalized (pos_x, pos_y);
        prob_b = histcountFondoNormalized(pos_x, pos_y);
      %  prob_val = histcount_validation_Normalized(pos_x, pos_y);
        
        
        
        if(log(prob)-log(prob_b)>= treshold  )  
            mask_image(j,i) = 1;
            
        end
    end
end

    save(fullfile('C:\Users\gobbe\OneDrive\Escritorio\Cfis\4a\project_PIV\new_masks', 'maskImage'), 'mask_image');
    
    
    image_prueba{k}(:,:,1) = image_prueba{k}(:,:,1).*uint8(logical(mask_image));
    image_prueba{k}(:,:,2) = image_prueba{k}(:,:,2).*uint8(logical(mask_image));
    image_prueba{k}(:,:,3) = image_prueba{k}(:,:,3).*uint8(logical(mask_image));

    
    
    for i = 1 : li
        for j = 1 : wi
            if ((mask_image(i,j) == 1) && (1-mask_file_val{k}(i,j)==1))
                True_positives_total(1,k) = True_positives_total(1,k) + 1; %TP para cada imagen
                True_positives = True_positives +1; %Tp general
            end 
        end
    end
    Precision (1,k) = True_positives_total(1,k)/sum(mask_image(:)); % Precision de una sola imagen
    Recall (1,k) = True_positives_total(1,k)/sum(1-mask_file_val{k}(:)); %Recall de una sola imagen
    
    Precision_total = Precision_total + Precision(1,k);
    Recall_total = Recall_total + Recall(1,k);
    
    T_TOTAL = T_TOTAL + sum(1-mask_file_val{k}(:));
    P_TOTAL = P_TOTAL + sum(mask_image(:)); %P general
   
   %imshow(image_prueba{k});
   %K = sprintf('precision in image %d is: %d . Recall: %d ', k,  Precision(1,k), Recall(1,k));
   %disp(K);
    
 end

 Precision_total = Precision_total * 100/ length(list_validation);
 Recall_total = Recall_total * 100/ length(list_validation);
 f_score = 2*Precision_total * Recall_total /(Precision_total + Recall_total);
 fprintf(1,'Forma 1. pepe = %d --> Precision:  %d  . Recall: %d-----> F-score: %d ', treshold,  Precision_total, Recall_total, f_score);
 
 %if(treshold ==0)
  %   treshold_max1 = 0;
   %  f_score_max1 = f_score;
 %else
  %   if(f_score>f_score_max1)
   %      f_score_max1 = f_score;
    %     treshold_max1 = treshold;
     %end  
     %end
 Precision_total = 100 *True_positives/P_TOTAL;
 Recall_total = 100 *True_positives/T_TOTAL;
 f_score = 2*Precision_total * Recall_total /(Precision_total + Recall_total);
 fprintf(1, 'Forma 2. pepe = %d --> Precision:  %d  . Recall: %d-----> F-score: %d \n', treshold,  Precision_total, Recall_total, f_score );
 %if(treshold ==0)
  %   treshold_max2 = 0;
   %  f_score_max2 = f_score;
 %else
  %   if(f_score>f_score_max2)
   %      f_score_max2 = f_score;
    %     treshold_max2 = treshold;
     %end  
% end

 
 


%fprintf(1, 'Max treshold1 : %d , with f_score of %d.   Max treshold2: %d with treshold %d', treshold_max1, f_score_max1, treshold_max2, f_score_max2);
 

%%imshow(images{84});
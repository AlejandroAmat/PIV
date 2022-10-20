cd('C:\Users\alejandro.amat\Desktop\PIV-main\Images');

list_images=dir('*.jpg');
list_images_val= list_images;
images = cell(1, length(list_images));
images_val = cell(1, length(list_images));
images_b = cell(1, length(list_images));
image_prueba = cell(1, length(list_images));





mask_file = cell (1,length(list_images));
bins = 256;

for i = 1 : length(list_images)
    image_file = imread(list_images(i).name);
    images{i}=image_file;
    images_val{i} = images{i};
    image_prueba{i}= images{i};
    
    
    
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
    total_pixels_piel = total_pixels_piel + l*w - sum(mask_file{i}(:));
   
    
    xv = 0:bins;
    yv = 0:bins;
    if(i == 1)
        histcount = histcounts2(cb,cr,xv,yv);
        
        histcount(histcount==max(histcount(:))) =0;
        
        histcount_b = histcounts2(cbb,crb,xv,xv);
        histcount_b(histcount_b==max(histcount_b(:))) =0;
        
        
    else
        histcount_aux = histcounts2(cb,cr,xv,xv);
        histcount_aux(histcount_aux==max(histcount_aux(:))) =0;
        histcount = histcount + histcount_aux; 
       
        
     
        histcount_aux = histcounts2(cbb,crb,xv,xv);
        histcount_aux(histcount_aux==max(histcount_aux(:))) =0;
        histcount_b = histcount_b + histcount_aux;
       
        
        
    end
    
    
end
    
p = 1:bins;
r = 1:bins;
subplot(1,2,1);
histcountPielNormalized = histcount/total_pixels_piel;
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
precision = zeros( 1, 101);
papa = 0;

images_hists = ones(bins, bins);

for m = 1 : bins
    for h = 1 : bins
        if(histcountFondoNormalized(m,h)>= histcountPielNormalized(m,h))
            images_hists(m,h) = 0;
        end
    end
end

surface(p,r,images_hists);
grid on;
zlim([0,2]);
grid off;



 for k = 1 : 101  
     
    imagen_prueba = rgb2ycbcr(images_val{k});
    imshow(imagen_prueba);
    cb_im = double(imagen_prueba(:,:,2));
    cr_im = double(imagen_prueba(:,:,3));
    bin_cb = round(((cb_im - 16)/(240-16)) * bins);
    bin_cr = round(((cr_im - 16)/(240-16)) * bins);
    [li, wi, di] = size(imagen_prueba);
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

for i = 1 : li
    for j = 1 : wi
        pos_x = bin_cb(i,j);
        pos_y = bin_cr(i,j);
        
        prob = histcountPielNormalized (pos_x, pos_y);
        prob_b = histcountFondoNormalized(pos_x, pos_y);
        
        if(prob > prob_b)
            mask_image(i,j) = 1;
            
        end
    end
end

    
    image_prueba{k}(:,:,1) = image_prueba{k}(:,:,1).*uint8(logical(mask_image));
    image_prueba{k}(:,:,2) = image_prueba{k}(:,:,2).*uint8(logical(mask_image));
    image_prueba{k}(:,:,3) = image_prueba{k}(:,:,3).*uint8(logical(mask_image));

    
    
    for i = 1 : li
        for j = 1 : wi
            if (mask_image(i,j) == 1-mask_file{k}(i,j))
                precision(1,k) = precision(1,k) + 1;
            end 
        end
    end
   precision(1,k) = precision(1,k) /(li*wi);
   papa = papa + precision(1,k);
   imshow(image_prueba{k});
   D = sprintf('precision in image %d is: %d% ', k, 100 * precision(1,k));
   disp(D);
    
 end

disp (papa);

%%imshow(images{84});





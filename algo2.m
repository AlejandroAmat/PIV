    
function [mask_image] = algo2(im, treshold,xv,yv,histcountPielNormalized, histcountFondoNormalized)
    
    imagen_prueba = rgb2ycbcr(im);
    cb_im = double(imagen_prueba(:,:,2));
    cr_im = double(imagen_prueba(:,:,3));
    [N,Xedges,Yedges,binX,binY] = histcounts2(cb_im,cr_im,xv,yv);
    [li, wi, di] = size(imagen_prueba);
    mask_image=zeros(li, wi);
    r_o =4;
    r_a = 5;
    
    for i = 1 : wi
        for j = 1 : li
            pos_x = binX(j,i);
            pos_y = binY(j,i);
        
            prob = histcountPielNormalized (pos_x, pos_y);
            prob_b = histcountFondoNormalized(pos_x, pos_y);
      
            if(log(prob)-log(prob_b)>= treshold  )  
                mask_image(j,i) = 1;
            end
        end
    end
    
    SE = strel('disk',r_o);
    SE2 = strel ('disk', r_a);
    mask_image = imclose(mask_image, SE);
    mask_image = imopen(mask_image, SE2);

end
   
   
    
    
    
    
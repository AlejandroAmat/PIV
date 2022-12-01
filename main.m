
cd('C:\Users\alejandro.amat\Documents\MATLAB');
cd ('.\Masks-Ideal');


list_images=dir('*.bmp');
images = cell(1, length(list_images));

for k = 1 : length(list_images)
    
    image_file = imread(list_images(k).name);
    images{k}=1-image_file;  
    imshow(image_file);
    
    
    
    
    D = bwdist(image_file);
    
    [A,B] = size(D);
    
    for i = 1 : A
        for j = 1 : B
            if(D(i,j)<14)
               D(i,j) =1; 
            else
                D(i,j) =1;
            end    
        end
    end
    
    
    SE = strel('disk', 10);
    D = imopen (D, SE);
    
    imshow(image_file-D,[]);
end
%% regionprops%%



    
    
 

 


 

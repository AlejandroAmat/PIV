
function [histCountPiel, histCountFondo,xv,yv] = algo1()

    cd('C:\Users\gobbe\OneDrive\Escritorio\Cfis\4a\project_PIV');
    cd ('.\Images');

    list_images=dir('*.jpg');
    images = cell(1, length(list_images));
    images_b = cell(1, length(list_images));
    mask_file = cell (1,length(list_images));
    bins = 256;

    for i = 1 : length(list_images)
        image_file = imread(list_images(i).name);
        images{i}=image_file;
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

    histCountPiel = histcount/total_pixels_piel;
    histCountFondo = histcount_b/total_pixels_fondo;

    end
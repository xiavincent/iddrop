% Batch process a cell array of images and display the segmented film area
function processImages(start_index,finish_index,images,area_mask)
   
    len = finish_index - start_index + 1; % length of output cell array
    overlay = cell([1 len]); % store the final images
    
    ticBytes(gcp) % report byte transfer of process
    parfor i=start_index:finish_index
        RGB = images{i}.frame;
        gray = rgb2gray(RGB);
        film_mask = findFilm(gray,area_mask); % return a mask of the wet film
        film_mask(~area_mask) = 0;
        overlay{i} = labeloverlay(RGB,film_mask); % burn binary mask into original image
    end
    tocBytes(gcp)
    
    for i=start_index:finish_index % display all the images
        fig = figure;
        ax = axes(fig);
        imshow(overlay{i},'parent',ax);
        title(sprintf('Wet film overlay: image %d',images{i}.num));
    end
    
end
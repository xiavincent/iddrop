%% FUNCTION
% Batch process a cell array of images and display the segmented film area
function processImages(start_index,finish_index,images,area_mask,camera_mask)
    len = finish_index - start_index + 1; % length of output cell array
    overlay = cell([1 len]); % store the final images
    
%     ticBytes(gcp) % report byte transfer of process
    for (i=start_index:finish_index) % parallel 'for' loop for increased processing speed
        RGB = images{i}.frame;
        overlay{i} = getFilmOverlay(RGB,area_mask,camera_mask);
    end
%     tocBytes(gcp)
    
%     for i=start_index:finish_index % display all the images
%         fig = figure;
%         ax = axes(fig);
%         imshow(overlay{i},'parent',ax);
%         title(sprintf('Wet film overlay: image %d',images{i}.num));
%     end
end

%% PRIVATE HELPER FUNCTIONS
% Get an overlay of the film for an RGB image
function overlay = getFilmOverlay(RGB_img,area_mask,camera_mask)    
    gray = rgb2gray(RGB_img);
    gray = rmShadow(gray,camera_mask); % remove the camera shadow with inward interpolation
    
    film_mask = findFilm(gray,area_mask); % return a mask of the wet film
    film_mask(~area_mask) = 0;
    overlay = labeloverlay(RGB_img,film_mask); % burn binary mask into original image
end

% remove camera shadow using gray scale interpolation 
function output = rmShadow(grayscale_img,camera_mask) 
    output = regionfill(grayscale_img,camera_mask); % fill in the camera shadow with interpolation
end




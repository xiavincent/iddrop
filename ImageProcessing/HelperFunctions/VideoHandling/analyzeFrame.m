% Analyze a single frame and return the wetted proportion
function [wet_frac,overlay_img] = analyzeFrame(input_vid, frame_num, analys)
    orig_frame = read(input_vid,frame_num); % reading individual frames from input video
    crop = imcrop(orig_frame,analys.crop_rect); 
    
    [film_mask,overlay_img] = getFilmOverlay(crop,analys.area_mask); % get wet film mask
    
    film_area = nnz(film_mask);
    wet_frac = film_area/analys.max_area;
end


%% PRIVATE HELPER FUNCTIONS

% Get an overlay of the film for an RGB image
function [film_mask,overlay] = getFilmOverlay(RGB_img,area_mask)    
    film_mask = findFilm(RGB_img,area_mask); % return a mask of the wet film
    overlay = labeloverlay(RGB_img,film_mask); % burn binary mask into original image
end



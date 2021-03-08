% Analyze a single frame and return the wetted proportion
function [wet_frac,overlay_img] = analyzeFrame(input_vid,analys,fnum,params)
    cam_mask = analys.cam_mask; % redefine parameters
    area_mask = analys.area_mask; 
    max_area = analys.max_area;
    area_fnum = params.area;
    seed_rc = analys.seed;

    orig_frame = read(input_vid,fnum); % read individual frames from input video
    crop = imcrop(orig_frame,analys.crop_rect); 
    
    [overlay_img,wet_frac] = getFilmOverlay(crop,area_mask,cam_mask,max_area,fnum,area_fnum,seed_rc); % get wet film mask from area frame
    
    
%     if (frame_num > start_fnum) % if we want to begin analyzing the video

%     else
%         wet_frac = 1;   
%         overlay_img = crop; % make a copy of the original frame for video output
%     end
end


%% PRIVATE HELPER FUNCTIONS

% Get an overlay of the film for an RGB image
function [overlay,wet_frac] = getFilmOverlay(RGB_img,area_mask,cam_mask,max_area,fnum,area_fnum,seed_rc)  
    film_mask = findFilm(RGB_img,area_mask,cam_mask,seed_rc); % return a mask of the wet film
    [film_mask, wet_frac] = checkArea(film_mask,max_area,fnum,area_fnum);
   
    overlay = labeloverlay(RGB_img,film_mask); % burn binary mask into original image
end

% reset the area if it has substantially dewetted before the area setting frame
function [film_mask, wet_frac] = checkArea(film_mask,max_area,cur_fnum,area_fnum)
    film_area = nnz(film_mask);
    wet_frac = film_area/max_area;

%     dewet_thresh = .8; % threshold for abnormal area fraction
%     if ((wet_frac < dewet_thresh) && (cur_fnum < area_fnum)) % if the video dewetted abnormally quickly
%         wet_frac = 1; % reset the area fraction
%         film_mask = zeros(size(film_mask)); % reset the mask
%     end
end


% Analyze a single frame 
% return the fraction of wet area 
function wet_area = analyzeFrame(input_vid, cur_frame_num, analys, params, outputs, output_vids)

    orig_frame = read(input_vid,cur_frame_num); % reading individual frames from input video
    crop_frame = imcrop(orig_frame,analys.crop_rect); 
    gray_frame = rgb2gray(crop_frame); % grayscale frame from video
    subtract_frame = gray_frame - analys.bg_gray; % Subtract background frame from current frame
    
    %% MIGRATED ON APR 16 FROM WORKING HSV VERSION
   if (cur_frame_num > params.t0) %adjust this depending on how much noise your analysis picks up at the beginning. starting this later will lead to less noise
        subtract_frame(analys.shadow) = 0; %clear every subtract_frame pixel inside the camera shadow
        subtract_frame(~analys.area_mask) = 0; %apply area mask
        binarize_mask=imbinarize(subtract_frame);
    else
        bw_frame=imbinarize(subtract_frame); % "Blanket" method to suppress noise before area frame
        binarize_mask = bw_frame.*analys.area_mask; % Add mask of overall circle specified from UI input
    end
     
    binarize_mask_clean = bwareaopen(binarize_mask, params.rm_pix); % remove connected objects that are smaller than 250 pixels in size
    binarize_mask_clean = ~bwareaopen(~binarize_mask_clean, params.rm_pix); % remove holes that are smaller than 20 pixels in size
    
    hsv_frame=rgb2hsv(crop_frame); % convert to hsv image
    hsv_frame(analys.shadow) = 0; % apply camera mask
    hsv_frame(~analys.area_mask) = 0; % apply area mask
    
    % Apply each color band's particular thresholds to the color band
	hueMask = (hsv_frame(:,:,1) >= params.H_low) & (hsv_frame(:,:,1) <= params.H_high); %makes mask of the hue image within theshold values
	saturationMask = (hsv_frame(:,:,2) >= params.S_low) & (hsv_frame(:,:,2) <= params.S_high); %makes mask of the saturation image within theshold values
	valueMask = (hsv_frame(:,:,3) >= params.V_low) & (hsv_frame(:,:,3) <= params.V_high); %makes mask of the value image within theshold values
    
    HSV_mask = hueMask & saturationMask & valueMask; % defines area that fits within hue mask, saturation mask, and value mask    
    
    % Fill in the holes of the mask 
	HSV_mask_rmv_maskHoles = ~bwareaopen(~HSV_mask, params.rm_pix);
    
    % Filter out small objects.
    HSV_mask_rmv_obj = bwareaopen(HSV_mask_rmv_maskHoles, params.rm_pix); %fill in holes smaller than 250 pixels in size
    
    % apply binarization mask
    combined_mask = HSV_mask_rmv_obj & binarize_mask_clean;
 
    % Clean the image and count the area
    [final_mask,wet_area] = countArea(combined_mask,analys.film_radius,gray_frame,analys.film_center);      

    % Write final videos          
    writeOutputVids(gray_frame, crop_frame, orig_frame, HSV_mask, binarize_mask, final_mask,...
                          params.t0, cur_frame_num, wet_area,...
                          input_vid.FrameRate, outputs, output_vids);
                      
                      

end


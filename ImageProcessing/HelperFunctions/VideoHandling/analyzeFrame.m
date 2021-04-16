% Analyze a single frame 
% return the fraction of wet area 
function wet_area = analyzeFrame(input_vid, cur_frame_num, analys, params, outputs, output_vids)

    orig_frame = read(input_vid,cur_frame_num); % reading individual frames from input video
    crop_frame = imcrop(orig_frame,analys.crop_rect); 
    gray_frame = rgb2gray(crop_frame); % grayscale frame from video
    subtract_frame = gray_frame - analys.bg_gray; % Subtract background frame from current frame
    
    %% MIGRATED ON APR 16 FROM WORKING HSV VERSION
   if (cur_frame_num > params.t0) %adjust this depending on how much noise your analysis picks up at the beginning. starting this later will lead to less noise
        subtract_frame(shadowMask) = 0; %clear every subtract_frame pixel inside the shadowMask | applies the camera mask
        subtract_frame(~mask) = 0; %apply area mask
        bw_frame_mask=imbinarize(subtract_frame);
    else
        bw_frame=imbinarize(subtract_frame); % "Blanket" method to suppress noise before area frame
        bw_frame_mask = bw_frame.*mask; % Add mask of overall circle specified from UI input
    end
     
    bw_frame_mask_clean = bwareaopen(bw_frame_mask, remove_Pixels); % remove connected objects that are smaller than 250 pixels in size
    bw_frame_mask_clean = ~bwareaopen(~bw_frame_mask_clean, remove_Pixels); % remove holes that are smaller than 20 pixels in size
    
    hsv_frame=rgb2hsv(crop_frame); % convert to hsv image
    hsv_frame(shadowMask) = 0; % apply camera mask
    hsv_frame(~mask) = 0; % apply area mask
    
    % Apply each color band's particular thresholds to the color band
	hueMask = (hsv_frame(:,:,1) >= hueThresholdLow) & (hsv_frame(:,:,1) <= hueThresholdHigh); %makes mask of the hue image within theshold values
	saturationMask = (hsv_frame(:,:,2) >= saturationThresholdLow) & (hsv_frame(:,:,2) <= saturationThresholdHigh); %makes mask of the saturation image within theshold values
	valueMask = (hsv_frame(:,:,3) >= valueThresholdLow) & (hsv_frame(:,:,3) <= valueThresholdHigh); %makes mask of the value image within theshold values
    
    HSV_mask = hueMask & saturationMask & valueMask; % defines area that fits within hue mask, saturation mask, and value mask    
    
    % Fill in the holes of the mask 
	HSV_mask_rmv_maskHoles = ~bwareaopen(~HSV_mask, remove_Pixels);
    
    % Filter out small objects.
    HSV_mask_rmv_obj = bwareaopen(HSV_mask_rmv_maskHoles, remove_Pixels); %fill in holes smaller than 250 pixels in size
    
    % apply binarization mask
    HSV_bw_mask = HSV_mask_rmv_obj & bw_frame_mask_clean;

 
    [finalMask,grain_areas(i)] = countArea(HSV_bw_mask,totalAreaRadius,gray_frame,totalAreaCenter);      
    
    % Clean the image and count the area
    [label_dewet_img, wet_area] = countArea(combined_mask_fill, analys.outer_region, analys.film_area, size(gray_frame));       

    % Write final videos          
    writeOutputVids(gray_frame, crop_frame, orig_frame, HSV_mask, binarize_mask, label_dewet_img,...
                          params.t0, cur_frame_num, wet_area,...
                          input_vid.FrameRate, outputs, output_vids);

end
% Analyze a single frame 
% return the fraction of wet area 
function wet_area = analyzeFrame(input_vid, cur_frame_num, analys, params, outputs, output_vids)

    orig_frame = read(input_vid,cur_frame_num); % reading individual frames from input video
    crop = imcrop(orig_frame,analys.crop_rect); 
    gray = rgb2gray(crop); % grayscale frame from video
    cam = getShadow(gray); % extract mask of camera shadow
    gray = regionfill(gray,cam); % fill in the camera shadow 
    
    
    %% Option 1 (BEST)
    clr_brdr = imclearborder(gray); % remove the image border and leave us with the dome only
    binarize_mask = imbinarize(clr_brdr,'global');
    
    % TODO: filter out camera and fill in with color of surrounding pixels (try regionfill)
    

%%
    binarize_mask_reduced = binarize_mask;
    binarize_mask_reduced(~analys.area_mask) = 0; % apply the area mask to get an accurate count of the area
    
    if(nnz(binarize_mask_reduced) > analys.film_area + 1000) % if the binarization fails to split image
        binarize_mask = zeros(size(binarize_mask)); % don't try to analyze the frame for dewetted area
    end

    % Apply each color band's particular thresholds to the color band
    hsv_frame = rgb2hsv(crop); % convert to hsv image
    
	hueMask = (hsv_frame(:,:,1) >= params.H_low) & (hsv_frame(:,:,1) <= params.H_high); %makes mask of the hue image within theshold values
	saturationMask = (hsv_frame(:,:,2) >= params.S_low) & (hsv_frame(:,:,2) <= params.S_high); %makes mask of the saturation image within theshold values
	valueMask = (hsv_frame(:,:,3) >= params.V_low) & (hsv_frame(:,:,3) <= params.V_high); %makes mask of the value image within theshold values   
    HSV_mask = hueMask & saturationMask & valueMask; % defines area that fits within hue mask, saturation mask, and value mask 

    combined_mask = HSV_mask & binarize_mask;    
    combined_mask(~analys.area_mask) = 0; % apply area mask
    combined_mask_open = bwareaopen(combined_mask, params.rm_pix);
    combined_mask_fill = ~bwareaopen(~combined_mask_open, 20); % fill in small holes of the binarized mask
    
    % Clean the image and count the area
    [label_dewet_img, wet_area] = countArea(combined_mask_fill, analys.outer_region, analys.film_area, size(gray));       

    % Write final videos          
    writeOutputVids(gray, crop, orig_frame, HSV_mask, binarize_mask, label_dewet_img,...
                          params.t0, cur_frame_num, wet_area,...
                          input_vid.FrameRate, outputs, output_vids);

end





function shadow = getShadow(gray_img) % return binary mask of camera shadow (defined as intensity values below 100)

    thresh = 100;
    shadow = gray_img < thresh; % extract intensity values less than 100 to get camera shadow
    
    structuring_elem = strel('disk',10); 
    shadow = imdilate(shadow,structuring_elem); % expand the shadow area
    
end
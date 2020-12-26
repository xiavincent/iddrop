% Analyze a single frame and return the wetted proportion
function wet_area = analyzeFrame(input_vid, cur_frame_num, analys, params, outputs, output_vids)

    orig_frame = read(input_vid,cur_frame_num); % reading individual frames from input video
    crop = imcrop(orig_frame,analys.crop_rect); 
    gray = rgb2gray(crop); % grayscale frame from video
    cam = getShadow(gray); % extract mask of camera shadow
    gray = regionfill(gray,cam); % fill in the camera shadow with interpolation
    
    bin = binarizeImg(gray,analys); % get a binarized mask
    HSV = getHSVmask(crop,params); % get an HSV mask
    combined_mask = combineMasks(HSV,bin,analys,params); % combine the masks and clean the image
    
    [label_dewet_img, wet_area] = countArea(combined_mask, analys.outer_region, analys.film_area, size(gray)); % Remove invalid objects and count the area

    % Write final videos
    writeOutputVids(gray, crop, orig_frame, HSV, bin, label_dewet_img,...
                          params.t0, cur_frame_num, wet_area,...
                          input_vid.FrameRate, outputs, output_vids);

end

%% Helper functions

% return a binarized version of a grayscale image, checking to make sure the film is within the
    % maximum allowable area
function binarize_mask = binarizeImg(gray_img, analys) 
    clr_brdr = imclearborder(gray_img); % remove the image border and leave us with the dome only
    binarize_mask = imbinarize(clr_brdr,'global');
    
    binarize_mask_reduced = binarize_mask;
    binarize_mask_reduced(~analys.area_mask) = 0; % apply the area mask to get an accurate count of the area
    
    if (checkAllowableArea(binarize_mask_reduced,analys.film_area)) % if the area is too large
         binarize_mask = zeros(size(binarize_mask)); % don't try to analyze the frame for dewetted area
                                                        % black out the whole mask
    end
end

function ret = checkAllowableArea(mask,max_film_area)
    ret = 0; % return value
    max_area = max_film_area + 1000; % maximum allowable area for the mask
    if(nnz(mask) > max_area) % if the binarization fails to split image
        ret = 1;
    end
end

% return an HSV mask of an RGB image based on parameter thresholds
function HSV_mask = getHSVmask(RGB_img, params)
    % Apply each color band's particular thresholds to the color band
    
    hsv = rgb2hsv(RGB_img); % convert to hsv image
    
	hueMask = (hsv(:,:,1) >= params.H_low) & (hsv(:,:,1) <= params.H_high); %makes mask of the hue image within theshold values
	saturationMask = (hsv(:,:,2) >= params.S_low) & (hsv(:,:,2) <= params.S_high); %makes mask of the saturation image within theshold values
	valueMask = (hsv(:,:,3) >= params.V_low) & (hsv(:,:,3) <= params.V_high); %makes mask of the value image within theshold values   
    HSV_mask = hueMask & saturationMask & valueMask; % defines area that fits within hue mask, saturation mask, and value mask 

end



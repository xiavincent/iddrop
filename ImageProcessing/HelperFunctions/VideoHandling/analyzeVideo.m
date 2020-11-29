% Analyze the video and return a vector containing the wet area
%% Inputs
% analys: struct containing key analysis masks and area values
% params: struct containing user-specified video processing information
% output: struct containing video output information
%% Outputs
% wet_area: vector of fraction of wet area for each analyzed frame
% final_frame_num: the frame of the video we stopped analyzing at

%% Function
function [wet_area,final_frame_num] = analyzeVideo(file_name_short,vid,analys,params,output)

    % Define output video parameters; open videos for writing
    output_framerate = 20; %output frame rate
    
    output_vids = struct('bw',0,'analyzed',0,'masks',0,'falsecolor',0); % store initialized videos

    [output_vids.bw, output_vids.analyzed, output_vids.masks, output_vids.falsecolor] = ...
        initVids(file_name_short, output_framerate, output.bw_mask , output.analyzed, output.masks, output.falsecolor);
    
    
    wait_bar = waitbar(0,'Analyzing... Go grab a cup of coffee...'); % start video processing
    num_it = floor(vid.NumFrames/params.skip); % number of times we need to iterate through the analysis loop to get through every frame in the video
    wet_area = zeros(1,num_it * params.skip); % normalized wet area for every frame index

    
    initial_frame_num = params.t0; %params.t0 %5176
    final_frame_num = vid.NumFrames; % dictates the last frame of the video to be analyzed
    
    % TODO: fix iteration parameters
        %     max_it = floor((final_frame_num - t0_frame_num) / params.skip); % maximum iteration we want to hit
        %     for i = 1 : max_it
        %     for cur_frame_num = params.t0 : params.skip : final_frame_num % set raw video time 
        %         cur_frame_num = i * params.skip + t0_frame_num; 

    for cur_frame_num = initial_frame_num : params.skip : final_frame_num % set raw video time 
        waitbar(cur_frame_num/final_frame_num,wait_bar); % update wait bar to show analysis progress
        wet_area(cur_frame_num) = analyzeFrame(vid, cur_frame_num, analys, params, output, output_vids); % run the analysis loop for a single frame
    end
    
    closeVids(output.bw_mask, output_vids.bw,...
              output.analyzed, output_vids.analyzed,...
              output.masks, output_vids.masks,...
              output.falsecolor, output_vids.falsecolor);
          
    close(wait_bar); % closes wait bar

end


% Analyze a single frame 
% return the fraction of wet area 
function wet_area = analyzeFrame(input_vid, cur_frame_num, analys, params, output, output_vids)

    orig_frame = read(input_vid,cur_frame_num); % reading individual frames from input video
    crop_frame = imcrop(orig_frame,analys.crop_rect); 
    gray_frame = rgb2gray(crop_frame); % grayscale frame from video
    gray_frame_rm_shadow = imfill(gray_frame); % imfill works best with global thresholding 
                                               % Do NOT use imfill if using adaptive thresholding
%     binarize_mask = imbinarize(gray_frame_rm_shadow,'adaptive'); % split gray_frame into 1's and 0's
%     binarize_mask = imbinarize(gray_frame_rm_shadow,'adaptive','ForegroundPolarity','bright','Sensitivity',0.62);
    binarize_mask = imbinarize(gray_frame,'adaptive','ForegroundPolarity','bright','Sensitivity',0.62); % ignore the camera shadow for now

    binarize_mask_reduced = binarize_mask;
    binarize_mask_reduced(~analys.area_mask) = 0; % apply the area mask to get an accurate count of the area
    
    if(nnz(binarize_mask_reduced) > analys.film_area + 1000) % if the binarization fails to split image
        binarize_mask = zeros(size(binarize_mask)); % don't try to analyze the frame for dewetted area
    else 
        stop = 0;
    end

    % Apply each color band's particular thresholds to the color band
    hsv_frame = rgb2hsv(crop_frame); % convert to hsv image
    
	hueMask = (hsv_frame(:,:,1) >= params.H_low) & (hsv_frame(:,:,1) <= params.H_high); %makes mask of the hue image within theshold values
	saturationMask = (hsv_frame(:,:,2) >= params.S_low) & (hsv_frame(:,:,2) <= params.S_high); %makes mask of the saturation image within theshold values
	valueMask = (hsv_frame(:,:,3) >= params.V_low) & (hsv_frame(:,:,3) <= params.V_high); %makes mask of the value image within theshold values   
    HSV_mask = hueMask & saturationMask & valueMask; % defines area that fits within hue mask, saturation mask, and value mask 

    combined_mask = HSV_mask & binarize_mask;    
    combined_mask(~analys.area_mask) = 0; % apply area mask
    combined_mask_open = bwareaopen(combined_mask, params.rm_pix);
%     combined_mask_fill = ~bwareaopen(~combined_mask_open, 20); % fill in small holes of the binarized mask
    
    % Clean the image and count the area
    [label_dewet_img, wet_area] = countArea(combined_mask_open, analys.outer_region, analys.film_area, size(gray_frame));       

    % Write final videos          
    writeOutputVids(gray_frame, crop_frame, orig_frame, HSV_mask, binarize_mask, label_dewet_img,...
                          params.t0, cur_frame_num, wet_area,...
                          input_vid.FrameRate, output, output_vids);








%         orig_frame = read(input_vid,cur_frame_num); % read frame from input video
%         crop_frame = imcrop(orig_frame,analys.crop_rect); 
%         gray_frame = rgb2gray(crop_frame); % grayscale frame from video
%         rm_shadow = imfill(gray_frame); % remove the camera shadow
%    
%         bw_frame_mask = imbinarize(rm_shadow); % split grayscale image into binary image
% 
%         % HSV Masking. Apply each color band's thresholds
%         hsv_frame = rgb2hsv(crop_frame); % convert to hsv image
% 
%         hue_mask = (hsv_frame(:,:,1) >= params.H_low) & (hsv_frame(:,:,1) <= params.H_high); % mask of the hue image within theshold values
%         sat_mask = (hsv_frame(:,:,2) >= params.S_low) & (hsv_frame(:,:,2) <= params.S_high); % mask of the saturation image within theshold values
%         val_mask = (hsv_frame(:,:,3) >= params.V_low) & (hsv_frame(:,:,3) <= params.V_high); % mask of the value image within theshold values
%         HSV_mask = hue_mask & sat_mask & val_mask; % defines intersection area of hue, saturation, and value masks
% 
%         combined_mask = HSV_mask & bw_frame_mask; % apply binarization mask
% %         combined_mask(analys.shadow) = 0; % apply camera mask
%         combined_mask(~analys.area_mask) = 0; % apply area mask
%         combined_mask_open = bwareaopen(combined_mask, params.rm_pix); % remove small components
% 

end

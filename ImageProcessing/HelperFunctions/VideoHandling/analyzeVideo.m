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
    [bw_vid, analyzed_frames_vid, all_masks_vid, false_color_vid] = initVids(file_name_short, output_framerate, output.bw_mask , output.analyzed , output.masks , output.falsecolor);

    % Begin video processing
    wait_bar = waitbar(0,'Analyzing... Go grab a cup of coffee...');
    num_it = floor(vid.NumFrames/params.skip); % number of times we need to iterate through the analysis loop to get through every frame in the video

    wet_area = zeros(1,num_it * params.skip); % stores normalized wet area for every frame index

    final_frame_num = 3000; % dictates the last frame of the video to be analyzed
    
    % TODO: fix iteration parameters
        %     max_it = floor((final_frame_num - t0_frame_num) / params.skip); % maximum iteration we want to hit
        %     for i = 1 : max_it
        %     for cur_frame_num = params.t0 : params.skip : final_frame_num % set raw video time 
        %         cur_frame_num = i * params.skip + t0_frame_num; 

    for cur_frame_num = params.t0 : params.skip : final_frame_num % set raw video time 
        waitbar(cur_frame_num/final_frame_num,wait_bar); % update wait bar to show analysis progress
        wet_area(cur_frame_num) = analyzeFrame(vid, cur_frame_num, analys, params, output); % run the analysis loop for a single frame
    end
    
    closeVids(output.bw_mask, bw_vid, output.analyzed, analyzed_frames_vid, output.masks, all_masks_vid, output.falsecolor, false_color_vid);
    close(wait_bar); %closes wait bar

end


% analyze a single frame 
% return its fraction of wet area
function wet_area = analyzeFrame(vid, cur_frame_num, analys, params, output)

        orig_frame = read(vid,cur_frame_num); % read frame from input video
        crop_frame = imcrop(orig_frame,analys.crop_rect); 
        gray_frame = rgb2gray(crop_frame); % grayscale frame from video

        % Binarization of frame
        subtract_frame = gray_frame - analys.bg_cropped; % Subtract background frame from current frame
        subtract_frame(analys.shadow) = 0; % apply the camera mask
        subtract_frame(~analys.area_mask) = 0; % apply area mask
        bw_frame_mask=imbinarize(subtract_frame);

        % HSV Masking. Apply each color band's thresholds
        hsv_frame = rgb2hsv(crop_frame); % convert to hsv image

        hue_mask = (hsv_frame(:,:,1) >= params.H_low) & (hsv_frame(:,:,1) <= params.H_high); %makes mask of the hue image within theshold values
        sat_mask = (hsv_frame(:,:,2) >= params.S_low) & (hsv_frame(:,:,2) <= params.S_high); %makes mask of the saturation image within theshold values
        val_mask = (hsv_frame(:,:,3) >= params.V_low) & (hsv_frame(:,:,3) <= params.V_high); %makes mask of the value image within theshold values
        HSV_mask = hue_mask & sat_mask & val_mask; % defines area that fits within hue mask, saturation mask, and value mask    

        combined_mask = HSV_mask & bw_frame_mask; % apply binarization mask
        combined_mask(analys.shadow) = 0; % apply camera mask
        combined_mask(~analys.area_mask) = 0; % apply area mask
        combined_mask_open = bwareaopen(combined_mask, params.rm_pix); % remove small components

        % Clean the image and count the area
        [label_dewet_img, wet_area(cur_frame_num)] = countArea(combined_mask_open, analys.outer_region, analys.film_area, size(gray_frame));       

        % Write final videos          
        writeOutputVids(gray_frame,crop_frame,orig_frame,HSV_mask,bw_frame_mask,label_dewet_img,...
                              bw_vid,false_color_vid,analyzed_frames_vid,all_masks_vid,...
                              wet_area,...
                              params.t0,cur_frame_num,...
                              vid.FrameRate, output);

end

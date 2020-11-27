% Analyze the video and return a vector containing the wet area

function [wet_area,final_frame_num] = analyzeVideo(file_name_short, output_black_white_mask, output_analyzed_frames, output_all_masks, output_falsecolor,...
                                                    area_mask, outer_region, max_area, shadow_mask, camera_area,...
                                                    crop_rect, vid, bg_cropped,...
                                                    rm_pix, t0_frame_num, skip_frame,...
                                                    H_thresh_low, H_thresh_high, ...
                                                    S_thresh_low, S_thresh_high, ...
                                                    V_thresh_low, V_thresh_high)


    % Define output video parameters; open videos for writing
    output_framerate = 20; %output frame rate
    [bw_vid, analyzed_frames_vid, all_masks_vid, false_color_vid] = initVids(file_name_short, output_framerate, output_black_white_mask, output_analyzed_frames, output_all_masks, output_falsecolor);

    % Begin video processing
    wait_bar = waitbar(0,'Analyzing... Go grab a cup of coffee...');
    num_it = floor(vid.NumFrames/skip_frame); % number of times we need to iterate through the analysis loop to get through every frame in the video

    dewet_area = zeros(1,num_it*skip_frame); % stores the area for every frame index (formerly called 'grain_areas')
    wet_area = zeros(size(dewet_area)); % stores normalized wet area for every frame index

    final_frame_num = 3000; % dictates the last frame of the video to be analyzed
%     max_it = floor((final_frame_num - t0_frame_num)/skip_frame); % maximum iteration we want to hit
%     for i = 1 : max_it
    for cur_frame_num = t0_frame_num:skip_frame:final_frame_num % set raw video time 
%         cur_frame_num = i*skip_frame + t0_frame_num; 
        waitbar(cur_frame_num/final_frame_num,wait_bar); % update wait bar to show analysis progress

        orig_frame = read(vid,cur_frame_num); % reading individual frames from input video
        crop_frame = imcrop(orig_frame,crop_rect); 
        gray_frame = rgb2gray(crop_frame); % grayscale frame from video
        subtract_frame = gray_frame - bg_cropped; % Subtract background frame from current frame

        % Binarization of frame
        subtract_frame(shadow_mask) = 0; % apply the camera mask
        subtract_frame(~area_mask) = 0; % apply area mask
        bw_frame_mask=imbinarize(subtract_frame);

        % HSV Masking. Apply each color band's thresholds
        hsv_frame = rgb2hsv(crop_frame); % convert to hsv image

        hue_mask = (hsv_frame(:,:,1) >= H_thresh_low) & (hsv_frame(:,:,1) <= H_thresh_high); %makes mask of the hue image within theshold values
        sat_mask = (hsv_frame(:,:,2) >= S_thresh_low) & (hsv_frame(:,:,2) <= S_thresh_high); %makes mask of the saturation image within theshold values
        val_mask = (hsv_frame(:,:,3) >= V_thresh_low) & (hsv_frame(:,:,3) <= V_thresh_high); %makes mask of the value image within theshold values
        HSV_mask = hue_mask & sat_mask & val_mask; % defines area that fits within hue mask, saturation mask, and value mask    

        combined_mask = HSV_mask & bw_frame_mask; % apply binarization mask
        combined_mask(shadow_mask) = 0; % apply camera mask
        combined_mask(~area_mask) = 0; % apply area mask
        combined_mask_open = bwareaopen(combined_mask, rm_pix); % remove small components

        % Count Area; use *Edge Algorithm 2* to throw away inside regions
        [label_dewet_img, dewet_area(cur_frame_num)] = countArea(combined_mask_open,outer_region,size(gray_frame));       

        % Write final videos          
        wet_area(cur_frame_num) = writeOutputVids(output_falsecolor,output_analyzed_frames,output_all_masks,output_black_white_mask,...
                                                  gray_frame,crop_frame,orig_frame,HSV_mask,bw_frame_mask,label_dewet_img,...
                                                  bw_vid,false_color_vid,analyzed_frames_vid,all_masks_vid,...
                                                  dewet_area(cur_frame_num),...
                                                  t0_frame_num,cur_frame_num,...
                                                  max_area,camera_area,...
                                                  vid.FrameRate);


    end


    closeVids(output_black_white_mask, bw_vid, output_analyzed_frames, analyzed_frames_vid, output_all_masks, all_masks_vid, output_falsecolor, false_color_vid);
    close(wait_bar); %closes wait bar

end

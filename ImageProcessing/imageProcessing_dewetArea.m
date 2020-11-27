%% IMAGE PROCESSING OF DEWETTING FROM i-DDrOP VIDEO 
% Takes a ".avi" video file, creates a plot of normalized area vs time. Saves 
% an "_Area.txt" file that stores the analyzed data and can be passed into the 
% "dataprocessing" file for further processing and analysis.

% NOTE: this program requires Matlab "image processing toolbox" to run

% Nov 2020
% Version: Matlab 2020a/b                    
% Vincent Xia

%% Initialize
startup(); % close figures, clear command window, add current directory to search path

[file_name,file_name_short] = getFile(); % get user-specified video file

% return a set of video processing parameters based on input
[rm_pix,skip_frame,t0_frame_num,area_frame_num,background_frame_num, ...
    H_thresh_low, H_thresh_high, ...
    S_thresh_low, S_thresh_high, ...
    V_thresh_low, V_thresh_high, ...
    output_falsecolor,output_analyzed_frames,output_all_masks,output_black_white_mask,output_animated_plot,...
    area_fit_type] = getUserInput();

% Initialize video
[crop_rect, vid, bg_cropped] = startVideo(file_name,background_frame_num);  

                                                                
%% Set total area

[area_mask, outer_region, max_area, shadow_mask, camera_area] = setAreas(vid,crop_rect,area_frame_num,area_fit_type); % set the camera shadow area and the total area

%% Analyze video

% Define output video parameters; open videos for writing
output_framerate = 20; %output frame rate
[bw_vid, analyzed_frames_vid, all_masks_vid, false_color_vid] = initVids(output_black_white_mask, file_name_short, output_framerate, output_analyzed_frames, output_all_masks, output_falsecolor);

% Begin video processing
wait_bar = waitbar(0,'Analyzing... Go grab a cup of coffee...');
num_it = floor(vid.NumFrames/skip_frame); % number of times we iterate through the analysis loop

dewet_area = zeros(1,num_it*skip_frame); % stores the area for every frame index (formerly called 'grain_areas')
wet_area = zeros(size(dewet_area)); % stores normalized wet area for every frame index

final_frame_num = 3000; % dictates the last frame of the video to be analyzed
for cur_frame_num = t0_frame_num: skip_frame: final_frame_num
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

%% Plot time vs area data

time = zeros(1,length(wet_area)); % raw video time
graph_time = zeros(1,length(wet_area)); % time after t0
output_size = floor((final_frame_num-t0_frame_num)/skip_frame); % number of row entries for the final area+time file output
area_data_output = zeros(3,output_size); % 2D matrix storing the corresponding area+time output

% TODO: make a matrix to represent frames we analyze and just iterate through the matrix, instead of
% changing cur_frame_num each time

for cur_frame_num = t0_frame_num:skip_frame:final_frame_num % set raw video time 
    time(cur_frame_num)=cur_frame_num/vid.FrameRate; %adjusts time for skipped frames and initial frame rate
    graph_time(cur_frame_num) = time(cur_frame_num) - t0_frame_num/vid.FrameRate;
    entry_num = (cur_frame_num-t0_frame_num)/skip_frame + 1; % row entry number for the data output file
    area_data_output(:,entry_num) = [time(cur_frame_num) ; graph_time(cur_frame_num) ; wet_area(cur_frame_num)];
end

if(~output_animated_plot) % writes video of animated plot 
    writeAnimatedPlot(file_name_short,output_framerate,area_data_output);
end

plotArea(area_data_output,file_name_short); % Create and format area plot

% save parameters and data to output files
storeData(file_name_short,area_data_output,...
                   time,wet_area,...
                   rm_pix,t0_frame_num,background_frame_num,area_frame_num,skip_frame,...
                   H_thresh_low, H_thresh_high,...
                   S_thresh_low, S_thresh_high,...
                   V_thresh_low, V_thresh_high);



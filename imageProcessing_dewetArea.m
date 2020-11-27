%% IMAGE PROCESSING OF DEWETTING FROM i-DDrOP VIDEO 
% Takes a ".avi" video file, creates a plot of normalized area vs time. Saves 
% an "_Area.txt" file that stores the analyzed data and can be passed into the 
% "dataprocessing" file for further processing and analysis.

% NOTE: this program requires Matlab "image processing toolbox" to run

% Last tested: Nov 2020 || Version: Matlab 2020ab                    
% Vincent Xia

%% Initialize
startup(); % close figures, clear command window

[file_name,file_name_short] = getFile(); % get user-specified video file

% return a set of video processing parameters based on input
[remove_Pixels,skip_frame,t0_frame_num,area_frame_num,background_frame_num, ...
    H_thresh_low, H_thresh_high, ...
    S_thresh_low, S_thresh_high, ...
    V_thresh_low, V_thresh_high, ...
    output_falsecolor,output_analyzed_frames,output_all_masks,output_black_white_mask,output_animated_plot] = getUserInput();

%% Video Import

crop_start = [150,50]; % upper left hand corner for cropping rectangle
crop_size = [700,700]; % crop size
crop_rect = [crop_start, crop_size-1]; % cropping rectangle || subtract one to make it exactly 700 by 700 in size



video = VideoReader(file_name); % starts reading video
num_frames = video.NumFrames; % gets # of frames in video
input_fps = video.FrameRate; % gets frames/second in initial video
% TODO: add support for video height/width



                                                                   
%% Set total area

background_frame = read(video, background_frame_num); %gets background frame in video (used for deleting background). background frame is when dome crosses interface
background_frame_cropped = imcrop(rgb2gray(background_frame),crop_rect); % Converts to grayscale and crops size  

[area_mask, outer_region, max_area, shadow_mask, camera_area] = setAreas(video,crop_rect,area_fit_type); % set the camera shadow area and the total area

%% Analyze video

% Define output video parameters; open videos for writing
output_framerate = 20; %output frame rate
[bw_vid, analyzed_frames_vid, all_masks_vid, false_color_vid] = initVids(output_black_white_mask, file_name_short, output_framerate, output_analyzed_frames, output_all_masks, output_falsecolor);

% Begin video processing
wait_bar = waitbar(0,'Analyzing... Go grab a cup of coffee...');
num_it = floor(num_frames/skip_frame); % number of times we iterate through the analysis loop

dewet_area = zeros(1,num_it*skip_frame); % stores the area for every frame index (formerly called 'grain_areas')
wet_area = zeros(size(dewet_area)); % stores normalized wet area for every frame index

final_frame_num = 3000; % dictates the last frame of the video to be analyzed
for cur_frame_num = t0_frame_num: skip_frame: final_frame_num
    waitbar(cur_frame_num/final_frame_num,wait_bar); % update wait bar to show analysis progress
    orig_frame = read(video,cur_frame_num); % reading individual frames from input video
    crop_frame = imcrop(orig_frame,crop_rect); 
    gray_frame = rgb2gray(crop_frame); % grayscale frame from video
    subtract_frame = gray_frame - background_frame_cropped; % Subtract background frame from current frame
    
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
    combined_mask_open = bwareaopen(combined_mask, remove_Pixels); % remove small components

    % Count Area; use *Edge Algorithm 2* to throw away inside regions
    [label_dewet_img, dewet_area(cur_frame_num)] = countArea(combined_mask_open,outer_region,size(gray_frame));       
 
    % Write final videos          
    wet_area(cur_frame_num) = writeOutputVids(output_falsecolor,output_analyzed_frames,output_all_masks,output_black_white_mask,...
                                              gray_frame,crop_frame,orig_frame,HSV_mask,bw_frame_mask,label_dewet_img,...
                                              bw_vid,false_color_vid,analyzed_frames_vid,all_masks_vid,...
                                              dewet_area(cur_frame_num),...
                                              t0_frame_num,cur_frame_num,...
                                              max_area,camera_area,...
                                              input_fps);
end

closeVids(output_black_white_mask, bw_vid, output_analyzed_frames, analyzed_frames_vid, output_all_masks, all_masks_vid, output_falsecolor, false_color_vid);
close(wait_bar); %closes wait bar

%% Handle time vs area data

time = zeros(1,length(wet_area)); % initialize time
graph_time = zeros(1,length(wet_area)); % time after t0
output_size = floor(final_frame_num/skip_frame); % number of row entries for the final area+time file output
area_data_output = zeros(3,output_size); % 2D matrix storing the corresponding area+time output

if(~output_animated_plot) % initialize video of animated plot
    animated_vid=VideoWriter(strcat(file_name_short,'_plot'),'MPEG-4');
    animated_vid.FrameRate = output_framerate;
    open(animated_vid);
end

figure('Name','Area Plot');
hold on;
formatAreaPlot(); % Create and format area plot

for cur_frame_num = t0_frame_num:skip_frame:final_frame_num
    time(cur_frame_num)=cur_frame_num/input_fps; %adjusts time for skipped frames and initial frame rate
    graph_time(cur_frame_num) = time(cur_frame_num) - t0_frame_num/input_fps;
    entry_num = (cur_frame_num-t0_frame_num)/skip_frame + 1; % row entry number for the data output file
    area_data_output(:,entry_num) = [time(cur_frame_num);  graph_time(cur_frame_num) ; wet_area(cur_frame_num)];
    
    if(~output_animated_plot) % writes video of animated plot 
        plot(time(cur_frame_num),wet_area(cur_frame_num),'o');
        writeVideo(animated_vid,getframe(gcf));
    end
end

if(~output_animated_plot)
   close(animated_vid);
end

plot(time,wet_area,'o'); % generate plot
print('-dtiff',strcat(file_name_short,'_graph.tiff')); %save to tiff file
%% Store analyzed data into text file to be used with image processing code

file_id=fopen(strcat(file_name_short,'_Area.txt'),'w');
fprintf(file_id,'%20s %20s %20s \n','Raw time (s)', 'time after t0 (s)', 'area'); 
fprintf(file_id, '%20.3f %20.3f %20.3f \n', area_data_output);
fclose(file_id);
%% Store all data (including skipped frames) into text file

file_id=fopen(strcat(file_name_short,'_AllData.txt'),'w');
fprintf(file_id, '%d %d \n', [time wet_area]');
fclose(file_id);
%% Store image processing parameters into text file

file_id=fopen(strcat(file_name_short,'_Parameters.txt'),'w'); %saves parameters used in file for analysis 
fprintf(file_id, 'remove_Pixels = %d \n', remove_Pixels);
fprintf(file_id, 't_0 = %d \n', t0_frame_num);
fprintf(file_id, 'background = %d \n', background_frame_num);
fprintf(file_id, 'frame for area analysis = %d \n', area_frame_num);
fprintf(file_id, 'frames_skipped = %d \n', skip_frame);
fprintf(file_id, 'HueThreshold = (%.3f,%.3f) \n', H_thresh_low, H_thresh_high);
fprintf(file_id, 'SaturationThreshold = (%.3f,%.3f) \n', S_thresh_low, S_thresh_high);
fprintf(file_id, 'ValueThreshold = (%.3f,%.3f)', V_thresh_low, V_thresh_high);
fclose(file_id);



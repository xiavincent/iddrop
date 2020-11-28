%% IMAGE PROCESSING OF DEWETTING FROM i-DDrOP VIDEO 
% Takes a ".avi" video file, creates a plot of normalized area vs time. Saves 
% an "_Area.txt" file that stores the analyzed data and can be passed into the 
% "dataprocessing" file for further processing and analysis.

% NOTE: this program requires Matlab "image processing toolbox" to run

% Nov 2020
% Version: Matlab 2020a/b                    
% Vincent Xia

%% Initializations
startup(); % close figures, clear command window, add current directory to search path

[file_name,file_name_short] = getFile(); % get user-specified video file

% return a set of video processing parameters based on input
% [params.rm_pix,params.skip,params.t0,params.area,params.bg, ...
%     params.H_low, H_thresh_high, ...
%     S_thresh_low, S_thresh_high, ...
%     V_thresh_low, V_thresh_high, ...
%     output_falsecolor,output_analyzed_frames,output_all_masks,output_black_white_mask,output_animated_plot,...
%     params.fit_type] = getUserInput();



[params,outputs] = getUserInput(); % 2 structs that hold all of our processing/output selections

% Initialize video
[crop_rect, vid, bg_cropped] = startVideo(file_name,params.bg);  

                                                                
%% Set total area
[area_mask, outer_region, max_area, shadow_mask, camera_area] = setAreas(vid,crop_rect , params.area , params.fit_type); % set the camera shadow area and the total area

%% Analyze video

[wet_area,final_frame_num] = analyzeVideo(file_name_short, output_black_white_mask, output_analyzed_frames, output_all_masks, output_falsecolor,...
                                                    area_mask, outer_region, max_area, shadow_mask, camera_area,...
                                                    crop_rect, vid, bg_cropped,...
                                                    params.rm_pix, params.t0, params.skip,...
                                                    params.H_low, H_thresh_high,...
                                                    S_thresh_low, S_thresh_high,...
                                                    V_thresh_low, V_thresh_high);

%% Plot time vs area data

% TODO: make a matrix to represent frames we analyze and just iterate through the matrix, instead of
% changing cur_frame_num each time
% area_data_output = makeAreaOutput(); % make a matrix that holds all of our time and area information

output_size = floor((final_frame_num - params.t0)/params.skip); % number of row entries for the final area+time file output
area_data_output = zeros(3,output_size); % 2D matrix storing the corresponding area+time output

for cur_frame_num = params.t0 : params.skip:final_frame_num % set raw video time 
    raw_time = cur_frame_num/vid.FrameRate; %adjusts time for skipped frames and initial frame rate
    graph_time = raw_time - params.t0/vid.FrameRate; % time after t0
    entry_num = (cur_frame_num-params.t0)/params.skip + 1; % column entry number for the data output file
    area_data_output(entry_num,:) = [raw_time , graph_time , wet_area(cur_frame_num)];
end

if(~output_animated_plot) % writes video of animated plot 
    writeAnimatedPlot(file_name_short,output_framerate,area_data_output);
end

plotArea(area_data_output,file_name_short); % Create and format area plot

% save parameters and data to output files
storeData(file_name_short,area_data_output,...
                   params.rm_pix,params.t0,params.bg,params.area,params.skip,...
                   params.H_low, H_thresh_high,...
                   S_thresh_low, S_thresh_high,...
                   V_thresh_low, V_thresh_high);

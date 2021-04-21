%% IMAGE PROCESSING OF THIN FILM DEWETTING FROM i-DDrOP VIDEO 
% Takes '.avi' video file, creates a plot of wet area vs time. 
% Saves '_Area.txt' file with wet area and time info
% Can pass '_Area.txt' into data processing file to calculate dewetting onset time
% Requires Matlab "image processing toolbox" to run

% Apr 2021
% Version: Matlab 2020a/b                    
% Vincent Xia

%% Initializations
init(); % add helper files to path

%% Initializations
[file_name,file_name_short] = getFile(); % get user-specified video file
[params,output] = getUserInput(); % get user processing selections
analys = fillAnalysStruct(); % initialize a struct that stores the parameters used in the analysis

%% Start video and set areas

[analys.crop_rect, vid] = startVideo(file_name,params.bg); % Initialize video

[analys.area_mask, analys.max_area, analys.shadow, analys.shadow_area, analys.film_center, analys.film_radius] = ...
    setAreas(vid, analys.crop_rect, params.area, params.fit_type); % user-specified camera shadow area and total area

%% Analyze video

[wet_area,final_frame_num] = analyzeVideo(file_name_short,vid,analys,params,output);

%% Plot time vs area data

% TODO: make a matrix to represent frames we analyze and just iterate through the matrix, instead of
% changing cur_frame_num each time
% area_data_output = makeAreaOutput(); % make a matrix that holds all of our time and area information

output_size = floor((final_frame_num - params.t0)/params.skip); % number of row entries for the final area+time file output
area_output = zeros(3,output_size); % 2D matrix storing the corresponding area+time output


for cur_frame_num = params.t0 : params.skip:final_frame_num % set raw video time 
    raw_time = cur_frame_num/vid.FrameRate; %adjusts time for skipped frames and initial frame rate
    graph_time = raw_time - params.t0/vid.FrameRate; % time after t0
    entry_num = (cur_frame_num-params.t0)/params.skip + 1; % column entry number for the data output file
    area_output(:,entry_num) = [raw_time ; graph_time ; wet_area(cur_frame_num)];
end

if(~output.animated_plot) % writes video of animated plot 
    writeAnimatedPlot(file_name_short,output_framerate,area_output);
end

plotArea(area_output,file_name_short); % Create and format area plot


% FROM EDGEDETECT VERSION
% get the corresponding times to our area analysis
% function [raw_time,graph_time] = getTimes(num_iterations,params,frame_rate)
%     final_frame_num = (num_iterations-1)*params.skip + params.t0;
%     analy_frame_nums = params.t0 : params.skip : final_frame_num; % set raw video time 
%     raw_time = analy_frame_nums/frame_rate; %adjusts time for skipped frames and initial frame rate
%     graph_time = raw_time - params.t0/frame_rate; % time after t0
% end

%% Save parameters and data to output files
storeData(file_name_short,area_output,params);

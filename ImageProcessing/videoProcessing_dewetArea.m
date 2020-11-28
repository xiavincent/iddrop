%% IMAGE PROCESSING OF DEWETTING FROM i-DDrOP VIDEO 
% Takes a ".avi" video file, creates a plot of normalized area vs time. Saves 
% an "_Area.txt" file that stores the analyzed data and can be passed into the 
% "dataprocessing" file for further processing and analysis.

% NOTE: this program requires Matlab "image processing toolbox" to run

% Nov 2020
% Version: Matlab 2020a/b                    
% Vincent Xia

%% Initializations
startup(); % add helper files to path

%%
[file_name,file_name_short] = getFile(); % get user-specified video file

% get user processing selections
[params,output] = getUserInput(); % struct fields defined in 'getUserInput.m'


% Get masks and area values
analys = fillAnalysStruct(); % make a blank struct with empty fields
                             % fields defined in 'fillAnalysStruct.m'

[analys.crop_rect, anlys.bg_cropped, vid] = startVideo(file_name,params.bg); % Initialize video

%% Set total area

[analys.area_mask, analys.outer_region, analys.shadow, analys.film_area] = ...
    setAreas(vid, analys.crop_rect, params.area, params.fit_type); % user-specified camera shadow area and total area

%% Analyze video

[wet_area,final_frame_num] = analyzeVideo(file_name_short,vid,analys,params,output);

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
    area_data_output(:,entry_num) = [raw_time ; graph_time ; wet_area(cur_frame_num)];
end

if(~output.animated_plot) % writes video of animated plot 
    writeAnimatedPlot(file_name_short,output_framerate,area_data_output);
end

plotArea(area_data_output,file_name_short); % Create and format area plot

%% Save parameters and data to output files
storeData(file_name_short,area_data_output,params);

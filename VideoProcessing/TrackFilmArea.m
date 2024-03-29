%% AREA ANALYSIS OF THIN FILM DEWETTING FROM i-DDrOP VIDEO 
% Takes '.avi' video file, creates a plot of wet area vs time. 
% Saves '_Area.txt' file with wet area and time info
% Can pass '_Area.txt' into data processing file to calculate dewetting onset time
% Requires Matlab "Image Processing," "Computer Vision," and "Parallel Computing" Toolboxes to run

% Dec 2020
% Version: Matlab 2020a/b                    
% Vincent Xia

%% SCRIPT
%% Initializations
init(); % add helper files to path
[file_name,file_name_short] = getFile(); % get user-specified video file name
[params,output] = getUserInput(); % get user's processing selections in the form of 2 structs
analys = fillAnalysStruct(); % initialize a struct to hold analysis parameters
[analys.crop_rect, vid] = startVideo(file_name,params.area); % initialize and crop video

%% Set total area

[analys.area_mask, analys.scaled_mask, analys.max_area] = setAreas(vid, analys.crop_rect, params.area, params.fit_type); % user-specified camera shadow area and total area

%% Analyze video

[wet_area,num_it] = analyzeVideo(file_name_short,vid,analys,params,output);
    
%% Plot time vs area data

[raw_time,graph_time] = getTimes(num_it,params,vid.FrameRate);

area_output = zeros(3,num_it); % 2D matrix storing the corresponding area+time output
area_output(:,:) = [raw_time ; graph_time ; wet_area]; % fill in area array

if(~output.animated_plot) % writes video of animated plot 
    writeAnimatedPlot(file_name_short,output_framerate,area_output);
end

plotArea(area_output,file_name_short); % Create and format area plot

%% Save parameters and data to output files
storeData(file_name_short,area_output,params);

% Analyze the video and return a vector containing the wet area
%% Inputs
% analys: struct containing key analysis masks and area values
% params: struct containing user-specified video processing information
% output: struct containing video output information
%% Outputs
% wet_area: vector of fraction of wet area for each analyzed frame
% final_frame_num: the frame of the video we stopped analyzing at

%% Function
function [wet_frac,num_it] = analyzeVideo(file_name_short,vid,analys,params,output)

    % Define output video parameters; open videos for writing
    output_framerate = 20; %output frame rate
    output_vids = initVids(file_name_short, output_framerate, output); % create a struct to store output videos 

    %% NEW SECTION MIGRATED FROM APR 16 2021 WORKING HSV CODE
    background_frame = read(vid,params.t0); % gets background frame in video (used for deleting background)
    background_frame_gray = rgb2gray(background_frame); 
    analys.bg_gray = imcrop(background_frame_gray,analys.crop_rect); % define new parameter in 'analys' struct
        
    frame_range = [params.t0 vid.NumFrames]; % first and last frame to analyze
    num_it = getNumIt(frame_range,params.skip); % get the number of iterations we need
        
    wet_frac = ones(1, num_it); % normalized wet area for every frame index
    skip_frame = params.skip;
    first_fnum = frame_range(1);
    
    for i=1:num_it
        fnum = (i-1)*skip_frame + first_fnum; % current frame number to process
        wet_frac(i) = analyzeFrame(vid,analys,fnum,params,output,output_vids); % run the analysis loop for a single frame
    end
    
    closeVids(output, output_vids); % close VideoWriter objects
end

%% PRIVATE HELPER FUNCTIONS

function num_iterations = getNumIt(frame_range,skip_frame)
    nframes_to_analyze = frame_range(2) - frame_range(1); % number of frames to analyze
    num_iterations = floor(nframes_to_analyze/skip_frame) + 1; % number of individual video frames to analyze
end





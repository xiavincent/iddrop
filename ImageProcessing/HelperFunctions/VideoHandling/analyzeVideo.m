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

    analysis_timespan = 10*60; % analyze 10 min (600 sec) of video
    max_analysis_frame = round(analysis_timespan)*vid.FrameRate + params.t0; % maximum frame to analysis

    % Define output video parameters; open videos for writing
    output_framerate = 20; %output frame rate
    output_vids = initVids(file_name_short, output_framerate, output); % create a struct to store output videos 
    
    %% NEW SECTION MIGRATED FROM APR 16 2021 WORKING HSV CODE
     % gets background frame in video (used for deleting background)
        
%     first_fnum = params.t0; % first and last frame to analyze
    first_fnum = 40700;
%     last_fnum = min([vid.NumFrames max_analysis_frame]); % analyze until desired frame or end of video (whichever comes first)
    last_fnum = 40921;
    num_it = getNumIt(first_fnum,last_fnum,params.skip); % get the number of iterations we need
        
    wet_frac = ones(1, num_it); % normalized wet area for every frame index
    skip_frame = params.skip;
    
    for i=1:num_it
        fnum = (i-1)*skip_frame + first_fnum; % current frame number to process
        wet_frac(i) = analyzeFrame(vid,analys,fnum,params,output,output_vids); % run the analysis loop for a single frame
    end
    
    closeVids(output, output_vids); % close VideoWriter objects
end

%% PRIVATE HELPER FUNCTIONS

function num_iterations = getNumIt(first_fnum,last_fnum,skip_frame)
    nframes_to_analyze = last_fnum - first_fnum; % number of frames to analyze
    num_iterations = floor(nframes_to_analyze/skip_frame) + 1; % number of individual video frames to analyze
end





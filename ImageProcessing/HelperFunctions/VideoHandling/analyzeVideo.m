% Analyze the video and return a vector containing the wet area
%% Inputs
% analys: struct containing key analysis masks and area values
% params: struct containing user-specified video processing information
% output: struct containing video output information
%% Outputs
% wet_area: vector of fraction of wet area for each analyzed frame
% final_frame_num: the frame of the video we stopped analyzing at

%% Function
function [wet_area,num_it] = analyzeVideo(file_name_short,vid,analys,params,output)

    % Define output video parameters; open videos for writing
    output_framerate = 20; %output frame rate
    output_vids = struct('bw',0,'analyzed',0,'masks',0,'falsecolor',0); % store initialized videos
    [output_vids.bw, output_vids.analyzed, output_vids.masks, output_vids.falsecolor] = ...
        initVids(file_name_short, output_framerate, output.bw_mask , output.analyzed, output.masks, output.falsecolor);  
    
    init_frame_num = params.t0; %params.t0 % frame we start analyzing at
    final_frame_num = 3000; %vid.NumFrames % dictates the last frame of the video to be analyzed
    num_it = getNumIt(init_frame_num,final_frame_num,params.skip); % get the number of iterations we need
    
    wait_bar = waitbar(0,'Analyzing... Go grab a cup of coffee...'); % start video processing
    wet_area = zeros(1, num_it); % normalized wet area for every frame index
    
    overlay = cell([1 num_it]); % holds the final images
    % TODO: implement parallel processing
    
    for i = 1 : num_it  % analyze each frame
        cur_frame_num = (i-1)*params.skip + init_frame_num;
        waitbar(cur_frame_num/final_frame_num,wait_bar); % update wait bar to show analysis progress
        [wet_area(i),overlay{i}] = analyzeFrame(vid, cur_frame_num, analys, params, output, output_vids); % run the analysis loop for a single frame
    end
    
    closeVids(output, output_vids); % close VideoWriter objects
    close(wait_bar); % closes wait bar

end


%% PRIVATE HELPER FUNCTIONS

function num_iterations = getNumIt(first_frame_num,last_frame_num,skip_frame)
    num_frames_analys = last_frame_num - first_frame_num; % how far we will analyze in the video
    num_iterations = floor(num_frames_analys/skip_frame) + 1; % number of individual video frames to analyze
end



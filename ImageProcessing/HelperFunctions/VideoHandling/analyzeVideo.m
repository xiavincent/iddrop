% Analyze the video and return a vector containing the wet area
%% Inputs
% analys: struct containing key analysis masks and area values
% params: struct containing user-specified video processing information
% output: struct containing video output information
%% Outputs
% wet_area: vector of fraction of wet area for each analyzed frame
% final_frame_num: the frame of the video we stopped analyzing at

%% Function
function [wet_area,final_frame_num] = analyzeVideo(file_name_short,vid,analys,params,output)

    % Define output video parameters; open videos for writing
    output_framerate = 20; %output frame rate
    
    output_vids = struct('bw',0,'analyzed',0,'masks',0,'falsecolor',0); % store initialized videos

    [output_vids.bw, output_vids.analyzed, output_vids.masks, output_vids.falsecolor] = ...
        initVids(file_name_short, output_framerate, output.bw_mask , output.analyzed, output.masks, output.falsecolor);   
    
    init_frame_num = params.t0; %params.t0 %5176 % frame we start analyzing at
    final_frame_num = vid.NumFrames; %vid.NumFrames % dictates the last frame of the video to be analyzed
    
    num_frames_analys = final_frame_num - params.t0; % how far we will analyze in the video
    num_it = floor(num_frames_analys/params.skip) + 1; % number of individual video frames to analyze
    
    wait_bar = waitbar(0,'Analyzing... Go grab a cup of coffee...'); % start video processing
    wet_area = zeros(1, num_it*params.skip); % normalized wet area for every frame index

    for i = 1 : num_it
        cur_frame_num = (i-1)*params.skip + init_frame_num;
        waitbar(cur_frame_num/final_frame_num,wait_bar); % update wait bar to show analysis progress
        wet_area(cur_frame_num) = analyzeFrame(vid, cur_frame_num, analys, params, output, output_vids); % run the analysis loop for a single frame
    end
    
    closeVids(output.bw_mask, output_vids.bw,...
              output.analyzed, output_vids.analyzed,...
              output.masks, output_vids.masks,...
              output.falsecolor, output_vids.falsecolor);
          
    close(wait_bar); % closes wait bar

end


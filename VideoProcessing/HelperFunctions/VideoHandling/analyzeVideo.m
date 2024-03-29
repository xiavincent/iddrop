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
    output_framerate = 20; % define output frame rate
    output_vids = initVids(file_name_short, output_framerate, output); % create a struct to store output videos 
    
    frame_range = [params.t0 vid.NumFrames]; % [params.start vid.NumFrames] % first and last frame to analyze
    num_it = getNumIt(frame_range,params.skip); % get the number of iterations we need
        
    wet_frac = ones(1, num_it); % normalized wet area for every frame index
    overlay = cell([1 num_it]); % holds the final images        
    skip_frame = params.skip;
    first_fnum = frame_range(1);
    
    for i=1:num_it  % analyze each frame
        fnum = (i-1)*skip_frame + first_fnum; % current frame number to process
        [wet_frac(i),overlay{i}] = analyzeFrame(vid,analys, fnum,params.start,params.area); % run the analysis loop for a single frame
    end
    
    writeOverlayVid(overlay,wet_frac,skip_frame,frame_range(1),~output.falsecolor,output_vids.falsecolor)
    closeVids(output, output_vids); % close VideoWriter objects
end


%% PRIVATE HELPER FUNCTIONS

function num_iterations = getNumIt(frame_range,skip_frame)
    nframes_to_analyze = frame_range(2) - frame_range(1); % number of frames to analyze
    num_iterations = floor(nframes_to_analyze/skip_frame) + 1; % number of individual video frames to analyze
end

function writeOverlayVid(overlay,wet_frac,skip_frame,first_fnum,output_yn,video)
   if (output_yn)
        for i=1:length(overlay) % write every overlay frame
            fnum = (i-1)*skip_frame + first_fnum;
            writeOverlayFrame(overlay{i},fnum,wet_frac(i),video); % write overlay frames to mp4 video
        end
   end
end

function writeOverlayFrame(overlay,frame_num,wet_frac,video)
    frame_info = sprintf('Frame: %d |  Area: %.3f', frame_num, wet_frac); % prints frame # and area frac for each mp4 video frame
    output_img = insertText(overlay,[100 50],frame_info,'AnchorPoint','LeftBottom','BoxColor','black',"TextColor","white"); % NOTE: requires Matlab Computer Vision Toolbox
    writeVideo(video, output_img); % writes video with analyzed frames
end



% Initialize parameters from dialog boxes:
function [remove_Pixels,skip_frame,t0_frame_num,area_frame,background_frame_num,area_fit_type,...
            output_false_color,output_analyzed_frames,output_all_masks,output_black_white_mask,output_animated_plot] ...
        = fillParams(input_dialog,analysis_type,video_output_types)

    remove_Pixels = str2double(input_dialog{1}); % parameter passed to 'bwareaopen' that tells us how small (in pixels) objects need to be before we remove them from the analysis
    skip_frame = str2double(input_dialog{2}); %frequency with which we analyze video frames
    t0_frame_num=str2double(input_dialog{3});  % intial time when the dome reaches its maximum height
    area_frame=str2double(input_dialog{4}); % Background frame for defining total area; pick frame 
                                            % after edge 'gravity-driven' dewetting occurs, and once
                                            % interference patterns begin
                                                                                  
    background_frame_num = t0_frame_num+5; % Keep at t_0 for videos with fast dewetting
    
    area_fit_type = str2double(analysis_type{1}); % use an assisted freehand on the area_frame fitting, or just use a circle

    output_false_color = str2double(video_output_types{1}); % print the final binary mask output video in BW or falsecolor overlay on original frame
    output_analyzed_frames = str2double(video_output_types{2}); % tells us whether or not to print an mp4 of analyzed frames from original video
    output_all_masks = str2double(video_output_types{3}); % tells us whether or not to print an mp4 of individual masks from video
    output_black_white_mask = str2double(video_output_types{4}); % simple black/white mask mp4 video
    output_animated_plot=str2double(video_output_types{5}); % should we plot the animated video or not?
    
end
% Initialize parameters from dialog boxes:
function [params, output] = fillParams(input_dialog,analysis_type,video_output_types)
                                                                                  
    % make a struct to hold all of our processing parameters
    params = struct;
    params.rm_pix = str2double(input_dialog{1}); % parameter passed to 'bwareaopen' that tells us how small (in pixels) objects need to be before we remove them from the analysis
    params.skip = str2double(input_dialog{2}); %frequency with which we analyze video frames
    params.t0 = str2double(input_dialog{3});  % intial time when the dome reaches its maximum height
    params.start = str2double(input_dialog{4}); % frame to start analysis (once dewetting regime begins)
    params.area = str2double(input_dialog{5}); % Background frame for defining total area; pick frame 
                                            % after edge 'gravity-driven' dewetting occurs, and once
                                            % interference patterns begin  val4 = area_frame_num;
    params.fit_type = str2double(analysis_type{1}); % use an assisted freehand on the area_frame fitting, or just use a circle
    
    
    % make a struct to store the desired output videos
    output = struct;
    output.falsecolor = str2double(video_output_types{1}); % print the final binary mask output video in BW or falsecolor overlay on original frame
    output.analyzed = str2double(video_output_types{2}); % tells us whether or not to print an mp4 of analyzed frames from original video
    output.masks = str2double(video_output_types{3}); % tells us whether or not to print an mp4 of individual masks from video
    output.bw_mask = str2double(video_output_types{4}); % simple black/white mask mp4 video
    output.animated_plot = str2double(video_output_types{5}); % should we plot the animated video or not?
            
end
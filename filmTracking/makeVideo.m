%% FUNCTION

% make output video of tracking point and include a real-time graph of the RGB intensity

% on the top, put the original video frame with a star at the location that's being tracked
% on the bottom, put a picture of the resultant graph, with a vertical line to indicate where
    % we are on it
    
function makeVideo(graph,loc,data,file_name)

    % for analyzed frame in video
    % save the frame and put a star at the location of interest
    
    fname_short = file_name(end-4:end);

    start_frame = 100;
    skip_frame = 100;
    num_it = floor((vid.NumFrames-start_frame)/skip_frame + 1);
    
    vid = VideoWriter(strcat(fname_short,'_RGBtracking'),'MPEG-4'); 
    
    for i=start_frame:skip_frame:vid.NumFrames % read every 100 frames
        index = (i-start_frame)/skip_frame + 1; % index number for data storage
        cur_frame = read(vid,i); % read in the frame
        
        img = makeLabelledImg(data,i);
        
        graph = makeLabelledGraph(time,i);
      
        
        
        % make a vertical line on the graph at cur_time
        % fuse it onto the bottom of the original video
    end
    
end


%% HELPER FUNCTIONS
function output_img = makeLabelledImg(data,fnum)
    R  = data.RGB(1,index); % previously saved RGB intensity values
    G = data.RGB(2,index);
    B = data.RGB(3,index);
    time = data.time(1,index); % grab raw video time

    frame_info = sprintf('Frame: %d |  Time: %d | RGB: %.2f, %.2f, %.2f',fnum, time, R,G,B); % prints frame # and area frac for each mp4 video frame
    output_img = insertText(cur_frame,[100 50],frame_info,'AnchorPoint','LeftBottom','BoxColor','black',"TextColor","white"); % NOTE: requires Matlab Computer Vision Toolbox

end

function graph = makeLabelledGraph(time,fnum)





end
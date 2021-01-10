%% FUNCTION

% make output video of tracking point and include a real-time graph of the RGB intensity

% on the top, put the original video frame with a star at the location that's being tracked
% on the bottom, put a picture of the resultant graph, with a vertical line to indicate where
    % we are on it
    
function makeVideo(fig,data,loc,file_name,vid)

    reducePadding(); % remove padding around figure
    
    fname_short = file_name(end-4:end);

    start_frame = 100;
    skip_frame = 100;
    
    output_vid = VideoWriter(strcat(fname_short,'_RGBtracking'),'MPEG-4'); 
    output_vid.FrameRate = 20;
    open(output_vid);

        
    for i=start_frame:skip_frame:vid.NumFrames % read every 100 frames
        index = (i-start_frame)/skip_frame + 1; % index number for data storage
        cur_frame = read(vid,i); % read in the frame
        
        time = data.time(1,index); % grab raw video time
        [R,G,B] = getRGB(data.RGB,index); % grab RGB intensities based on current index

        lab_img = makeLabelledImg(time,loc,i,cur_frame,R,G,B);
        lab_graph = makeLabelledGraph(data,index,fig);
        
        writeOutputFrame(output_vid,lab_img,lab_graph); % fuse the two images and write to output video
    end
    close(output_vid)
    
end


%% HELPER FUNCTIONS
% get previously saved RGB intensity values from index
function [R,G,B] = getRGB(RGB_data,index)
    R = RGB_data(1,index);
    G = RGB_data(2,index);
    B = RGB_data(3,index);
end

% put a marker at the tracking location and label the image with intensity data
function output_img = makeLabelledImg(time,loc,fnum,RGB_img,R,G,B)
    frame_info = sprintf('Frame: %d |  Raw Time: %.2f | RGB: %d, %d, %d',fnum, time, R,G,B); % prints frame # and area frac for each mp4 video frame
    output_img = insertText(RGB_img,[25 25],frame_info,'AnchorPoint','LeftTop','BoxColor','black',"TextColor","white"); % NOTE: requires Matlab Computer Vision Toolbox
    output_img = insertMarker(output_img,[loc(2) loc(1)],'square','color','yellow','size',5); % put a green circle at the user-selected x,y location
end

% add a vertical line on the graph at the current time point and return a raw image of the graph
function graph = makeLabelledGraph(data,index,graph)
    time = data.time(1,index); % grab raw video time

%     fig2 = figure; % new figure 
%     set(gcf, 'Position', [1, 1, 1024, 768]); % increase figure size
% 
%     copyobj(fig1.Children,fig2); % make a copy of the original figure
    vline = xline(time,'--r'); % plot a line at the current time
%     reducePadding();

    graph_struct = getframe(fig2);
    graph = graph_struct.cdata;
    graph = imresize(graph,[768 1024]); % resize to same dimensions as input video
    close(fig2); % close figure
end




% fuse the image and graph into the same frame and write it to 'vid'
function writeOutputFrame(vid,RGB_img,graph) 
    output = [RGB_img; graph]; % vertically concatenate images
    writeVideo(vid,output); % save to output video
end
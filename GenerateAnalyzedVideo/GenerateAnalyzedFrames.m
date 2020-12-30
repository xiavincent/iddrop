%% Generate Shortened Video
% Makes a sped up version of an '.avi' video based on user specified 
% output framerate and skip_frame values
% Vincent Xia, Dec 2020


% Pseudocode
% Run 'initVids' helper function on only the single analyzed frames video
% Run the video writing portion of the old analyzeFrame code (include video time on frame)
% close the video

%% SCRIPT

init(); % check for toolboxes
[file_name,file_name_short] = getVidPath(); % get user-specified video file
params = getUserInput();

initOutputVid(params.framerate); % open the output video for writing
getFrames(vid); % get the frames of video based on skip_frame


%% PRIVATE HELPER FUNCTIONS

% initialize and open the output video
function initOutputVid(output_framerate)
    analyzed_frames = VideoWriter(strcat(file_name_short,'_analyzedOrigVideo'),'MPEG-4'); %writes video showing the original frames that were analyzed
    analyzed_frames.FrameRate = output_framerate; %sets output video frame rate based on user-specified value
    open(analyzed_frames); % opens video for analyzed frames from original video
end

% grab the specified frames from the original video and put them into a new output
function getFrames(vid,skip_frame)
    for i=1:skip_frame:vid.NumberOfFrames % iterate through the video
        frame = read(vid,i); % grab the frame
        writeToOutput(frame, i, vid); % write it to the output video
    end
end

% write a frame to the output video with its accompanying caption
function writeToOutput(frame,fnum,vid)
    % TODO: graph_time = [calculate based on video frame rate and current frame number, i]
    frame_info = sprintf('Frame: %d | Time: %.3f sec ', fnum , graph_time); % prints frame #, time stamp, and area for each mp4 frame
    image = insertText(frame,[30 725],frame_info,'FontSize',55,'BoxColor','white','AnchorPoint','LeftBottom'); %requires Matlab Computer Vision Toolbox
    writeVideo(vid,image);
end




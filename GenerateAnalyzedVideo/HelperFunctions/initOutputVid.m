%% FUNCTION
% initialize and open the output video
function analyzed_frames_vid = initOutputVid(file_name,output_framerate)
    file_name_short = file_name(1:end-4);
    analyzed_frames_vid = VideoWriter(strcat(file_name_short,'_skipFramesVideo'),'MPEG-4'); %writes video showing the original frames that were analyzed
    analyzed_frames_vid.FrameRate = output_framerate; %sets output video frame rate based on user-specified value
    open(analyzed_frames_vid); % opens video for analyzed frames from original video
end
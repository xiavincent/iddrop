%% Generate Shortened Video
% Makes a sped up version of an '.avi' video based on user specified 
% output framerate and skip_frame values
% Vincent Xia, Dec 2020

%% SCRIPT
init(); % check for toolboxes
[file_name,~] = getVidPath(); % get user-specified video file

%%
input_vid = startVid(file_name);

params = getUserInput();

%%
output_vid = initOutputVid(file_name,params.fr); % open the output video for writing
saveFrames(input_vid,output_vid,params); %  save the frames of video based on skip_frame
closeVid(output_vid); % close output videowriter object


%% PRIVATE HELPER FUNCTIONS

% initialize and open the output video
function analyzed_frames_vid = initOutputVid(file_name,output_framerate)
    file_name_short = file_name(1:end-4);
    analyzed_frames_vid = VideoWriter(strcat(file_name_short,'_analyzedOrigVideo'),'MPEG-4'); %writes video showing the original frames that were analyzed
    analyzed_frames_vid.FrameRate = output_framerate; %sets output video frame rate based on user-specified value
    open(analyzed_frames_vid); % opens video for analyzed frames from original video
end




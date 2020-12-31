%% GENERATE SHORTENED VIDEO
% - Makes a sped up version of an '.avi' video based on user specified output framerate frame
%   skipping
% - Include time stamps in bottom lefthand corner
% Vincent Xia, Dec 2020

%% SCRIPT 

init(); % check for toolboxes
[file_name,~] = getVidPath(); % get user-specified video file

input_vid = startVid(file_name);
params = getUserInput();

output_vid = initOutputVid(file_name,params.fr); % open the output video for writing
saveFrames(input_vid,output_vid,params); %  save the frames of video based on skip_frame
closeVid(output_vid); % close output videowriter object





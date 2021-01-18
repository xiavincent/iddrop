%% FUNCTION
% create a Matlab videoreader object
function video = startVid(file_name)
    video = VideoReader(file_name);
end
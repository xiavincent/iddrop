% Get video parameters, set cropping rectangle, and save background frame
function [crop_rect, vid, bg_frame_cropped] = startVideo(file_name,background_frame_num)

    crop_start = [150,50]; % upper left hand corner for cropping rectangle
    crop_size = [700,700]; % crop size
    crop_rect = [crop_start, crop_size-1]; % cropping rectangle || subtract one to make it exactly 700 by 700 in size

    vid = VideoReader(file_name); % starts reading video
    % TODO: add support for video height/width

    bg_frame = read(vid, background_frame_num); %gets background frame in video (used for deleting background). background frame is when dome crosses interface
    bg_frame_cropped = imcrop(rgb2gray(bg_frame),crop_rect); % Converts to grayscale and crops size  

end
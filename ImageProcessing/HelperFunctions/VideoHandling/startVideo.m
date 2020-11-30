% Get video parameters, set cropping rectangle, and save background frame
function [crop_rect, bg_frame_cropped, vid] = startVideo(file_name,background_frame_num)


    vid = VideoReader(file_name); % starts reading video
    
    bg_frame = read(vid, background_frame_num); %gets background frame in video (used for deleting background). background frame is when dome crosses interface
    
    crop_rect = getCropSize(bg_frame);
    
    bg_frame_cropped = imcrop(rgb2gray(bg_frame),crop_rect); % Converts to grayscale and crops size  


end

% get user-specified cropping rectangle
function crop_rect = getCropSize(frame)

    % default
%     crop_start = [150,50]; % upper left hand corner for cropping rectangle
%     crop_size = [700,700]; % crop size
%     crop_rect = [crop_start, crop_size-1]; % cropping rectangle || subtract one to make it exactly 700 by 700 in size

    

    figure('Name','Cropping rectangle');
    dim = [.2 0 .1 .1];
    str = 'Crop the image to the smallest rectangle containing the dome. Double click when done.';
    annotation('textbox',dim,'String',str,'FitBoxToText','on','BackgroundColor','white');
%     xlabel("Crop the image to the smallest rectangle containing the dome. Double click when done.");
    [~, crop_rect] = imcrop(frame);
    close('Cropping rectangle');

end
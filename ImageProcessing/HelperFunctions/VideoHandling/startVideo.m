% Get video parameters, set cropping rectangle, and save background frame
function [crop_rect, vid] = startVideo(file_name,background_frame_num)


    vid = VideoReader(file_name); % starts reading video
    
    bg_frame = read(vid, background_frame_num); %gets background frame in video (used for deleting background). background frame is when dome crosses interface
    
    crop_rect = getCropSize(bg_frame);
    

end

% get user-specified cropping rectangle
function crop_rect = getCropSize(frame)

    figure('Name','Cropping rectangle');
    dim = [.2 0 .1 .1];
    str = 'Crop the image to the smallest rectangle containing the dome. Double click when done.';
    annotation('textbox',dim,'String',str,'FitBoxToText','on','BackgroundColor','white');
    [~, crop_rect] = imcrop(frame);
    close('Cropping rectangle');

end
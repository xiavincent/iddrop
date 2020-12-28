% Get video parameters, set cropping rectangle, and save background frame
function [crop_rect, vid] = startVideo(file_name,background_frame_num,area_frame_num)
    vid = VideoReader(file_name); % starts reading video
    bg_frame = read(vid, background_frame_num); %gets background frame in video (used for deleting background). background frame is when dome crosses interface
    
    area_frame = read(vid,area_frame_num);
    crop_rect = getCropSize(area_frame);
end


%% PRIVATE HELPER FUNCTION

% get user-specified cropping rectangle
function crop_rect = getCropSize(frame)

    dome_mask = findDome(frame);
    
    stats = regionprops(dome_mask,'BoundingBox'); % get rectangle coordinates of minimum bounding box
    
    min_coord = [stats.BoundingBox(1) stats.BoundingBox(2)] - 15; % leave a 15 pixel padding on all sides
    width_height = [stats.BoundingBox(3) stats.BoundingBox(4)] + 30;
    
    crop_rect = [min_coord width_height];

%     figure('Name','Cropping rectangle');
%     dim = [.2 0 .1 .1];
%     str = 'Crop the image to the smallest rectangle containing the dome. Double click when done.';
%     annotation('textbox',dim,'String',str,'FitBoxToText','on','BackgroundColor','white');
%     [~, crop_rect] = imcrop(frame);
%     close('Cropping rectangle');
end
% Set camera shadow area and total area for a video
function [area_mask, outer_region, max_area, shadow_mask, camera_area] = setAreas(video,crop_rect,area_frame_num,area_fit_type)
    area_frame = read(video,area_frame_num);        % Read user specified frame for area analysis
    area_frame_cropped = imcrop(area_frame,crop_rect);     % Crop area frame

    [area_mask, outer_region, max_area, shadow_mask, camera_area] = userdrawROI(area_frame_cropped,area_fit_type); % Handle our ROI drawing
end
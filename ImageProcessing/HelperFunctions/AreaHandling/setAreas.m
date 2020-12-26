% Set film mask and dome area from user-input
%% OUTPUTS:
% area_mask: user-specified mask to cover the film at 'area_frame_num'
% outer_region: outer edge of 'area_mask' used to run the edge detection algorithm
% shadow_mask: user-specified mask to cover the camera shadow
% film_area: total area of film at 'area_frame_num' excluding the area of the camera shadow

%% INPUTS:
% TODO: describe input parameters

%% FUNCTION:
function [area_mask, film_area] = setAreas(video,crop_rect,area_frame_num,area_fit_type)
    area_frame = read(video,area_frame_num);        % Read user specified frame for area analysis
    area_frame_cropped = imcrop(area_frame,crop_rect);     % Crop area frame

    [area_mask, film_area] = userdrawROI(area_frame_cropped,area_fit_type); % Handle our ROI drawing
end
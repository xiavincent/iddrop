% Set film mask and dome area from user-input
%% OUTPUTS:
% area_mask: user-specified mask to cover the film at 'area_frame_num'
% outer_region: outer edge of 'area_mask' used to run the edge detection algorithm
% shadow_mask: user-specified mask to cover the camera shadow
% max_area: total area of film at 'area_frame_num'

%% INPUTS:
% video: Matlab videoreader object
% crop_rect: rectangle describing coordinates and size of dome's location for video cropping
% area_frame_num: frame number for user-specified area fitting
% area_fit_type: binary parameter describing how user fitting should be performed 
%     (0 = freehand; 1 = circular)

%% FUNCTION:
function [area_mask, scaled_mask, max_area] = setAreas(video,crop_rect,area_frame_num,area_fit_type)
    area_frame = read(video,area_frame_num);        % Read user specified frame for area analysis
    area_frame_cropped = imcrop(area_frame,crop_rect);     % Crop area frame
    [area_mask, ~] = userdrawROI(area_frame_cropped,area_fit_type); % Handle our ROI drawing
    
%     scaled_maskA = scaleMask(area_mask, 1.01); % scale larger by 1%
    
    grow_size = 2; % number of pixels by which we expand the boundary
    scaled_mask = closeEdges(area_mask,grow_size); % scale mask larger using the edge detection size-scaling helper function
    max_area = nnz(scaled_mask); % set maximum area using scaled version of user-defined area
    
end
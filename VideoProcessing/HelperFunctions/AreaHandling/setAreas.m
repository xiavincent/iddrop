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
function [cam_mask, dome_mask, scaled_mask, max_area, crop_rect, seed_rc] = setAreas(video,area_frame_num)
    area_frame = read(video,area_frame_num); % Read user specified frame for area analysis
    
    dome_mask_raw = findDome(area_frame); % automatically detect dome in full-sized image
    crop_rect = getCropSize(dome_mask_raw); % get cropping rectangle
    dome_mask = imcrop(dome_mask_raw,crop_rect); % crop raw image to get final dome mask
    
    cam_mask_raw = getShadow(area_frame); % extract mask of camera shadow using intensity values
    cam_mask = imcrop(cam_mask_raw,crop_rect); % crop raw image to get final dome mask

    
    max_area = nnz(dome_mask); % number of pixels in mask
    scaled_mask = scaleMask(dome_mask, 0.96); % scale smaller by 4% for later film detection
    
    
    crop = imcrop(area_frame,crop_rect); % crop the area frame 
    f = figure;
    imshow(crop);
    xlabel('Tap inside the camera shadow and then press enter','FontSize',16,'FontName','Arial');
    [seed_x,seed_y] = getpts; % get film seeding location in x (col) and y (row) coordinates
    seed_rc = round([seed_y seed_x]); % convert to a row column vector
    close(f); 
   
%     [area_mask, ~] = userdrawROI(area_frame_cropped,area_fit_type); % Handle our ROI drawing
%     grow_size = 2; % number of pixels by which we expand the boundary
%     scaled_mask = closeEdges(area_mask,grow_size); % scale mask larger using the edge detection size-scaling helper function
%     max_area = nnz(scaled_mask); % set maximum area using scaled version of user-defined area
        

end

%% PRIVATE HELPER FUNCTION
% get automatic cropping rectangle based on dome
function crop_rect = getCropSize(dome_mask)
    stats = regionprops(dome_mask,'BoundingBox'); % get rectangle coordinates of minimum bounding box
    
    min_coord = [stats.BoundingBox(1) stats.BoundingBox(2)] - 15; % leave a 15 pixel padding on all sides
    width_height = [stats.BoundingBox(3) stats.BoundingBox(4)] + 30;
    crop_rect = [min_coord width_height];
end
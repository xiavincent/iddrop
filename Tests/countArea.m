% HELPER FUNCTION -- Vincent Xia -- Nov 2020

% Segments the provided mask using an edge algorithm that throws away central dewetted regions
% then calculates the dewetted area array
function [cleaned_img, total_area] = countArea(HSV_bw_mask,gray_frame,totalAreaCenter,totalAreaRadius,area_fit_type)
    img_size = size(gray_frame);
                
    clean_mask = processComponents(HSV_bw_mask,img_size,totalAreaCenter,totalAreaRadius,area_fit_type); % remove the connected regions in HSV_bw_mask that don't fall within the outer region
    clean_mask_components = bwconncomp(clean_mask); % find connected components again, since now we've removed objects in our clearing region
    cleaned_img = labelmatrix(clean_mask_components); % creates labeled matrix from bwconncomp structure
    
    area_data = regionprops(clean_mask_components, 'Area'); % area of each connected component
    total_area = sum([area_data.Area]); % sum of areas in our cleaned image to be used when calculating wet vs dry area   
end

% process all connected components
function clean_mask = processComponents(HSV_bw_mask,img_size,totalAreaCenter,totalAreaRadius,area_fit_type)
    clean_mask = HSV_bw_mask; % initialize clean_mask
    connected_components = bwconncomp(HSV_bw_mask,8); % finds connected components within binary image (connectivity of 8)                
    num_components = length(connected_components.PixelIdxList); % number of connected components found by 'bwconncomp'
    
    if (num_components ~= 0)
        for k = 1:num_components % iterate through each connected component
            linear_indices = connected_components.PixelIdxList{k}; % locations of pixels in the k'th component
            if (area_fit_type == 1) % circle fit
                clean_mask = edgeAlgCirc(HSV_bw_mask,img_size,totalAreaCenter,totalAreaRadius,linear_indices);                                  
            elseif (area_fit_type == 0) % freehand assisted fit
                outer_region = scaleMask(HSV_bw_mask);
                clean_mask = edgeAlgFree(HSV_bw_mask,outer_region,img_size,linear_indices);
            end

        end
    end
end

% run the circular edge algorithm for a single connected component
function clean_mask = edgeAlgCirc(HSV_bw_mask,img_size,totalAreaCenter,totalAreaRadius,linear_indices)
    radius_rmv = totalAreaRadius - 10; % radius for our clearing region
    
    [row,col] = ind2sub(img_size, linear_indices); % get the coordinates of each pixel in connected component
    coord = cat(2,col,row); % combined coordinate location of each connected component
    distance_from_center = (coord(:,1) - totalAreaCenter(1)).^2 + (coord(:,2) - totalAreaCenter(2)).^2; % Euclidean distance from center of circle of each connected component

    if ~any(distance_from_center > radius_rmv^2) % if none of the pixels in the connected component fall outside the clearing radius
        HSV_bw_mask(linear_indices) = 0; % set the pixels to 0 (black) in the original mask
    end
    
    clean_mask = HSV_bw_mask; % return the cleaned outpu
end

% run the freehand edge algorithm for a single connected component
function clean_mask = edgeAlgFree(HSV_bw_mask,outer_region,img_size,linear_indices)
    
    [row,col] = ind2sub(img_size, linear_indices); % get the coordinates of each pixel in connected component
    
    component_mask = zeros(img_size); % create a mask from the linear indices of the connected component
    component_mask(linear_indices) = 1;

    union = outer_region & component_mask; % overlap between the component and the outer_region    
    if (nnz(union) == 0) % if the component had no overlap with the outer region
        HSV_bw_mask(linear_indices) = 0; % set the pixels to 0 (black) in the original mask
    end

    clean_mask = HSV_bw_mask; % return the cleaned output
end


% scale the mask and return a binary mask of the anti-intersection outer region 
% TODO: this needs to be done on area_mask, not the HSV_bw_mask!
function outer_region = scaleMask(HSV_bw_mask)
    boundaries = bwboundaries(HSV_bw_mask); % returns a cell array of the boundary pixel locations
    coord = boundaries{1}; % copy the vector of x/y coordinates for the boundary of our single region
    
    % debugging plot
    orig_fig = gcf; 
        figure; % new figure
        plot(coord(:,2),coord(:,1),'g','LineWidth',3); % plot the boundary
    figure(orig_fig); % go back to the old figure
    
    pgon_orig = polyshape(coord(:,2),coord(:,1)); % turn the boundary into a polyshape
    [orig_centroid_x, orig_centroid_y] = centroid(pgon_orig); % get the centroid of the polyshape
    
    pgon_scale = scale(pgon_orig, .5, [orig_centroid_x orig_centroid_y]); % scale the polyshape to half its size
    [scale_x,scale_y] = boundary(pgon_scale);
   
    scaled_poly_mask = poly2mask(scale_x, scale_y, 768,  1024);  % convert the scaled ROI polygon into a mask
    
    % debugging plot
    orig_fig = gcf; 
       imshow(scaled_poly_mask);
       title("Scaled mask");
    figure(orig_fig); % go back to the old figure

    outer_region = xor(scaled_poly_mask, HSV_bw_mask); % get non-overlapping region between the scaled mask and the original mask
end




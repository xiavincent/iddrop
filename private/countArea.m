% HELPER FUNCTION -- Vincent Xia -- Nov 2020

% Segments the provided mask using an edge algorithm that throws away central dewetted regions
% then calculates the dewetted area array and returns the cleaned image
function [clean_label_img, total_area] = countArea(orig_mask,outer_region,img_size,area_fit_type)
 
    rm_center_mask = processComponents(orig_mask,outer_region,img_size,area_fit_type); % remove the connected regions in HSV_bw_mask that don't fall within the outer region
%     opened_mask = bwareaopen(clean_mask,250);

    rm_euler_mask = rmNegEuler(rm_center_mask); % remove small Euler characteristic objects

    clean_mask_components = bwconncomp(rm_euler_mask); % find connected components again, since now we've removed objects in our clearing region

    clean_label_img = labelmatrix(clean_mask_components); % creates matrix that labels each dewetted object in the image
    

    
    area_data = regionprops(clean_mask_components, 'Area'); % area of each connected component
    total_area = sum([area_data.Area]); % sum of areas in our cleaned image to be used when calculating wet vs dry area  
end

% process all connected components
function HSV_bw_mask = processComponents(HSV_bw_mask,outer_region,img_size,area_fit_type)

    connected_components = bwconncomp(HSV_bw_mask); % finds connected components within binary image               
    num_components = length(connected_components.PixelIdxList); % number of connected components found by 'bwconncomp'
    component_mask = zeros(img_size); % create a mask from the linear indices of each connected component

    if (num_components ~= 0)
        for k = 1:num_components % iterate through each connected component
            linear_indices = connected_components.PixelIdxList{k}; % locations of pixels in the k'th component
            
            euler_nums = regionprops(, 'Area');

            
                % If the Euler characteristic (see regionprops documentation) for any connected component
                % is negative, then get rid of the connected component
                        
            if (area_fit_type == 1) % circle fit
                HSV_bw_mask = edgeAlgCirc(HSV_bw_mask,outer_region,linear_indices,component_mask);  % remove inside components                                
            elseif (area_fit_type == 0) % freehand assisted fit
                HSV_bw_mask = edgeAlgCirc(HSV_bw_mask,outer_region,linear_indices,component_mask); % remove inside components
            end
        end
    end
end

% run the circular edge algorithm for a single connected component
function HSV_bw_mask = edgeAlgCirc(HSV_bw_mask,outer_region,linear_indices,component_mask)
    
    component_mask(linear_indices) = 1; % fill in the connected component
    union = outer_region & component_mask; % overlap between the component and the outer_region
%     union = (outer_region - component_mask) == 0;

    if (nnz(union) <= 50) % if the component had less than 50 pixels overlap with the outer region
        HSV_bw_mask(linear_indices) = 0; % set the pixels to 0 (black) in the original mask
    end
    

end

% run the freehand edge algorithm for a single connected component
% function clean_mask = edgeAlgFree(HSV_bw_mask,outer_region,img_size,linear_indices)
%         
%     component_mask = zeros(img_size); % create a mask from the linear indices of the connected component
%     component_mask(linear_indices) = 1;
% 
%     union = outer_region & component_mask; % overlap between the component and the outer_region    
%     if (nnz(union) == 0) % if the component had no overlap with the outer region
%         HSV_bw_mask(linear_indices) = 0; % set the pixels to 0 (black) in the original mask
%     end
% 
%     clean_mask = HSV_bw_mask; % return the cleaned output
% end



function rmNegEuler(connected_components)


end






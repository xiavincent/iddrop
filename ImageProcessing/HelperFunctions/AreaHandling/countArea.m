% Segments the provided mask using an edge algorithm that throws away central dewetted regions
% then calculates the dewetted area array and returns the cleaned image
% Vincent Xia -- Nov 2020
%% FUNCTION:

%% MIGRATED APRIL 16 2021 FROM WORKING HSV

function [dewet_comp_labelimg, wet_frac] = countArea(dryarea_mask,img_size,film_radius,film_center,max_area)

    conn_comp = bwconncomp(dryarea_mask,8); % finds connected components within binary image (connectivity of 4)                
    [~,ncol] = size(conn_comp.PixelIdxList);
    
    radius_rm = film_radius - 10; % radius for our clearing region. The center lies at the center of our 'totalArea' circle
                
    for idx = 1:ncol % for each component in connComp
        [row,col] = ind2sub(size(img_size), conn_comp.PixelIdxList{1,idx});
        coord = cat(2,col,row);
        
        loc = (coord(:,1) - film_center(1)).^2 + (coord(:,2) - film_center(2)).^2;
                   
        if ~any(loc > radius_rm^2) % if any pixels in the connected component fall outside our clearing region, with radius 'radiusRmv'...   
            dryarea_mask(conn_comp.PixelIdxList{1,idx}) = 0; % if the component falls entirely inside our clearing region, set pixels to 0 (black)
        end                                  
    end
    
    connCompClean = bwconncomp(dryarea_mask); % finds connected components again, since now we've removed objects in our clearing region
    dewet_comp_labelimg = labelmatrix(connCompClean); % creates labeled matrix from bwconncomp structure
    
    dewet_area = regionprops(connCompClean, 'Area'); % computes 'Area' measurement of connCompClean
    total_dewet_area = sum([dewet_area.Area]);
    
    dewet_frac = total_dewet_area / max_area; % fraction of dry area exclusing camera shadow
    wet_frac = 1 - dewet_frac; % fraction of wet area
end


%% ORIGINAL

% function [clean_label_img, wet_area] = countArea(orig_mask,outer_region,total_film_area,img_size)
%  
%     clean_mask = processComponents(orig_mask,outer_region,img_size); % remove the connected regions in HSV_bw_mask that don't fall within the outer region
%     clean_mask_components = bwconncomp(clean_mask); % find connected components again, since now we've removed objects in our clearing region
%     clean_label_img = labelmatrix(clean_mask_components); % creates matrix that labels each dewetted object in the image
%     
%     dewet_area = regionprops(clean_mask_components, 'Area'); % areas of the connected components
%     total_dewet_area = sum([dewet_area.Area]); % total dewetted area
%    
%     dewet_frac = total_dewet_area / total_film_area; % fraction of dewetted area, excluding the shadow's area
%     wet_area = 1 - dewet_frac; % fraction of wet area      
%     
% end

% Process all connected components in a mask with the edge algorithm and euler algorithm
% return the cleaned mask
function mask = processComponents(mask,outer_region,img_size)

    mask = rmNegEuler(mask); % remove objects with lots of holes
    
    connected_components = bwconncomp(mask); % finds connected components within binary image
    num_components = length(connected_components.PixelIdxList); % number of connected components found by 'bwconncomp'
    component_mask = zeros(img_size); % create a blank mask for each connected component
    if (num_components ~= 0)
        for c = 1:num_components % iterate through each connected component
            linear_indices = connected_components.PixelIdxList{c}; % locations of pixels in the k'th component
            mask = edgeAlg(mask,outer_region,linear_indices,component_mask);  % remove inside components                                
        end
    end
end

% run the edge algorithm for a single connected component's linear indices
% return the cleaned mask
function mask = edgeAlg(mask,outer_region,linear_indices,component_mask)
    component_mask(linear_indices) = 1; % fill in the connected component
    union = outer_region & component_mask; % overlap between the component and the outer_region

    if (nnz(union) <= 10) % if the component has less than 10 pixels overlap with the outer region
        mask(linear_indices) = 0; % set the pixels to 0 (black) in the original mask
    end
end


% Remove small objects with negative euler numbers from a single image
% Return the cleaned image
function mask = rmNegEuler(mask)

    conn_comp = bwconncomp(mask);
    stats = regionprops(conn_comp, 'EulerNumber','Area');

    for c = 1:length(stats)
        % Euler conditions
        cond1 = stats(c).EulerNumber < 0 && stats(c).Area < 500; % small objects with multiple holes
%         cond2 = stats(c).EulerNumber < -20 && stats(c).Area < 5000; % medium objects with a large number of holes
        cond2 = stats(c).EulerNumber < -50; % -50 % large objects with a large number of holes

        if ( cond1 || cond2 ) % check for both conditions
           linear_indices = conn_comp.PixelIdxList{c};
           mask(linear_indices) = 0;  % remove component from orig image
        end
    end
    
end






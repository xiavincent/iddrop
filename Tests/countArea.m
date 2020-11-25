
% segments the provided mask using an edge algorithm that throws away central dewetted regions
% then calculates the dewetted area array
function [cleaned_img, total_area] = countArea(coloredObjectsMask,gray_frame,totalAreaCenter,totalAreaRadius)

    connected_components = bwconncomp(coloredObjectsMask,8); % finds connected components within binary image (connectivity of 4)                
    num_components = length(connected_components.PixelIdxList); % number of connected components found by 'bwconncomp'
    radius_rmv = totalAreaRadius - 10; % radius for our clearing region. The center lies at the center of our 'totalArea' circle
                
    if (num_components ~= 0) % if there's at least one connected component
        coloredObjectsMask = edgeAlg(coloredObjectsMask,gray_frame,totalAreaCenter,totalAreaRadius,connected_components,num_components,radius_rmv); % run the edge detection algorithm
    end
    
    conn_comp_clean = bwconncomp(coloredObjectsMask); % finds connected components again, since now we've removed objects in our clearing region
    cleaned_img = labelmatrix(conn_comp_clean); % creates labeled matrix from bwconncomp structure
    area_data = regionprops(conn_comp_clean, 'Area'); % computes 'Area' measurement of connCompClean
    
    total_area = sum([area_data.Area]); % sum of areas in our cleaned connected components to be used when calculating wet vs dry area   
    
end

function coloredObjectsMask = edgeAlg(coloredObjectsMask,gray_frame,totalAreaCenter,totalAreaRadius,connected_components,num_components,radius_rmv)
    for idx = 1:num_components % for each connected component
        [row,col] = ind2sub(size(gray_frame), connected_components.PixelIdxList{1,idx}); % get the 
        coord = cat(2,col,row); % coordinate location of each connected component
        distance_from_center = (coord(:,1) - totalAreaCenter(1)).^2 + (coord(:,2) - totalAreaCenter(2)).^2; % Euclidean distance from center of circle of each connected component

        if ~any(distance_from_center > radius_rmv^2) % if none of the pixels in the connected component fall outside the clearing radius
            coloredObjectsMask(connected_components.PixelIdxList{1,idx}) = 0; % set the pixels to 0 (black) in the original mask
        end                                  
    end

end


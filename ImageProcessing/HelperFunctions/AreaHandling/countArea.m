% Segments the provided mask using an edge algorithm that throws away central dewetted regions
% then calculates the dewetted area array and returns the cleaned image
% Vincent Xia -- Nov 2020
%% FUNCTION:

%% MIGRATED APRIL 16 2021 FROM WORKING HSV

function [dewet_comp_labelimg, wet_frac] = countArea(dryarea_mask,img_size,film_radius,film_center,max_area)

    conn_comp = bwconncomp(dryarea_mask,8); % finds connected components within binary image (connectivity of 4)                
%     [~,ncol] = size(conn_comp.PixelIdxList);
    
%     radius_rm = film_radius - 10; % radius for our clearing region. The center lies at the center of our 'totalArea' circle
                
%     for idx = 1:ncol % for each component in connComp
%         [row,col] = ind2sub(img_size, conn_comp.PixelIdxList{1,idx});
%         coord = cat(2,col,row);
%         
%         distance_from_center = (coord(:,1) - film_center(1)).^2 + (coord(:,2) - film_center(2)).^2; % squared distance from center of dome based on pythagorean theorem
%                    
%         if ~any(distance_from_center > radius_rm^2)   
%             dryarea_mask(conn_comp.PixelIdxList{1,idx}) = 0; % if the dry area conncomponent falls entirely inside our clearing region, set pixels to 0 (black)
%         end                                  
%     end
    
    connCompClean = bwconncomp(dryarea_mask); % finds connected components again, since now we've removed objects in our clearing region
    dewet_comp_labelimg = labelmatrix(connCompClean); % creates labeled matrix from bwconncomp structure
    
    dewet_area = regionprops(connCompClean, 'Area'); % computes 'Area' measurement of connCompClean
    total_dewet_area = sum([dewet_area.Area]);
    
    dewet_frac = total_dewet_area / max_area; % fraction of dry area out of total area, excluding the camera shadow
    wet_frac = 1 - dewet_frac; % fraction of wet area
end






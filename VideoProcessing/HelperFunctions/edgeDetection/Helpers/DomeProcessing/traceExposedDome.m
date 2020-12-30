% trace the outline of the dome given a binary image of its edges
function boundary_pix = traceExposedDome(edges) 
% return the indices of the pixels on the boundary

    boundary_pix = zeros(2); % default boundary is empty
    
    filled_dome = imfill(edges,'holes'); % get a binary mask of the dome
    [boundaries,~,num_obj,~] = bwboundaries(filled_dome); % trace the boundary of the dome
    
    % TODO: filter by area
    
    if (num_obj > 0) % if we captured the dome successfully
%         [nrows,~] = cellfun(@size,boundaries); % get the number of pixels in the boundaries
%         largest_obj = find(max(nrows)); % find the index of the largest object 
        boundary_pix = boundaries{1}; 

        hold on
        plot(boundary_pix(:,2),boundary_pix(:,1),'r','LineWidth',2); % show the boundary

        % TODO: get the bounding box of 'cleaned_dome' and use that for image cropping
    end
end


%% LEGACY:
% if there's more than one object found, throw an exception
%     if (num_obj > 1)
%         errID = 'detectEdges:domeDetection:tooManyObj';
%         msg = 'Custom message: detected more than one object when searching for the dome!';
%         ME = MException(errID,msg);
%         throw(ME)
%     end 
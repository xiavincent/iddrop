% Scale the mask and return a binary mask of the symmetric difference of the scaled mask and
%  the original mask. Conceptually, this represents the outer region only
function scaled_mask = scaleMask(area_mask,scale_factor)
    boundaries = bwboundaries(area_mask); % returns a cell array of the boundary pixel locations
    coord = boundaries{1}; % copy the vector of x/y coordinates for the boundary of our single region
    
    pgon_orig = polyshape(coord(:,2),coord(:,1)); % turn the boundary into a polyshape
    [orig_centroid_x, orig_centroid_y] = centroid(pgon_orig); % get the centroid of the polyshape
    
    pgon_orig = getLargestPgon(pgon_orig); % get the largest pgon region
    
    pgon_scale = scale(pgon_orig, scale_factor, [orig_centroid_x orig_centroid_y]); % scale the polyshape and make it smaller
    [scale_x,scale_y] = boundary(pgon_scale);
   
    img_size = size(area_mask);
    
    scaled_mask = poly2mask(scale_x, scale_y, img_size(1), img_size(2));  % convert the scaled ROI polygon into a mask
    
    % debugging plot
%     orig_fig = gcf; 
%         figure('Name','Scaled mask and original mask','NumberTitle','off');
%         falsecolor = imfuse(scaled_mask,area_mask,'falsecolor','Scaling','joint','ColorChannels',[1 2 0]); 
%         imshow(falsecolor);
%     figure(orig_fig); % go back to the old figure
    
end

%% PRIVATE HELPER FUNCTION

% return the largest pgon region in a polyshape
function pgon_out = getLargestPgon(pgon_in)
    nregions = pgon_in.NumRegions;
    if (nregions > 1)
        polysort = sortboundaries(pgon_in,'area','descend');
        for (i=2 : nregions)
            pgon_out = rmboundary(polysort,i);
        end
    else
        pgon_out = pgon_in;
    end
end
% HELPER FUNCTION -- Vincent Xia -- Nov 2020
%% MIGRATED APRIL 16 2021 FROM WORKING HSV CODE

% Highest level helper function to allow user to draw the ROI
function [mask, center, radius, exposed_area, crop_rect] = userdrawROI(img,area_fit_type)

    selection_type = 0; % make image caption for fitting total exposed dome
    roi = showAreaROI(img,area_fit_type, selection_type); % set the total area mask
    mask = createMask(roi);
    crop_rect = getCropSize(mask); % find a suitable cropping rectangle
    mask = imcrop(mask,crop_rect); % crop the mask

    % find circular parameters of user area fit
    stats = regionprops('table',mask,'Centroid','MajorAxisLength','MinorAxisLength'); % estimate the center and radius for the drawn region
    center = stats.Centroid;

    diameter = mean([stats.MajorAxisLength stats.MinorAxisLength],2);
    radius = diameter/2;
    
    exposed_area = nnz(mask); % number of pixels selected in the mask
    close; % close image
end

% Mid-level helper function to return the user-specified freehand, ellipse, or circle ROI
function roi = showAreaROI(img,area_fit_type,selection_type)
    imshow(img); % Show area frame as total area input
    
    if (selection_type == 0)
        if (area_fit_type == 1)
            xlabel('Draw freehand around total area; double-click to close and double-click again to finish','FontSize',16,'FontName','Arial');
            roi = drawassisted('Color','r','FaceAlpha',0.4,'LineWidth',1, 'InteractionsAllowed',"all");
            while (isempty(roi.Position)) % repeat if the user deletes the ROI
                roi = drawassisted('Color','r','FaceAlpha',0.4,'LineWidth',1, 'InteractionsAllowed',"all");
            end
        elseif (area_fit_type == 2)
            xlabel('Draw ellipse around total area, adjust as needed, then double click when done!','FontSize',16,'FontName','Arial');
            roi = drawellipse('Color','r','FaceAlpha',0.4,'LineWidth',1, 'InteractionsAllowed',"all");
        elseif (area_fit_type == 3)
            xlabel('Draw circle around total area, adjust as needed, then double click when done!','FontSize',16,'FontName','Arial');
            roi = drawcircle('Color','r','FaceAlpha',0.4,'LineWidth',1, 'InteractionsAllowed',"all");
        end
    else 
        xlabel('Draw circle around camera shadow, adjust as needed, then double click when done!','FontSize',16,'FontName','Arial');
        roi = drawcircle('Color','r','FaceAlpha',0.4,'LineWidth',1, 'InteractionsAllowed',"all");
    end
    
    customWait(roi); % wait for double click
end


%% PRIVATE HELPER FUNCTIONS

% get cropping rectangle from area mask
function crop_rect = getCropSize(dome_mask)

    % get user-specified cropping rectangle
    stats = regionprops(dome_mask,'BoundingBox'); % get rectangle coordinates of minimum bounding box
    
    min_coord = [stats.BoundingBox(1) stats.BoundingBox(2)] - 50; % leave a 50 pixel padding on all sides
    width_height = [stats.BoundingBox(3) stats.BoundingBox(4)] + 100;
    crop_rect = round([min_coord width_height]);
    
end

function customWait(hROI) %general wait function
    l = addlistener(hROI,'ROIClicked',@clickCallback); % Listen for mouse clicks on the ROI
    uiwait; % Block program execution
    delete(l); % Remove listener
end

% Click callback function resumes program execution when you double-click the ROI. Note that event data is passed to the callback function as an images.roi.ROIClickedEventData object, which enables you to define callback functions that respond to different types of actions.
function clickCallback(~,evt)
    if strcmp(evt.SelectionType,'double')
        uiresume;
    end
end

% Scale the mask and return a binary mask of the symmetric difference of the scaled mask and
%   the original mask. Conceptually, this represents the outer region only
function outer_region = scaleMask(area_mask)
    boundaries = bwboundaries(area_mask); % returns a cell array of the boundary pixel locations
    coord = boundaries{1}; % copy the vector of x/y coordinates for the boundary of our single region
    
    % debugging plot
%     orig_fig = gcf; 
%         figure; % new figure
%         plot(coord(:,2),coord(:,1),'g','LineWidth',3); % plot the boundary
%     figure(orig_fig); % go back to the old figure
    
    pgon_orig = polyshape(coord(:,2),coord(:,1)); % turn the boundary into a polyshape
    [orig_centroid_x, orig_centroid_y] = centroid(pgon_orig); % get the centroid of the polyshape
    
    pgon_scale = scale(pgon_orig, .95, [orig_centroid_x orig_centroid_y]); % scale the polyshape and make it smaller
    [scale_x,scale_y] = boundary(pgon_scale);
   
    img_size = size(area_mask);
    
    scaled_poly_mask = poly2mask(scale_x, scale_y, img_size(1), img_size(2));  % convert the scaled ROI polygon into a mask
    
    % debugging plot
    orig_fig = gcf; 
        figure('Name','Scaled mask and original mask','NumberTitle','off');
        falsecolor = imfuse(scaled_poly_mask,area_mask,'falsecolor','Scaling','joint','ColorChannels',[1 2 0]); 
        imshow(falsecolor);
    figure(orig_fig); % go back to the old figure

    outer_region = xor(scaled_poly_mask, area_mask); % get non-overlapping region between the scaled mask and the original mask
end

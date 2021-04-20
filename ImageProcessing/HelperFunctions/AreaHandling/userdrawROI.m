% HELPER FUNCTION -- Vincent Xia -- Nov 2020
%% MIGRATED APRIL 16 2021 FROM WORKING HSV CODE

% Highest level helper function to allow user to draw the ROI
function [mask, exposed_area, center, radius] = userdrawROI(img,area_fit_type)

    selection_type = 0; % make image caption for fitting total exposed dome
    roi = showAreaROI(img,area_fit_type, selection_type); % set the total area mask
    mask = createMask(roi);

    if (area_fit_type == 1) % find circular parameters of freehand fit
        stats = regionprops('table',mask,'Centroid','MajorAxisLength','MinorAxisLength'); % estimate the center and radius for the drawn region
        diameter = mean([stats.MajorAxisLength stats.MinorAxisLength],2);
        
        center = stats.Centroid;
        radius = diameter/2;
    elseif (area_fit_type == 2) % find circular parameters of ellipse fit        
        center = roi.Center;
        radius = (roi.SemiAxes(1) + roi.SemiAxes(2))/2; % average the two semi-axes of the ellipse to get an estimate of its radius
    elseif (area_fit_type == 3) % find circular parameters of circle fit
        center = roi.Center;
        radius = roi.Radius;
    else 
        mask = createMask(roi);
        stats = regionprops('table',mask,'Centroid','MajorAxisLength','MinorAxisLength'); % estimate the center and radius for the drawn region
            center = stats.Centroid;
            diameter = mean([stats.MajorAxisLength stats.MinorAxisLength],2);
            radius = diameter/2;
    end
    exposed_area = nnz(mask);
    
    close;
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


% High-level helper function to handle circular and freehand region drawing for a single video frame
% function [area_mask, outer_region, shadow_mask, film_area] = userdrawROI(area_frame_cropped,area_fit_type)
%     %set the total area mask
%     roi = showAreaROI(area_frame_cropped,area_fit_type); %show the frame and return an roi that we can calculate things from
%     area_mask = createMask(roi);
%     
%     outer_region = scaleMask(area_mask); % scale the mask and return the outer region
%     
%     %set the camera shadow area
%     shadowROI = showShadowROI(area_frame_cropped);    
%     shadow_mask = createMask(shadowROI);
%     
%     max_area = nnz(area_mask);
%     camera_area = nnz(shadow_mask);
%     film_area = max_area - camera_area; % exposed dome area, excluding the camera shadow
%     
%     close;
% end
% 
% % Mid-level helper function to show the freehand or circle ROI
% function roi = showAreaROI(totalareaframecropped,areaFitType)
%     imshow(totalareaframecropped);                                 % Show area frame as total area input
%     
%     if (areaFitType == 1)
%         xlabel('Draw circle around total area, adjust as needed, then double click when done!','FontSize',16,'FontName','Arial');
%         roi = drawcircle('Color','r','FaceAlpha',0.4,'LineWidth',1, 'InteractionsAllowed',"all");
%     else
%         xlabel('Draw freehand around total area; double-click to close and double-click again to finish','FontSize',16,'FontName','Arial');
%         roi = drawassisted('Color','r','FaceAlpha',0.4,'LineWidth',1, 'InteractionsAllowed',"all");
%         while (isempty(roi.Position)) % repeat if the user deletes the ROI
%             roi = drawassisted('Color','r','FaceAlpha',0.4,'LineWidth',1, 'InteractionsAllowed',"all");
%         end
%     end
%     customWait(roi); % wait for double click
% end


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

% HELPER FUNCTION -- Vincent Xia -- Nov 2020

% Handles circular and freehand ROI drawing for a single video frame
function [area_mask, max_area, shadow_mask, camera_area, center, radius] = userdraw_ROI(totalareaframecropped,area_fit_type)
    %set the total area mask
    roi = showAreaROI(totalareaframecropped,area_fit_type); %show the frame and return an roi that we can calculate things from
    area_mask = createMask(roi);
    max_area = nnz(area_mask);
    if (area_fit_type == 1) % circle fit
        center = roi.Center;
        radius = roi.Radius;
    elseif (area_fit_type == 0) % freehand assisted fit
        stats = regionprops('table',area_mask,'Centroid','MajorAxisLength','MinorAxisLength'); % estimate the center and radius for the drawn region
            center = stats.Centroid;
            diameter = mean([stats.MajorAxisLength stats.MinorAxisLength],2);
            radius = diameter/2;
    end

    %set the camera shadow area
    shadowROI = showShadowROI(totalareaframecropped);    
    shadow_mask = createMask(shadowROI);
    camera_area = nnz(shadow_mask); 
    
    close;
end

% Mid-level helper function to show the freehand or circle ROI
function [roi] = showAreaROI(totalareaframecropped,areaFitType)
    imshow(totalareaframecropped);                                 % Show area frame as total area input
    
    if (areaFitType == 1)
        xlabel('Draw circle around total area, adjust as needed, then double click when done!','FontSize',16,'FontName','Arial');
        roi = drawcircle('Color','r','FaceAlpha',0.4,'LineWidth',1, 'InteractionsAllowed',"all");
    else
        xlabel('Draw freehand around total area; double-click to close and double-click again to finish','FontSize',16,'FontName','Arial');
        roi = drawassisted('Color','r','FaceAlpha',0.4,'LineWidth',1, 'InteractionsAllowed',"all");
        while (isempty(roi.Position)) % repeat if the user deletes the ROI
            roi = drawassisted('Color','r','FaceAlpha',0.4,'LineWidth',1, 'InteractionsAllowed',"all");
        end
    end
    customWait(roi); % wait for double click
end

function [shadowROI] = showShadowROI(totalareaframecropped)
    imshow(totalareaframecropped);                                 % Show area frame as total area input
    xlabel('Draw circle around camera shadow, adjust as needed, then double click when done!','FontSize',16,'FontName','Arial');
    shadowROI = drawcircle('Color','r','FaceAlpha',0.4,'LineWidth',1, 'InteractionsAllowed',"all");

    customWait(shadowROI);
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
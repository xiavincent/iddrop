% Return struct to hold analysis parameters
% Set film mask and dome area from user-input


%% OUTPUTS:
% area_mask: user-specified mask to cover the film at 'area_frame_num'
% shadow_mask: user-specified mask to cover the camera shadow
% film_area: total area of film at 'area_frame_num' excluding the area of the camera shadow

%% INPUTS:
% TODO: describe input parameters

%% FUNCTION:
function analys = setAreas(vid,area_frame_num,area_fit_type,t0_fnum)
    
    area_frame = read(vid,area_frame_num); % Read user specified frame for area selection
    [dome_mask,dome_center,dome_radius,dome_area,crop_rect] = userdrawROI(area_frame,area_fit_type); % Handle our area ROI drawing

    area_frame_crop = imcrop(area_frame,crop_rect); % crop the area frame
    [shadow_mask,shadow_area] = getShadow(area_frame_crop); % find the camera shadow automatically based image intensity values
    max_area = dome_area - shadow_area; % ignore the camera shadow in our calculation of the maximum dome area
    
    bg_frame = read(vid,t0_fnum); % save the background frame to be used in the analysis
    bg_frame_gray = rgb2gray(bg_frame); % convert to grayscale
    
    dome_mask_crop = imcrop(dome_mask,crop_rect); % crop the dome mask that was drawn
    bg_frame_gray_crop = imcrop(bg_frame_gray,crop_rect); % crop the background image
    shadow_mask_crop = imcrop(shadow_mask,crop_rect); % crop the camera shadow mask
    
    analys = fillAnalysStruct(dome_mask_crop,shadow_mask_crop,max_area,shadow_area,...
                                dome_center,dome_radius,bg_frame_gray_crop,crop_rect); % return a struct that stores all the parameters
end


%% PRIVATE HELPER FUNCTION:

function analys = fillAnalysStruct(dome_mask,shadow_mask,max_area,shadow_area,...
                                    dome_center,dome_radius,bg_gray,crop_rect)
                            
%     analys.area_mask,analys.max_area,analys.shadow,...
%     analys.shadow_area,analys.film_center,analys.film_radius,analys.crop_rect

    f1 = 'dome_mask'; v1 = dome_mask;
    f2 = 'shadow_mask'; v2 = shadow_mask;

    f3 = 'max_area'; v3 = max_area; % maximum area of exposed dome for area analysis
    f4 = 'shadow_area'; v4 = shadow_area;
    
    f5 = 'dome_center'; v5 = dome_center;
    f6 = 'dome_radius'; v6 = dome_radius;
    
    f7 = 'bg_gray'; v7 = bg_gray;
    f8 = 'crop_rect' ; v8 = crop_rect;

    analys = struct(f1,v1,f2,v2,f3,v3,f4,v4,f5,v5,f6,v6,f7,v7,f8,v8); % populate struct

end




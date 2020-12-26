% Combine the HSV and binarized masks
% Additionally apply the area mask and remove mask holes
function combined_mask_filled = combineMasks(HSV_mask,binary_mask,analys,params)

    combined_mask = HSV_mask & binary_mask;    
    combined_mask(~analys.area_mask) = 0; % apply area mask
    combined_mask_open = bwareaopen(combined_mask, params.rm_pix);
    
    hole_size = 20; % remove holes smaller than 20 pixels
    combined_mask_filled = ~bwareaopen(~combined_mask_open, hole_size); % fill in small holes

end
function analys = fillAnalysStruct()
    f1 = 'crop_rect' ; v1 = 0;
    f2 = 'area_mask'; v2 = 0;
    f3 = 'scaled_mask'; v3 = 0;
    f4 = 'outer_region'; v4 = 0; 
    f5 = 'max_area'; v5 = 0; % total film area at user-specified frame for area analysis
    
    analys = struct(f1,v1,f2,v2,f3,v3,f4,v4,f5,v5); % default field values set to 0
end
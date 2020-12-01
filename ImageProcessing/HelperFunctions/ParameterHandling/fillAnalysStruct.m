function analys = fillAnalysStruct()
    f1 = 'crop_rect' ; v1 = 0;
    f3 = 'area_mask'; v3 = 0;
    f4 = 'outer_region'; v4 = 0; 
    f5 = 'max_area'; v5 = 0;
    f6 = 'shadow'; v6 = 0;
    f7 = 'cam_area'; v7 = 0;
    f8 = 'film_area'; v8 = 0; % total film area at user-specified frame for area analysis
    
    analys = struct(f1,v1,f2,v2,f3,v3,f4,v4,f5,v5,f6,v6,f7,v7,f8,v8); % default field values set to 0
end
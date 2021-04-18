function analys = fillAnalysStruct()
    f1 = 'crop_rect' ; v1 = 0;
    f2 = 'area_mask'; v2 = 0;
    f3 = 'outer_region'; v3 = 0; 
    f4 = 'max_area'; v4 = 0;
    f5 = 'shadow'; v5 = 0;
    f6 = 'cam_area'; v6 = 0;
    f7 = 'max_area'; v7 = 0; % total maximum exposed dome area at user-specified frame for area analysis
    
    analys = struct(f1,v1,f2,v2,f3,v3,f4,v4,f5,v5,f6,v6,f7,v7); % default field values set to 0
end
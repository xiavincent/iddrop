function analys = fillAnalysStruct()
    f1 = 'crop_rect' ; v1 = 0;
    f2 = 'bg_cropped' ; v2 = 0;
    f3 = 'area_mask'; v3 = 0;
    f4 = 'outer_region'; v4 = 0; 
    f5 = 'max_area'; v5 = 0;
    f6 = 'shadow'; v6 = 0;
    f7 = 'cam_area'; v7 = 0;
    
    analys = struct(f1,v1,f2,v2,f3,v3,f4,v4,f5,v5,f6,v6,f7,v7); % default field values set to 0
end
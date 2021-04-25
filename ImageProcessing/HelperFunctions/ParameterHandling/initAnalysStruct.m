% Define the parameters to be stored in 'analys' throughout the program

function analys = initAnalysStruct()
    f1 = 'crop_rect' ; v1 = 0;
    f2 = 'area_mask'; v2 = 0;
    f3 = 'outer_region'; v3 = 0; 
    f4 = 'shadow'; v4 = 0;
    f5 = 'cam_area'; v5 = 0;
    f6 = 'max_area'; v6 = 0; % maximum area of exposed dome for area analysis

    analys = struct(f1,v1,f2,v2,f3,v3,f4,v4,f5,v5,f6,v6); % default field values set to 0
end

function storeData(file_name_short,area_data_output,params)

    % Store analyzed data into text file to be used with image processing code
    f_id = fopen(strcat(file_name_short,'_Area.txt'),'w');
    fprintf(f_id,'%20s %20s %20s \n','Raw time (s)', 'time after t0 (s)', 'area'); 
    fprintf(f_id, '%20.3f %20.3f %20.3f \n', area_data_output); 
    fclose(f_id);
    
    % Store image processing parameters into text file
    f_id=fopen(strcat(file_name_short,'_Parameters.txt'),'w'); %saves parameters used in file for analysis 
    fprintf(f_id, 'remove_Pixels = %d \n', params.rm_pix);
    fprintf(f_id, 't_0 = %d \n', params.t0);
    fprintf(f_id, 'frame for area analysis = %d \n', params.area);
    fprintf(f_id, 'frames_skipped = %d \n', params.skip);
    fprintf(f_id, 'HueThreshold = (%.3f,%.3f) \n', params.H_low, params.H_high);
    fprintf(f_id, 'SaturationThreshold = (%.3f,%.3f) \n', params.S_low, params.S_high);
    fprintf(f_id, 'ValueThreshold = (%.3f,%.3f)', params.V_low, params.V_high);
    fclose(f_id);

end
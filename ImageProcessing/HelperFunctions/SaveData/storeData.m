
function storeData(file_name_short,area_data_output,...
                   time,wet_area,...
                   rm_pix,t0_frame_num,background_frame_num,area_frame_num,skip_frame,...
                   H_thresh_low, H_thresh_high,...
                   S_thresh_low, S_thresh_high,...
                   V_thresh_low, V_thresh_high) 

    % Store analyzed data into text file to be used with image processing code
    f_id = fopen(strcat(file_name_short,'_Area.txt'),'w');
    fprintf(f_id,'%20s %20s %20s \n','Raw time (s)', 'time after t0 (s)', 'area'); 
    fprintf(f_id, '%20.3f %20.3f %20.3f \n', area_data_output);
    fclose(f_id);
    
    % Store all data (including skipped frames) into text file
    f_id = fopen(strcat(file_name_short,'_AllData.txt'),'w');
    fprintf(f_id, '%d %d \n', [time wet_area]');
    fclose(f_id);
    
    % Store image processing parameters into text file
    f_id=fopen(strcat(file_name_short,'_Parameters.txt'),'w'); %saves parameters used in file for analysis 
    fprintf(f_id, 'remove_Pixels = %d \n', rm_pix);
    fprintf(f_id, 't_0 = %d \n', t0_frame_num);
    fprintf(f_id, 'background = %d \n', background_frame_num);
    fprintf(f_id, 'frame for area analysis = %d \n', area_frame_num);
    fprintf(f_id, 'frames_skipped = %d \n', skip_frame);
    fprintf(f_id, 'HueThreshold = (%.3f,%.3f) \n', H_thresh_low, H_thresh_high);
    fprintf(f_id, 'SaturationThreshold = (%.3f,%.3f) \n', S_thresh_low, S_thresh_high);
    fprintf(f_id, 'ValueThreshold = (%.3f,%.3f)', V_thresh_low, V_thresh_high);
    fclose(f_id);

end
% save a smoothed version of the input area vs time data by applying a moving average
function saveSmoothed(fname_short,time,area,smooth_window)  

    f_id = fopen(strcat(fname_short,'_smoothedArea.txt'),'w'); 
    
    area = movmean(area, smooth_window); % moving mean value 
    combined_data = [time(:), area(:)].'; % perform matrix transpose to output in correct order
    
    fprintf(f_id, '%20s %20s \n','time after t0 (s)', 'smoothed area');
    fprintf(f_id, '%20.3f %20.3f \n', combined_data); 
    fclose(f_id);
        
end
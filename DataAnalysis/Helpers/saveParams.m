function saveParams(fname,params,result)

    f_id=fopen(strcat(fname,'_DataProcessingParameters.txt'),'w'); %saves parameters used in file for analysis 
    
    fprintf(f_id, '-----Input parameters-----\n');
    fprintf(f_id, 'dewet_or_not = %d \n', params.dewet);
    fprintf(f_id, 'upper_bound = %.2f \n', params.ubound);
    fprintf(f_id, 'lower_bound = %.2f \n', params.lbound);
    fprintf(f_id, 'smooth_or_not = %d \n', params.smooth);
    fprintf(f_id, 'smooth_window = %d \n', params.smooth_window);
    fprintf(f_id, 'Time delay: %.3f \n', params.delay);


    fprintf(f_id, '\n-----Analysis results-----\n');
    fprintf(f_id, 'Dewetting line: y = %.3g*x + %.3g \n', result.polynom(1), result.polynom(2));    
    fprintf(f_id, 'DOT = %.2f \n', result.DOT);
    fprintf(f_id, 'Rsq = %.3f \n', result.R2);

    fclose(f_id);

end
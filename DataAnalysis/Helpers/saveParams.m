function saveParams(fname,params,result)

    fid=fopen(strcat(fname,'_DataProcessingParameters.txt'),'w'); %saves parameters used in file for analysis 
    
    fprintf(fid, '-----Input parameters-----\n');
    fprintf(fid, 'dewet_or_not = %d \n', params.dewet);
    fprintf(fid, 'upper_bound = %.2f \n', params.ubound);
    fprintf(fid, 'lower_bound = %.2f \n', params.lbound);
    fprintf(fid, 'smooth_or_not = %d \n', params.smooth);
    fprintf(fid, 'smooth_window = %d \n', params.smooth_window);
    fprintf(fid, 'Time delay: %.3f \n', params.delay);


    fprintf(fid, '\n-----Analysis results-----\n');
    fprintf(fid, 'Dewetting line: %.3g*x + %.3g \n', result.polynom(1), result.polynom(2));    
    fprintf(fid, 'DOT = %.2f \n', result.DOT);
    fprintf(fid, 'Rsq = %.3f \n', result.R2);

    fclose(fid);

end
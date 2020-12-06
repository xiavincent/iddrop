function saveParams(fname,params,result)

    fid=fopen(strcat(fname,'_DataProcessingParameters.txt'),'w'); %saves parameters used in file for analysis 
    
    fprintf(fid, 'dewet_or_not = %d \n', params.dewet);
    fprintf(fid, 'upperbound = %.2f \n', params.ubound);
    fprintf(fid, 'lowerbound = %.2f \n', params.lbound);
    fprintf(fid, 'smooth_or_not = %d \n', params.smooth);
    fprintf(fid, 'smooth_window = %d \n', params.smooth_window);
    fprintf(fid, 'line of best fit: %d \n', result.line);
    fprintf(fid, 'DOT = %.2f \n', result.DOT);
    fprintf(fid, 'Rsq = %.3f \n', result.Rsq);
    fprintf(fid, 'Time delay: %.3f \n', params.t);

    fclose(fid);

end
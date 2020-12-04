function saveParams()

    fid=fopen(strcat(fname,'_DataProcessingParameters.txt'),'w'); %saves parameters used in file for analysis 
    fprintf(fid, 'dewet_or_not = %d \n', dewet_or_not);
    fprintf(fid, 'upperbound = %.2f \n', upperbound);
    fprintf(fid, 'lowerbound = %.2f \n', lowerbound);
    fprintf(fid, 'smooth_or_not = %d \n', smooth_or_not);
    fprintf(fid, 'smooth_window = %d \n', smooth_window);
    fprintf(fid, 'DOT = %.2f \n', DOT);
    fprintf(fid, 'Rsq = %.3f \n', Rsq);
    fprintf(fid, 'Time delay: %.3f \n', t);

    fclose(fid);

end
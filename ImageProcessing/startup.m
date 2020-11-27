function startup()
    close all hidden;
    clc;
    
    % WARNING: if application is compiled, it will not be able to modify the path anymore from
    %          inside this function
    addpath(genpath(pwd), '-end','-frozen'); % add all subdirectories to the search path
                                          % ignore new changes to files after program has been
                                          % started
    
end
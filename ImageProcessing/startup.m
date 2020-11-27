function startup()
    close all hidden;
    clc;
    
    cur_dir = pwd;
    a = genpath(cur_dir)
    addpath(genpath(cur_dir), '-end','-frozen'); % add all subdirectories to the search path
                                          % ignore new changes to files after program has been
                                          % started
    
end
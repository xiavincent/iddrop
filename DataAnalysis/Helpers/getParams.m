% return a struct containing all the processing parameters

function params = getParams()


    data_processing = inputdlg({'Does the video dewet? (0=no, 1=yes)','Select upper bound of region to fit',...
        'Select lower bound of region to fit','Perform smoothing? (0=no, 1=yes)','Smoothing window width'},...
        'Data Processing', [1 20; 1 20;1 20;1 20;1 20],{'1','0.97','0.8','1','5'});

    dewet_or_not = str2double(data_processing{1}); %gets this from input dialog
    upperbound = str2double(data_processing{2}); %gets this from input dialog
    lowerbound = str2double(data_processing{3}); %gets this from input dialog
    smooth_or_not = str2double(data_processing{4});   % gets this from input dialog
    smooth_window = str2double(data_processing{5}); %gets this from input dialog
    
    
%     make the params struct


end
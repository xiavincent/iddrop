% return a struct containing all the processing parameters

% Return a struct of user-specified processing parameters
function params = getParams()


    data_processing = inputdlg({'Does the video dewet? (0=no, 1=yes)','Select upper bound of region to fit',...
        'Select lower bound of region to fit','Perform smoothing? (0=yes, 1=no)','Smoothing window width'},...
        'Data Processing', [1 20; 1 20;1 20;1 20;1 20],{'1','0.97','0.8','1','5'});

    dewet_or_not = str2double(data_processing{1}); %gets this from input dialog
    upperbound = str2double(data_processing{2}); %gets this from input dialog
    lowerbound = str2double(data_processing{3}); %gets this from input dialog
    smooth_or_not = str2double(data_processing{4});   % gets this from input dialog
    smooth_window = str2double(data_processing{5}); %gets this from input dialog
    
    f1 = "dewet"; v1 = dewet_or_not;
    f2 = "Ubound"; v2 = upperbound;
    f3 = "Lbound"; v3 = lowerbound;
    f4 = "smooth"; v4 = smooth_or_not;
    f5 = "smooth_window"; v5 = smooth_window;
    
    params = struct(f1,v1,f2,v2,f3,v3,f4,v4,f5,v5);

end
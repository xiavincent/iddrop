% return a struct containing all the processing parameters

% Return a struct of user-specified processing parameters
function params = getParams()

    data_processing = inputdlg({'Does the video dewet? (0=no, 1=yes)',...
        'Perform smoothing? (0=yes, 1=no)',...
        'Smoothing window width'},...
        'Data Smoothing', [1 20; 1 20; 1 20],{'1','1','5'});

    dewet_or_not = str2double(data_processing{1}); %gets this from input dialog
    smooth_or_not = str2double(data_processing{4});   % gets this from input dialog
    smooth_window = str2double(data_processing{5}); %gets this from input dialog
    
    f1 = "dewet"; v1 = dewet_or_not;
    f2 = "smooth"; v2 = smooth_or_not;
    f3 = "smooth_window"; v3 = smooth_window;
    
    params = struct(f1,v1,f2,v2,f3,v3);

end
% return a struct containing all the processing parameters

% Return a struct of user-specified processing parameters
function params = getParams()

    dims = [1 50];
    default = {'1','1','5'};
    prompts = {'Does the video dewet? (0=no, 1=yes)',...
                'Perform smoothing? (0=yes, 1=no)',...
                'Smoothing window width'};
    title = 'Data Smoothing';
    data_processing = inputdlg(prompts, title, dims, default,'on'); % resizable dialog box 
    
    dewet_or_not = str2double(data_processing{1}); % retrieve parameters from input dialog
    smooth_or_not = str2double(data_processing{2});  
    smooth_window = str2double(data_processing{3}); 
    
    f1 = "dewet"; v1 = dewet_or_not;
    f2 = "smooth"; v2 = smooth_or_not;
    f3 = "smooth_window"; v3 = smooth_window;
    
    params = struct(f1,v1,f2,v2,f3,v3);

end
% return a struct containing all the processing parameters

% Return a struct of user-specified processing parameters
function params = getParams()

    dims = [1 50];
    default = {'0','1','1','5','0'};
    prompts = {'Does video dewet? (0=yes, 1=no)',...
                'Save smoothed area file? (0=yes, 1=no)',... % saves smoothed txt file regardless of other params
                'Perform smoothing for line fit? (0=yes, 1=no)',...
                'Smoothing window width',...
                'Ignore time up to _____ sec (won''t fit before this time)'};
    title = 'Data Smoothing';
    data_processing = inputdlg(prompts, title, dims, default,'on'); % resizable dialog box 
        
    dewet_or_not = str2double(data_processing{1}); % retrieve parameters from input dialog
    save_smoothed = str2double(data_processing{2}); 
    smooth_or_not = str2double(data_processing{3});  
    smooth_window = str2double(data_processing{4}); 
    time_delay = str2double(data_processing{5});
    
    
    f1 = "dewet"; v1 = dewet_or_not;
    f2 = "save_smooth"; v2 = save_smoothed;
    f3 = "smooth"; v3 = smooth_or_not;
    f4 = "smooth_window"; v4 = smooth_window;
    f5 = "delay"; v5 = time_delay;
    
    params = struct(f1,v1,f2,v2,f3,v3,f4,v4,f5,v5);

end
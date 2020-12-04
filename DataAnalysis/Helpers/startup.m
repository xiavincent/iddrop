% Close figures, clear command window, add current directory to search path
function startup()
    setDir(); % set the current directory to the 'DataAnalysis' folder
    closeExisting(); % close figures
    
    % WARNING: if application is compiled, it will not be able to modify the path anymore from
    %          inside this function
    addpath(genpath(pwd), '-end','-frozen'); % add all subdirectories to the search path
                                              % ignore new changes to files after program has been
                                              % started    
end

% close existing figures and waitbars and clear command window
function closeExisting() 
    waitbar_handles = findall(0,'type','figure','tag','TMWWaitbar');
    delete(waitbar_handles);
    close all hidden;
    clc;
end

function setDir() % set current folder to folder containing the active editor file
    dir = matlab.desktop.editor.getActive;  % get active file from Matlab editor API
    cd(fileparts(dir.Filename)); % move to directory of active file
end
% Close figures, clear command window, add current directory to search path
function init()
    restoredefaultpath; % set the path to the factory default
    setDir(); % set the current directory to the 'ImageProcessing' folder
    closeExisting(); % close figures

    checkToolbox('Image_Toolbox'); % check for image processing toolbox
    checkToolbox('Distrib_Computing_Toolbox'); % check for parallel processing toolbox
    checkToolbox('Video_and_Image_Blockset'); % check for computer vision toolbox
    
    % WARNING: This function will no longer work if the application is compiled
    addpath(genpath(pwd), '-end','-frozen'); % add all subdirectories to the search path
                                              % ignore new changes to files after startup
end

function checkToolbox(toolbox)
    hasIPT = license('test', toolbox);
    if (~hasIPT)
        message = sprintf('Sorry, but you do not seem to have %s.\nDo you want to try to continue anyway?',toolbox);
        reply = questdlg(message, 'Toolbox missing', 'Yes', 'No', 'Yes');
        if strcmpi(reply, 'No')
            return; % User said No, so exit.
        end
    end
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
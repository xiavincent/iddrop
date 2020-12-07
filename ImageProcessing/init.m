% Close figures, clear command window, add current directory to search path
function init()
    setDir(); % set the current directory to the 'ImageProcessing' folder
    checkToolbox(); % check for image processing toolbox
    closeExisting(); % close figures
    
    % WARNING: if application is compiled to another language, it will not be able to modify the path anymore from
    %          inside this function
    addpath(genpath(pwd), '-end','-frozen'); % add all subdirectories to the search path
                                              % ignore new changes to files after program has been
                                              % started    
end

function checkToolbox()

    hasIPT = license('test', 'image_toolbox');
    if ~hasIPT
        % User does not have image processing toolbox installed.
        message = sprintf('Sorry, but you do not seem to have the Image Processing Toolbox.\nDo you want to try to continue anyway?');
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
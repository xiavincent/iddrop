% Close figures, clear command window, add current directory to search path
function startup()

    checkToolbox(); % check for image processing toolbox

    close all hidden;
    clc;
    
    % WARNING: if application is compiled to another language, it will not be able to modify the path anymore from
    %          inside this function
    addpath(genpath(pwd), '-end','-frozen'); % add all subdirectories to the search path
                                          % ignore new changes to files after program has been
                                          % started
    
end

function checkToolbox()

    hasIPT = license('test', 'image_toolbox');
    if ~hasIPT
        % User does not have the toolbox installed.
        message = sprintf('Sorry, but you do not seem to have the Image Processing Toolbox.\nDo you want to try to continue anyway?');
        reply = questdlg(message, 'Toolbox missing', 'Yes', 'No', 'Yes');
        if strcmpi(reply, 'No')
            % User said No, so exit.
            return;
        end
    end
    
end
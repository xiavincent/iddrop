%% FUNCTION
% Return a structure containing analysis parameters based on user input

% OUTPUTS
    % params: struct containing user-specified processing parameters

function params = getUserInput()
        % Parameters for area analysis
        prompts = {'Skip frames', 'Initial frame above surface','Output framerate'};
        dimensions = [1 40];
        defaults = {'0','0','0'};
        
        analysis_settings = inputdlg(prompts,'Parameters',dimensions,defaults);
                      
        params = fillParams(analysis_settings); % Initialize our parameters from the dialog boxes
end


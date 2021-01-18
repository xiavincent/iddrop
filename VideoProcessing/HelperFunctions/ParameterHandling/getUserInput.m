%% FUNCTION
% return a structure containing analysis parameters and output parameters based on user input

% OUTPUTS
    % params: struct containing user-specified processing parameters
    % outputs: struct containing user-specified desired output videos

function [params,output] = getUserInput()
        
        % Parameters for area analysis
        prompts = {'Remove objects smaller than X pixels 100-1000', ... % will not designate pixels smaller than 'X' as wet/dry (reduces variation)
                                'Skip Frames [1-1000]',... % # of frames skipped between each frame analysis (larger number = faster)
                                'Initial frame above surface',... % first frame where dome is exposed 
                                'Frame to start analysis (after center film separates from dome edges)',... % pick a frame after the center film has separated from the dome's edges
                                'Select video frame for area analysis'}; % Frame for defining total area 
        default = {'250','3','40','1500','2500'}; 
        title = 'Sample';
        analysis_settings = makeInputDlg(title,prompts,default);
                            
        
        % Parameters for system type
        prompts = {'Circle or freehand area fit? (1=circle, 0=freehand)'}; % total area selection method
        default = {'1'};
        title = 'Analysis Type';
        analysis_type = makeInputDlg(title,prompts,default);                      

        % Parameters for desired outputs
        prompts = { 'Falsecolor (1=no, 0=yes) ',... % makes a falsecolor overlay of the binary mask on the original frame          
                          'Analyzed frames(1=no, 0=yes)',... % makes a copy of the analyzed frames from the original video
                          'Individual masks(1=no, 0=yes)',... % makes a montage copy of the individual masks for debugging purposes
                          'Black/white binary mask(1=no,0=yes)',... % binary version of final mask
                          'Animated plot(1=no, 0=yes)'}; % animated video of the dewetting plot
        default = {'1','1','1','1','1'};
        title = 'Output videos';
        video_output_types = makeInputDlg(title,prompts,default);
              
        % Initialize our parameters from the dialog boxes
        [params, output] = fillParams(analysis_settings,analysis_type,video_output_types); %fill in all the parameters from the dialog boxes using helper function
end


%% PRIVATE HELPER FUNCTION

% wrapper function to make an input dialog
function analysis_settings = makeInputDlg(title,prompts,default)
    analysis_settings = inputdlg(prompts,title,[1 40],default); 
end

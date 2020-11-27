function [remove_Pixels,skip_frame,t0_frame_num,area_frame_num,background_frame_num,...
            H_thresh_low, H_thresh_high,...
            S_thresh_low, S_thresh_high,...
            V_thresh_low, V_thresh_high,...
            output_falsecolor,output_analyzed_frames,output_all_masks,output_black_white_mask,output_animated_plot,...
            area_fit_type] = getUserInput()
        
        % Parameters for area analysis
        analysis_settings = inputdlg({'Remove objects smaller than X pixels 100-1000', ... % will not designate pixels smaller than 'X' as wet/dry (reduces variation)
                                'Skip Frames [1-1000]',... % # of frames skipped between each frame analysis (larger number = faster)
                                'Initial frame above surface',... % first frame where dome is exposed 
                                'Select video frame for area analysis'},'Sample',...  % Frame for defining total area; pick frame after edge 'gravity-driven' dewetting occurs, and once interference patterns begin                                                            
                                [1 50; 1 20;1 20;1 20],{'250','3','40','2500'});

        % Parameters for system type
        analysis_type = inputdlg({'New or old software?(1=New,0=Old)',... % Old uEye Cockpit laptop software or New Thorcam software from 2/25/2020 onwards
                          'Lubricin or Water?(1=lubricin, 0=water)',... % Which sample are you measuring dewetting on?
                          'Circle or freehand area fit? (1=circle, 0=freehand)'},... % the area selection method for defining total area
                          'Analysis Type', [1 40; 1 40; 1 40], {'1','1','1'});                                 

        % Parameters for desired outputs
        video_output_types = inputdlg({ 'Falsecolor final output? (1=no, 0=yes) ',... % makes a falsecolor overlay of the binary mask on the original frame          
                          'Output analyzed frames?(1=no, 0=yes)',... % makes a copy of the analyzed frames from the original video
                          'Output individual masks video?(1=no, 0=yes)',... % makes a montage copy of the individual masks for debugging purposes
                          'Output black/white mask?(1=no,0=yes)',... % binary version of final mask
                          'Output animated plot? (1=no, 0=yes)'},... % animated video of the dewetting plot
                          'Output video types (note: choosing yes on any of these will be slower)', [1 40; 1 40; 1 40; 1 40; 1 40], {'1','1','1','1','1'});
                      
                      
        % Initialize our parameters from the dialog boxes
        [remove_Pixels,skip_frame,t0_frame_num,area_frame_num,background_frame_num,...
            sftwre_type,liquid_type,area_fit_type,...
            output_falsecolor,output_analyzed_frames,output_all_masks,output_black_white_mask,output_animated_plot] = fillParams(analysis_settings,analysis_type,video_output_types); %fill in all the parameters from the dialog boxes using helper function

        % Theshold values for hue, saturation, value analysis (use Threshold Check or Matlab "Color Thresholder" App to test values)
        [H_thresh_low, H_thresh_high, ...
            S_thresh_low, S_thresh_high, ...
            V_thresh_low, V_thresh_high] = getThresh(sftwre_type,liquid_type);
        
end
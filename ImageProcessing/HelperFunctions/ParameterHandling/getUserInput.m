%% FUNCTION
% return a structure containing analysis parameters and output parameters based on user input

% OUTPUTS
    % params: struct containing user-specified processing parameters
    % outputs: struct containing user-specified desired output videos

function [params,output] = getUserInput()
        
        % Parameters for area analysis
        analysis_settings = inputdlg({'Remove objects smaller than X pixels 100-1000', ... % will not designate pixels smaller than 'X' as wet/dry (reduces variation)
                                'Skip Frames [1-1000]',... % # of frames skipped between each frame analysis (larger number = faster)
                                'Initial frame above surface',... % first frame where dome is exposed 
                                'Select video frame for area analysis'},'Sample',...  % Frame for defining total area; pick frame after edge 'gravity-driven' dewetting occurs, and once interference patterns begin                                                            
                                [1 50; 1 20;1 20;1 20],{'250','3','40','2500'});

        % Parameters for system type
        analysis_type = inputdlg({'Circle or freehand area fit? (1=circle, 0=freehand)'},... % total area selection method
                          'Analysis Type', [1 40], {'1'});                            

        % Parameters for desired outputs
        video_output_types = inputdlg({ 'Falsecolor final output? (1=no, 0=yes) ',... % makes a falsecolor overlay of the binary mask on the original frame          
                          'Output analyzed frames?(1=no, 0=yes)',... % makes a copy of the analyzed frames from the original video
                          'Output individual masks video?(1=no, 0=yes)',... % makes a montage copy of the individual masks for debugging purposes
                          'Output black/white mask?(1=no,0=yes)',... % binary version of final mask
                          'Output animated plot? (1=no, 0=yes)'},... % animated video of the dewetting plot
                          'Output video types (note: choosing yes on any of these will be slower)', [1 40; 1 40; 1 40; 1 40; 1 40], {'1','1','1','1','1'});
                      
              
        % Initialize our parameters from the dialog boxes
        [remove_Pixels,skip_frame,t0_frame_num,area_frame_num,background_frame_num,area_fit_type,...
            output_falsecolor,output_analyzed_frames,output_all_masks,output_black_white_mask,output_animated_plot] = fillParams(analysis_settings,analysis_type,video_output_types); %fill in all the parameters from the dialog boxes using helper function
        
        
        % make a struct to hold all of our processing parameters
        field1 = 'rm_pix';  val1 = remove_Pixels;
        field2 = 'skip';  val2 = skip_frame;
        field3 = 't0';  val3 = t0_frame_num;
        field4 = 'area';  val4 = area_frame_num;
        field5 = 'bg';  val5 = background_frame_num;
        field6 = 'fit_type';  val6 = area_fit_type;
        
        params = struct(field1,val1,field2,val2,field3,val3,field4,val4,field5,val5,...
                        field6,val6);
                    
        field1 = 'falsecolor'; val1 = output_falsecolor;
        field2 = 'analyzed'; val2 = output_analyzed_frames;
        field3 = 'masks'; val3 = output_all_masks;
        field4 = 'bw_mask'; val4 = output_black_white_mask;
        field5 = 'animated_plot'; val5 = output_animated_plot;       
        
        output = struct(field1,val1,field2,val2,field3,val3,field4,val4,field5,val5);
        
end
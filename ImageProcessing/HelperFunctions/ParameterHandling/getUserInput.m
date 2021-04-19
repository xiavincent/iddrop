% return a structure containing analysis parameters and output parameters based on user input
%% Outputs
% params: struct containing user-specified processing parameters
% outputs: struct containing user-specified desired output videos

%%
function [params,outputs] = getUserInput()
        
        % Parameters for area analysis
        analysis_settings = inputdlg({'Remove objects smaller than X pixels 100-1000', ... % will not designate pixels smaller than 'X' as wet/dry (reduces variation)
                                'Skip Frames [1-1000]',... % # of frames skipped between each frame analysis (larger number = faster)
                                'Initial frame above surface',... % first frame where dome is exposed 
                                'Select video frame for area analysis',... % frame for defining total area; pick frame after edge 'gravity-driven' dewetting occurs, and once interference patterns begin              
                                'Freehand, ellipse, or circle area fit? (1=freehand, 2=ellipse, 3=circle)'},...
                                'Sample',[1 50; 1 20; 1 20; 1 20; 1 40],{'250','3','40','2500','1'});

        % Parameters for thresholding
        threshold_values = inputdlg({'Hue low threshold','Hue high threshold',...
                                     'Saturation low threshold','Saturation high threshold',...
                                     'Value low threshold','Value high threshold'},...
                                     'HSV thresholding',[1 50; 1 50; 1 50; 1 50; 1 50; 1 50],{'1','1','1','1','1','1'});

        % Parameters for desired outputs
        video_output_types = inputdlg({ 'Falsecolor final output? (1=no, 0=yes) ',... % makes a falsecolor overlay of the binary mask on the original frame          
                          'Output analyzed frames?(1=no, 0=yes)',... % makes a copy of the analyzed frames from the original video
                          'Output individual masks video?(1=no, 0=yes)',... % makes a montage copy of the individual masks for debugging purposes
                          'Output black/white mask?(1=no,0=yes)',... % binary version of final mask
                          'Output animated plot? (1=no, 0=yes)'},... % animated video of the dewetting plot
                          'Output video types (note: choosing yes on any of these will be slower)', [1 40; 1 40; 1 40; 1 40; 1 40], {'1','1','1','1','1'});
                      
                      
              
        % Initialize our parameters from the dialog boxes
        [remove_Pixels,skip_frame,t0_frame_num,area_frame_num,background_frame_num,...
            area_fit_type,...
            output_falsecolor,output_analyzed_frames,output_all_masks,output_black_white_mask,output_animated_plot] = fillParams(analysis_settings,analysis_type,video_output_types); %fill in all the parameters from the dialog boxes using helper function

        % Theshold values for hue, saturation, value analysis (use Threshold Check or Matlab "Color Thresholder" App to test values)
        [H_thresh_low, H_thresh_high, ...
            S_thresh_low, S_thresh_high, ...
            V_thresh_low, V_thresh_high] = _________ % TODO: turn into input dialog 
        
%         getThresh(sftwre_type,liquid_type);
        

 % From 07-05-20 HPL3 DIWater Test 2 file
%             H_thresh_low = 0;
%             H_thresh_high = 1;
%             S_thresh_low = 0;
%             S_thresh_high = 1;
%             V_thresh_low = 0.659;
%             V_thresh_high = 1;
% 
%         elseif liquid_type == 1 %lubricin
% 
%           % For Feb 8, 2021 videos
%             H_thresh_low = .408;
%             H_thresh_high = .586;
%             S_thresh_low = 0.16;
%             S_thresh_high = 0.309;
%             V_thresh_low = 0.808;
%             V_thresh_high = 1;
        
        % make a struct to hold all of our processing parameters
        field1 = 'rm_pix';  val1 = remove_Pixels;
        field2 = 'skip';  val2 = skip_frame;
        field3 = 't0';  val3 = t0_frame_num;
        field4 = 'area';  val4 = area_frame_num;
        field5 = 'bg';  val5 = background_frame_num;
        field6 = 'fit_type';  val6 = area_fit_type;
        field7 = 'H_low'; val7 = H_thresh_low;
        field8 = 'H_high';  val8 = H_thresh_high;
        field9 = 'S_low';  val9 = S_thresh_low;
        field10 = 'S_high';  val10 = S_thresh_high;
        field11 = 'V_low';  val11 = V_thresh_low;
        field12 = 'V_high';  val12 = V_thresh_high;
        
        params = struct(field1,val1,field2,val2,field3,val3,field4,val4,field5,val5,...
                        field6,val6,field7,val7,field8,val8,field9,val9,field10,val10,...
                        field11,val11,field12,val12);
                    
        field1 = 'falsecolor'; val1 = output_falsecolor;
        field2 = 'analyzed'; val2 = output_analyzed_frames;
        field3 = 'masks'; val3 = output_all_masks;
        field4 = 'bw_mask'; val4 = output_black_white_mask;
        field5 = 'animated_plot'; val5 = output_animated_plot;       
        
        outputs = struct(field1,val1,field2,val2,field3,val3,field4,val4,field5,val5);
        
        
        
end
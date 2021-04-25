% return a structure containing analysis parameters and output parameters based on user input
%% Outputs
% params: struct containing user-specified processing parameters
% outputs: struct containing user-specified desired output videos

%%
function [params,outputs] = getUserInput(varargin)        

        dlg_num = 1;
        if (nargin ~= 0) % if the user passed any parameters
            defaults = getDefaults(dlg_num,varargin{1}); % get default values for input dialog from the first parameter passed
        else
            defaults = getDefaults(dlg_num); % get default values for input dialog
        end
        sizes = [1 50; 1 20; 1 20; 1 20; 1 40];
        
        % Parameters for area analysis
        analysis_settings = inputdlg({'Remove objects smaller than X pixels 100-1000', ... % will not designate pixels smaller than 'X' as wet/dry (reduces variation)
                                'Skip Frames [1-1000]',... % # of frames skipped between each frame analysis (larger number = faster)
                                'Initial frame above surface',... % first frame where dome is exposed 
                                'Select video frame for area analysis',... % frame for defining total area; pick frame after edge 'gravity-driven' dewetting occurs, and once interference patterns begin              
                                'Freehand, ellipse, or circle area fit? (1=freehand, 2=ellipse, 3=circle)'},...
                                'Sample',sizes,defaults);
                            
                            
        dlg_num = 2;
        if (nargin ~= 0)
            defaults = getDefaults(dlg_num,varargin{1}); % get default values for input dialog
        else
            defaults = getDefaults(dlg_num); % get default values for input dialog
        end
        sizes = [1 50; 1 50; 1 50; 1 50; 1 50; 1 50]; % sizes for dialog box entries

        % Parameters for thresholding
        threshold_values = inputdlg({'Hue low threshold','Hue high threshold',...
                                     'Saturation low threshold','Saturation high threshold',...
                                     'Value low threshold','Value high threshold'},...
                                     'HSV thresholding (values from 0-1)',sizes,defaults);

                                 
        dlg_num = 3;
        if (nargin ~= 0)
            defaults = getDefaults(dlg_num,varargin{1}); % get default values for input dialog
        else
            defaults = getDefaults(dlg_num); % get default values for input dialog
        end
        sizes = [1 40; 1 40; 1 40; 1 40; 1 40]; % sizes for dialog box entries
        
        % Parameters for desired outputs
        video_output_types = inputdlg({ 'Falsecolor final output? (1=no, 0=yes) ',... % makes a falsecolor overlay of the binary mask on the original frame          
                                      'Output analyzed frames?(1=no, 0=yes)',... % makes a copy of the analyzed frames from the original video
                                      'Output individual masks video?(1=no, 0=yes)',... % makes a montage copy of the individual masks for debugging purposes
                                      'Output black/white mask?(1=no,0=yes)',... % binary version of final mask
                                      'Output animated plot? (1=no, 0=yes)'},... % animated video of the dewetting plot
                                      'Output video types (note: choosing yes on any of these will be slower)',...
                                       sizes,defaults);                      
              
        % Initialize our parameters from the dialog boxes
        [remove_Pixels,skip_frame,t0_frame_num,...
            area_frame_num,area_fit_type,...
            output_falsecolor,output_analyzed_frames,output_all_masks,...
            output_black_white_mask,output_animated_plot]... 
            = fillParams(analysis_settings,video_output_types); % fill in all the parameters from the dialog boxes using helper function

        % Theshold values for hue, saturation, value analysis (use Threshold Check or Matlab "Color Thresholder" App to test values)
        [H_thresh_low, H_thresh_high, ...
            S_thresh_low, S_thresh_high, ...
            V_thresh_low, V_thresh_high] = getThresh(threshold_values); % fills in threshold values based on user input
                
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
        field5 = 'fit_type';  val5 = area_fit_type;
        field6 = 'H_low'; val6 = H_thresh_low;
        field7 = 'H_high';  val7 = H_thresh_high;
        field8 = 'S_low';  val8 = S_thresh_low;
        field9 = 'S_high';  val9 = S_thresh_high;
        field10 = 'V_low';  val10 = V_thresh_low;
        field11 = 'V_high';  val11 = V_thresh_high;
        
        params = struct(field1,val1,field2,val2,field3,val3,field4,val4,field5,val5,...
                        field6,val6,field7,val7,field8,val8,field9,val9,field10,val10,...
                        field11,val11);
                    
        field1 = 'falsecolor'; val1 = output_falsecolor;
        field2 = 'analyzed'; val2 = output_analyzed_frames;
        field3 = 'masks'; val3 = output_all_masks;
        field4 = 'bw_mask'; val4 = output_black_white_mask;
        field5 = 'animated_plot'; val5 = output_animated_plot;       
        
        outputs = struct(field1,val1,field2,val2,field3,val3,field4,val4,field5,val5);
        
end


%%  PRIVATE HELPER FUNCTION

function def = getDefaults(varargin) % high-level helper function to handle default value filling
    if (varargin{1} == 1) % analysis_settings
        if (nargin == 2) % if the params struct was passed into the function
            def = getDefAnalys(varargin{2}); % populate the default cell array with the pre-existing values
        else
            def = {'250','30','80','2000','1'}; % values: params.rm_pix, params.skip, params.t0, params.area, params.fit_type
        end
    elseif (varargin{1} == 2) % threshold values
        if (nargin == 2) % if the params struct already exists inside the workspace
            def = getDefThresh(varargin{2}); % populate the default cell array with the pre-existing values
        else
            def = {'0','1','0','1','0','1'}; % values: params.rm_pix, params.skip, params.t0, params.area, params.fit_type
        end
    elseif (varargin{1} == 3)
        def = {'1','1','1','1','1'}; % values: output.falsecolor, output.analyzed, output.masks, output.bw_mask, output.animated_plot
    end
end

function def = getDefAnalys(params)
    rm_pix = num2str(params.rm_pix);
    skip = num2str(params.skip);
    t0 = num2str(params.t0);
    area = num2str(params.area);
    fit_type = num2str(params.fit_type);
    
    def = {rm_pix,skip,t0,area,fit_type};
end

function def = getDefThresh(params)
    H_low = num2str(params.H_low);
    H_high = num2str(params.H_high);
    S_low = num2str(params.S_low);
    S_high = num2str(params.S_high);
    V_low = num2str(params.V_low);
    V_high = num2str(params.V_high);
    
    def = {H_low,H_high,S_low,S_high,V_low,V_high};
    
end


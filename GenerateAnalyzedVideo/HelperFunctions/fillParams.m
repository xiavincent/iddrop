%  Return a struct containing the parameters from an input dialog
function [params] = fillParams(input_dialog) 
   params = struct; % make a struct to hold the parameters
   params.skip = str2double(input_dialog{1}); % how many frames we skip before saving another frame
   params.t0 = str2double(input_dialog{2}); % start of video, when the dome breaks the surface
   params.fr = str2double(input_dialog{3}); % output frame rate
   
   params.shorten = str2double(input_dialog{4}); % whether or not we crop the video length to 10min
end
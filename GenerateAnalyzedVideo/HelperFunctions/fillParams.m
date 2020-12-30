% Initialize parameters from dialog boxes and return a struct containing the parameters
function [params] = fillParams(input_dialog)
   skip_frame = str2double(input_dialog{1}); % convert inputs to scalar values
   t0 = str2double(input_dialog{2}); 
   
   params = struct; % make a struct to hold the variables
   params.skip = skip_frame;
   params.t0 = t0;
end
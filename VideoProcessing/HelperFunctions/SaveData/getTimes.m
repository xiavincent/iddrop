%% FUNCTION
% get the corresponding times to our area analysis
function [raw_time,graph_time] = getTimes(num_iterations,params,frame_rate)
    final_frame_num = (num_iterations-1)*params.skip + params.t0;
    analy_frame_nums = params.t0 : params.skip : final_frame_num; % set raw video time 
    raw_time = analy_frame_nums/frame_rate; %adjusts time for skipped frames and initial frame rate
    graph_time = raw_time - params.t0/frame_rate; % time after t0
end
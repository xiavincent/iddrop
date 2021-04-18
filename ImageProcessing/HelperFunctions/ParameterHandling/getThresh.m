% get thresholding parameters based on software and sample type
function [H_thresh_low, H_thresh_high, S_thresh_low, S_thresh_high, V_thresh_low, V_thresh_high] = getThresh(sftwre_type,liquid_type)
    if sftwre_type == 0  %Old uEye Cockpit software
        if liquid_type == 1 %DI water
            % Used "DIWater HPL3 RT2" file from 2-21-2020, frame 1000 to obtain
            % threshold values  
            H_thresh_low = 0;
            H_thresh_high = 1;
            S_thresh_low = 0;
            S_thresh_high = 1;
            V_thresh_low = 0.7;
            V_thresh_high = 1;   
        elseif liquid_type == 0 %lubricin    
            %Used ".5 ugml lubricin DS HPL 2 37C 1" from 1-20-2020,frame 2085
            %to obtain threshold values
            H_thresh_low = .4;
            H_thresh_high = .5;
            S_thresh_low = .3;
            S_thresh_high = .4;
            V_thresh_low = 0.7;
            V_thresh_high = 1;
        end
    elseif sftwre_type == 1 %New Thorcam software
        if liquid_type == 0 %DI Water

            % From 07-05-20 HPL3 DIWater Test 2 file
            H_thresh_low = 0;
            H_thresh_high = 1;
            S_thresh_low = 0;
            S_thresh_high = 1;
            V_thresh_low = 0.659;
            V_thresh_high = 1;

        elseif liquid_type == 1 %lubricin

          % For Feb 8, 2021 videos
            H_thresh_low = .408;
            H_thresh_high = .586;
            S_thresh_low = 0.16;
            S_thresh_high = 0.309;
            V_thresh_low = 0.808;
            V_thresh_high = 1;
        end 
    end
end
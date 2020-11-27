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

      %      For 08-12-20 1 ugmL HPL3 RT solvent trap
    %         hueThresholdLow = .438;
    %         hueThresholdHigh = .535;
    %         saturationThresholdLow = .177;
    %         saturationThresholdHigh = .236;
    %         valueThresholdLow = .718;
    %         valueThresholdHigh = .906;


        % For 07-19-20 .5 ugmL HPL1 NR (less discriminatory)
    %         hueThresholdLow = .410;
    %         hueThresholdHigh = .554;
    %         saturationThresholdLow = .104;
    %         saturationThresholdHigh = .271;
    %         valueThresholdLow = .439;
    %         valueThresholdHigh = .780;


            % For 10-13-20 1 ugmL lubricin TS HPL4 37C
            H_thresh_low = .422;
            H_thresh_high = .500;
            S_thresh_low = .104; %.164 <--- saturation boundaries have a substantial impact on video thresholding!
            S_thresh_high = .271; %.233
            V_thresh_low = .490; %.490
            V_thresh_high = .761; %.761
        end 
    end
end
%% FUNCTION
% Close video reader objects based on parameters specified in output
% INPUT: 'output' is a struct specifying which videos to output
%        'output_vids' is a struct containing the VideoWriter objects for the videos

function closeVids(output,output_vids)
    if (~output.bw_mask)
        close(output_vids.bw); %close videowriter for binary mask
    end
    if (~output.analyzed)
        close(output_vids.analyzed); %close analyzed frames video
    end
    if(~output.masks)
        close(output_vids.masks); %close individual masks video
    end
    if (~output.falsecolor)
        close(output_vids.falsecolor); %close falsecolor video
    end
end
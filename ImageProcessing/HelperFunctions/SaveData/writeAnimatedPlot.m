function writeAnimatedPlot(file_name_short,output_framerate,area_data_output)
    % write an animated plot of the wet area data
    
    fhandle = makeBlankAreaPlot();
    
    animated_vid=VideoWriter(strcat(file_name_short,'_plot'),'MPEG-4');
    animated_vid.FrameRate = output_framerate;
    open(animated_vid);
    for entry=1:length(area_data_output) % iterate through each data point
        time = area_data_output(2,entry);
        area = area_data_output(3,entry);
        plot(time,area,'o',... % plot the graph time and the wet area 
                'MarkerSize',5,...
                'MarkerEdgeColor','b'); % marker color = blue

        writeVideo(animated_vid,getframe(gcf));
    end
    close(animated_vid); % end the video
    close(fhandle); % close the figure

end
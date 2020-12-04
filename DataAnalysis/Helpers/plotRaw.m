function plotRaw(area_data)

    time_data = area_data(:,2);
    wet_area_data = area_data(:,3);

    %Figure formatting
    figure, hold on 
    xlim([0 600]);
    ylim([0 1.2]);
    xlabel('Time (s)','FontSize' , 28,'FontName'   , 'Arial')
    ylabel('Wet Area / Total Area','FontSize' , 20,'FontName'   , 'Arial')
    set(gca,'FontName', 'Arial','FontSize',18);
    set(gcf, 'PaperPositionMode', 'auto');
    box on;

    plot(time_data,wet_area_data,'.');
    print('-depsc2',strcat(fname,'_graph.eps'));
    print('-dtiff',strcat(fname,'_graph.tiff'));

end
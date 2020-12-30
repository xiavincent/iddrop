%Format the area plot to output
function figure_handle = makeBlankAreaPlot() 

    figure_handle = figure('Name','Area Plot');
    hold on;
    
    xlim([0 600]);
    ylim([0 1.2]);
    xlabel('Time (s)','FontSize' , 28,'FontName'   , 'Arial');
    ylabel('Wet Area / Total Area','FontSize' , 20,'FontName'   , 'Arial');
    set(gca,'FontName', 'Arial','FontSize',18);
    set(gcf, 'PaperPositionMode', 'auto');
    box on;
    
end
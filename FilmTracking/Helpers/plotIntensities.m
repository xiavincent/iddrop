%% FUNCTION
% plot the intensities vs time, where point is a struct containing the intensity data
% return the graph as a movie frame
function [fig,axes] = plotIntensities(data) 
    fig = figure;
    axes = gca;
    
    set(gcf, 'Position', [1, 1, 1024, 768]); % increase figure size

    hold on
    plot(data.time,data.RGB(1,:),'r'); % plot red channel intensity
    plot(data.time,data.RGB(2,:),'g'); % plot green channel intensity
    plot(data.time,data.RGB(3,:),'b'); % plot blue channel intensity
    xlabel('time (s)')
    ylabel('Intensity')
    legend('Red','Green','Blue','AutoUpdate','off')
    title('RGB intensities vs time')
    
end
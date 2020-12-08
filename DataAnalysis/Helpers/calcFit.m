function result = calcFit(fname,time,area,begin,stop) % calculate the line of best fit and return

    result = struct; % struct to hold analysis results

    x_seg = time(begin:stop); % x values of segment of interest
    y_seg = area(begin:stop); % y values of segment of interest
      
    result.polynom = polyfit(x_seg,y_seg,1); % get polynomial fit
    result.yfit = polyval(result.polynom, time); % calculate y values from line of best fit across entire time span
    result.yfit_seg = polyval(result.polynom, x_seg); % calculate y values in segment of interest
    result.DOT = roots([result.polynom(1), result.polynom(2)-1]); % find intersection of polynomial with the line y = 1    
    result.R2 = calcResid(y_seg,result.yfit_seg); % calculate R^2 value on segment of interest
    
    plotFit(fname,time,area,result)
   
end

function R2 = calcResid(y,y_calc) % calculate coefficient of determination (R^2)
    yresid = y - y_calc;
    SSresid = sum(yresid.^2); % sum of squares of residuals
    SStotal = (length(y) - 1) * var(y); % total sum of squares (proportional to variance)
    R2 = 1 - SSresid/SStotal;
end


function plotFit(fname,time,area,result)

    fig = figure('Name','Fitted Data');
    hold on
    box on

    x_max = 600; % set figure bounds
    y_max = 1.2;
    xlim([0 x_max]);
    ylim([0 y_max]);
    
    font_size = 20;
    xlabel('Time (s)','FontSize',font_size); % add axis titles
    ylabel('Wet Area / Total Area','FontSize',font_size);
    
    ax = gca; % format axes
    ax.FontSize = 18;
    ax.FontName = 'Arial';
    
    plot(time,area,'.',...
        time,result.yfit); % plot line of best fit and original data  
    yline(1,'--','max area'); % horizontal line y = 1
    annotate(result.DOT,result.polynom,y_max); % annotate the plot
    
    print(fig,strcat(fname,'_fit.pdf'),'-dpdf'); % save as pdf file
    
end


function annotate(DOT,polynomial,y_max) % annotate figure with line labels

    plot(DOT,1,'r*',... % plot intersection point
    'MarkerSize',10); 

    txt = ['\downarrow Dewetting Onset Time: ' num2str(DOT) 's']; % annotation for DOT point
    x = DOT;
    y = 1 + .05/y_max;
    text(x,y,txt);
    
    txt = sprintf('Dewetting line: y = %.3g*x + %.3g', polynomial(1), polynomial(2));
    text(x,y+.04/y_max,txt); % annotation for line equation
    
    
end
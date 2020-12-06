function result = getDOT(fname, params, time, area)

    if (params.dewet == 1) % video dewets
        while (1) % loop
            params = getBounds(params); % user-specified lower and upper bounds 

            % find the starting and stopping indices
            delay = 0; % define delay time point after which you want to start the analysis
            
%             area_indices = intersect(find(area < params.ubound),find(area > params.lbound)); % region of dewetting group in between bounds
            time_indices = find(time > delay); % region past delay point
            below_ub = intersect(find(area < params.ubound),time_indices); % find indices where area dips below upper bound
            below_lb = intersect(find(area < params.lbound),time_indices);  % find indices where area dips below the lower bound
            
            begin = min(below_ub); % find first index where area dips below upper bound
            stop = min(below_lb); % find first index where area dips below lower bound
            
            calcFit(time,area,begin,stop); % calculate line of best fit
            
            answer = questdlg('Redo fit?', 'Confirm DOT', 'Yes','No','No'); % two options, with 'No' set as default
            switch answer % exit loop based on user input
                case 'No'
                    break;
                case '' % user doesn't give a response
                    break; 
                case 'Yes' % reperform bound fitting
            end  
            
        end     
    else % video doesn't dewet      
        disp('Dewetting does not occur.');
    end

end

% fills in the lower and upper bounds on the params struct based on user input
function params = getBounds(params)
    
    data_processing = inputdlg({'Select upper bound',...
                                'Select lower bound'},...
                                'DOT fit bounds',...
                                [1 20; 1 20],{'0.97','0.90'});

    params.ubound = str2double(data_processing{1}); %gets this from input dialog
    params.lbound = str2double(data_processing{2}); %gets this from input dialog
   
end


function calcFit(time,area,begin,stop) % calculate the line of best fit and return


    x = time(begin:stop); % use this to calculate a one parameter linear regression
    X = [ones(length(x),1), x]; % use this to calculate a two parameter linear regression
    y = area(begin:stop); % y values of line of interest
    
    
    polynom = polyfit(x,y,1);
    y_fit = polyval(polynom, time); % calculate y values from line of best fit
    figure
    y_flat = ones(size(time)); % flat line at y = 1
    plot(time,area,'o',...
        time,y_fit,...
        time,y_flat,'--'); % plot line of best fit and original data
    
    % calculate R^2 = 1 - SSres/SStot
    

    

%     beta = X\y; % coefficients of the linear regression 
%                 % beta(1) stores the y-intercept term. beta(2) stores the slope term. S
%                 % See Matlab linear regression documentation)   
%     y_calc = X*beta; % calculate area values of line of best fit using matrix multiplication
% 
%     figure;
%     plot(x,y_calc);
% 
%     
%     DOT = (1-beta(1))/beta(2); % solve to find the line's intersection with area = 1
%     disp(['The dewetting onset time is ', num2str(DOT), ' seconds.']);
% 
%     Rsq = 1 - sum((y - y_calc).^2)/sum((y - mean(y)).^2);
%     disp(['The R-squared value for the linear fit is ', num2str(Rsq),'.']);
%     
%     plotFit(fname, x, y_calc);  % plot fitted data
  
end




function plotFit(fname, x, y_calc)

    figure, hold on 
    xlim([0 600]);
    ylim([0 1.2]);
    xlabel('Time (s)','FontSize', 28,'FontName' , 'Arial')
    ylabel('Wet Area / Total Area','FontSize' , 20,'FontName', 'Arial')
    set( gca,'FontName', 'Arial','FontSize',18);
    set(gcf, 'PaperPositionMode', 'auto');
    box on;

    plot(time,area,'.')
    plot(x,y_calc,'c-','LineWidth',2);
    print(strcat(fname,'_fit.pdf'),'-dpdf'); % save as pdf file

  
end
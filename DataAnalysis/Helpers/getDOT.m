function getDOT(fname, params, time, area)

    if (params.dewet == 1) % video dewets
        while (1)
            params = getBounds(params); % user-specified lower and upper bounds 

            % find the starting and stopping indices
            delay = 0; % define delay time point after which you want to start the analysis
            begin = find(area < params.ubound) && find(time > delay); % perform a short-circuit 'and' between the valid indices
            stop = find(area < params.lbound) && find(time > delay);
            
            x = time(begin:stop); % use this to calculate a one parameter linear regression
            X = [ones(length(x),1), x]; % use this to calculate a two parameter linear regression
            y = area(begin:stop); % y values of line of interest
            
            beta = X\y; % coefficients of the linear regression (see Matlab linear regression documentation)           
            y_calc = X*beta; % calculate area values of line of best fit using matrix multiplication
            
            figure;
            plot(x,y_calc);
            
%             plotFit(fname, x, y_calc);  % plot fitted data and display dewetting onset time
            
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
function getBounds(params)
    data_processing = inputdlg({'Select upper bound',...
                                'Select lower bound'},...
                                'DOT fit bounds',...
                                [1 20; 1 20],{'0.97','0.8'});

    params.ubound = str2double(data_processing{1}); %gets this from input dialog
    params.lbound = str2double(data_processing{2}); %gets this from input dialog
   
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
    print(strcat(fname,'_graph_fit'),'-dpdf'); % save as pdf file

    DOT = (1-fit(1))/fit(2);
    disp(['The dewetting onset time is ', num2str(DOT), ' s.'])

    Rsq = 1 - sum((dewetting_y - y_calc).^2)/sum((dewetting_y - mean(dewetting_y)).^2);
    disp(['The R-squared value for the linear fit is ', num2str(Rsq),'.'])
    
end
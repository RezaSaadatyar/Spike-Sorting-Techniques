%% =============================================================================================
% ================================= Spike Extraction Software ==================================
% ================================ Presented by: Reza Saadatyar ================================
% ============================== Email: Reza.Saadatyar@outlook.com =============================
% ======================================= 2019-2020 ============================================

function plot_autogram(Autoc, Xbin, plotautogram, maxnInte, minInte, bin, ax23, ax24, cm)
% This function plots autocorrelograms for spike data.
% Inputs:
%   Autoc: Autocorrelogram data
%   Xbin: Time bins for the autocorrelogram
%   plotautogram: Handle to the checkbox for plotting autocorrelograms
%   maxnInte: Handle to the maximum interval input
%   minInte: Handle to the minimum interval input
%   bin: Handle to the bin size input
%   ax23: Handle to the primary axes for plotting
%   ax24: Handle to the secondary axes for multi-unit plotting
%   cm: Context menu for the axes

% Prepare the axes for plotting
ax23.NextPlot = 'replaceall';  % Clear the axes before plotting
cla(ax23);  % Clear the current axes
subplot(1, 1, 1, 'replace', 'Parent', ax24);  % Set up the subplot

% Check if the autocorrelogram plot checkbox is selected
if get(plotautogram, 'value')

    % Get the bin size and interval limits from the input
    Bin = str2double(get(bin, 'string'));  % Bin size
    Min_Interval = str2double(get(minInte, 'string'));  % Minimum interval
    Max_Interval = str2double(get(maxnInte, 'string'));  % Maximum interval

    % Check if autocorrelogram data is available
    if Autoc == 0 % Show warning if no autocorrelogram data
        msgbox('Please Set Parameters in Section ISI & Autocorrelogram', '', 'warn');  
        return;
    end

    % Check if the bin size is valid
    if isnan(Bin) || (Bin <= 0)
        msgbox('Please Enter Bin > 0', '', 'warn');  % Show warning if bin size is invalid
        return;
    end

    % Check if the minimum interval is valid
    if isnan(Min_Interval) || (Min_Interval < 0)
        msgbox('Please Enter Min_Interval >= 0', '', 'warn');  % Show warning if minimum interval is invalid
        return;
    end

    % Check if the maximum interval is valid
    if isnan(Max_Interval) || (Max_Interval < 0) || (Max_Interval <= Min_Interval)
        msgbox('Please Enter Max_Interval > Min_Interval', '', 'warn');  % Show warning if maximum interval is invalid
        return;
    end

    % Plot for single unit data
    if size(Autoc, 1) < 2
        % Plot the autocorrelogram
        bar(ax23, Xbin, Autoc, 'FaceColor', 'k', 'EdgeColor', 'k');
        
        % Label the axes and add a title
        xlabel(ax23, 'Time (ms)');
        ylabel(ax23, 'Number of Spikes');
        title(ax23, ['Autocorrelograms; bin = ' num2str(Bin * 1000) ' ms']);
        
        % Set font properties for the axes
        ax23.FontWeight = 'bold';
        ax23.FontName = 'Times New Roman';
        ax23.FontSize = 10;
    end

    % Plot for multi-unit data
    if size(Autoc, 1) > 1
        % Plot the autocorrelogram for the first unit
        bar(ax23, Xbin, Autoc(1, :), 'FaceColor', 'k', 'EdgeColor', 'k');
        
        % Label the axes and add a title
        title(ax23, ['Autocorrelograms for multi Units; bin = ' num2str(Bin * 1000) ' ms']);
        xlabel(ax23, 'Time (ms)');
        ylabel(ax23, 'Spikes/Sec');
        
        % Set font properties for the axes
        ax23.FontWeight = 'bold';
        ax23.FontName = 'Times New Roman';
        ax23.FontSize = 10;

        % Prepare for multi-unit plotting
        subplot(1, 1, 1, 'replace', 'Parent', ax24);
        Ma = max(max(Autoc(2:end, :)));  % Find the maximum autocorrelogram value for scaling

        % Loop through each unit and plot its autocorrelogram
        for i = 2:size(Autoc, 1)
            p(i - 1) = subplot(size(Autoc, 1) - 1, 1, i - 1);  % Create subplot for each unit
            bar(p(i - 1), Xbin, Autoc(i, :), 'FaceColor', 'k', 'EdgeColor', 'k');
            
            % Label the y-axis and add a legend
            ylabel('Spikes/Sec');
            legend(['Uint ', num2str(i - 1)]);
            
            % Set font properties for the subplot
            ax = gca;
            ax.FontWeight = 'bold';
            ax.FontName = 'Times New Roman';
            ax.FontSize = 10;
            
            % Remove x-axis ticks for all but the last subplot
            if i ~= size(Autoc, 1)
                ax.XTick = [];
            end
            
            % Add title for the first subplot
            if i == 2
                title(['Autocorrelograms, bin = ' num2str(Bin * 1000) ' ms']);
            end
            
            % Set y-axis limits
            ylim([0 Ma + 1]);
        end
    end

    % Label the x-axis for the last subplot
    xlabel('Time (ms)');

    % Attach context menus to the plots and axes
    set(ax23, 'uicontextmenu', cm);
    set(p, 'uicontextmenu', cm);

    % Notify the user that the operation is completed
    msgbox('Operation Completed');
end
end
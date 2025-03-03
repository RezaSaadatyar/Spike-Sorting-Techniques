%% =============================================================================================
% ================================= Spike Extraction Software ==================================
% ================================ Presented by: Reza Saadatyar ================================
% ============================== Email: Reza.Saadatyar@outlook.com =============================
% ======================================= 2019-2020 ============================================

function plot_firing_rate(Firing_Rate, Time_Firing, binTime, binFR, ax19, ax20, cm, S)
% This function plots the firing rate histograms for spike data.
% Inputs:
%   Firing_Rate: Firing rate data
%   Time_Firing: Time bins for the firing rate data
%   binTime: Handle to the time unit selection (seconds, minutes, hours)
%   binFR: Handle to the bin size input for firing rate
%   ax19: Handle to the primary axes for plotting
%   ax20: Handle to the secondary axes for multi-unit plotting
%   cm: Context menu for the plot
%   S: Structure containing GUI settings (e.g., spikepersec checkbox)

% Prepare the axes for plotting
ax19.NextPlot = 'replaceall';  % Clear the axes before plotting
subplot(1, 1, 1, 'replace', 'Parent', ax20);  % Set up the subplot

% Get the bin size for firing rate and convert it to a number
Win = str2double(get(binFR, 'string'));

% Initialize labels and titles
til = 'Time (Second)';  % Default time unit label
ti = ['; bin = ', num2str(Win) ' Sec'];  % Default bin size label
typ = 'Spikes/Sec';  % Default firing rate unit

% Check if firing rate data is available
if Firing_Rate == 0
    msgbox('Please Select Firing Rate parameters', '', 'warn');  % Show warning if no firing rate data
    return;
end

% Check if the bin size is valid
if isnan(Win) || (Win <= 0)
    msgbox('Please Enter Bin > 0', '', 'warn');  % Show warning if bin size is invalid
    return;
end

% Adjust labels and units based on the selected time unit
if get(binTime, 'value') == 3
    til = 'Time (Minute)';  % Change time unit to minutes
    typ = 'Spikes/Min';  % Change firing rate unit to spikes per minute
    ti = ['; bin = ', num2str(Win) ' Min'];  % Update bin size label
elseif get(binTime, 'value') == 4
    til = 'Time (Hour)';  % Change time unit to hours
    typ = 'Spikes/Hour';  % Change firing rate unit to spikes per hour
    ti = ['; bin = ', num2str(Win) ' Hour'];  % Update bin size label
end

% Adjust x-axis scaling and labels based on the "spikepersec" setting
if S.spikepersec.Value == 1
    xlab = 1;  % Use spikes per second
else
    xlab = Win;  % Use counts per bin
    typ = 'Counts/bin';  % Change firing rate unit to counts per bin
    ti = '';  % Remove bin size label
end

% Plot for single unit data
if size(Firing_Rate, 1) < 2
    % Plot the firing rate histogram
    for i = 1:size(Firing_Rate, 1)
        bar(ax19, Time_Firing + Win, Firing_Rate * xlab, 'FaceColor', 'k', 'EdgeColor', 'k');
    end
    
    % Set font properties for the axes
    ax19.FontWeight = 'bold';
    ax19.FontName = 'Times New Roman';
    ax19.FontSize = 10;
    
    % Add title and axis labels
    title(ax19, ['Firing Rate Histograms' ti]);
    xlabel(ax19, til);
    ylabel(ax19, typ);
end

% Plot for multi-unit data
if size(Firing_Rate, 1) > 1
    % Plot the firing rate histogram for the first unit
    bar(ax19, Time_Firing + Win, Firing_Rate(1, :) * xlab, 'FaceColor', 'k', 'EdgeColor', 'k');
    
    % Set font properties for the axes
    ax19.FontWeight = 'bold';
    ax19.FontSize = 10;
    ax19.FontName = 'Times New Roman';
    
    % Add title and axis labels
    title(ax19, ['Firing Rate for all units' ti]);
    xlabel(ax19, til);
    ylabel(ax19, typ);
    
    % Prepare for multi-unit plotting
    subplot(1, 1, 1, 'replace', 'Parent', ax20);
    Ma = max(max(Firing_Rate(2:end, :)));  % Find the maximum firing rate for scaling
    
    % Loop through each unit and plot its firing rate histogram
    for i = 2:size(Firing_Rate, 1)
        p(i - 1) = subplot(size(Firing_Rate, 1) - 1, 1, i - 1);  % Create subplot for each unit
        bar(p(i - 1), Time_Firing + Win, Firing_Rate(i, :) * xlab, 'FaceColor', 'k', 'EdgeColor', 'k');
        
        % Set font properties for the subplot
        ax = gca;
        ax.FontWeight = 'bold';
        ax.FontName = 'Times New Roman';
        ax.FontSize = 10;
        
        % Add title for the first subplot
        if i == 2
            title(['Firing Rate Histograms' ti]);
        end
        
        % Remove x-axis ticks for all but the last subplot
        if i ~= size(Firing_Rate, 1)
            ax.XTick = [];
        end
        
        % Add legend and set y-axis limits
        legend(['Unit ', num2str(i - 1)]);
        ylim([0 Ma * xlab + 2]);
        ylabel(typ);
    end
    
    % Label the x-axis for the last subplot
    xlabel(til);
end

% Attach context menu to the plots
set(ax19, 'uicontextmenu', cm);
set(p, 'uicontextmenu', cm);

% Notify the user that the operation is completed
msgbox('Operation Completed');
end
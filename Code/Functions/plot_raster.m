%% =============================================================================================
% ================================= Spike Extraction Software ==================================
% ================================ Presented by: Reza Saadatyar ================================
% ============================== Email: Reza.Saadatyar@outlook.com =============================
% ======================================= 2019-2020 ============================================

function Raster = plot_raster(xf, index, Labels, fss, plotR, time4, ax14, cm)

% Set axes properties for fresh plotting
ax14.NextPlot = 'replaceall'; % Ensure new plots replace existing ones
cla(ax14); % Clear the axes
axes(ax14); % Set the current axes to ax14
Raster = 0; % Initialize the raster output

% Check if the raster plot option is selected in the GUI
if get(plotR, 'value') ~= 1

    % Check if clustering parameters are set
    if Labels == 0
        msgbox('Please Set Cluster Parameters in Section Clustering', '', 'warn');
        return; % Exit the function if clustering parameters are not set
    end

    % Check if spike detection parameters are set
    if index == 0
        msgbox('Please Set Spike Detection Parameters in Section Spike Detection', '', 'warn');
        return; % Exit the function if spike detection parameters are not set
    end

    % Validate the sampling frequency (fss)
    if isnan(fss) || (fss <= 0)
        % Prompt the user to enter the sampling frequency if it is invalid
        fss = str2double(inputdlg({'Enter Fs'}, 'Sampling Frequency ', [1 45]));
        if isnan(sum(fss(:))) || isempty(fss)
            msgbox('Please Enter Fs as scalars', '', 'warn');
            return; % Exit if the user does not enter a valid sampling frequency
        end
    end

    % Define the time vector and unique cluster labels
    Time = (0:length(xf) - 1); % Time vector
    L = unique(Labels); % Unique cluster labels
    Col = hsv(length(L)); % Color map for clusters
    NClass = 1 / length(L); % Normalized height for each cluster in the raster plot
    Tim = 'Sample'; % Default time unit

    % Convert time units based on user selection (samples, seconds, minutes, or hours)
    if get(plotR, 'value') == 3
        Time = Time / fss; % Convert to seconds
        index = index / fss; % Convert spike times to seconds
        Tim = 'Time (Sec)'; % Update time unit label
    elseif get(plotR, 'value') == 4
        Time = Time / fss / 60; % Convert to minutes
        index = index / fss / 60; % Convert spike times to minutes
        Tim = 'Time (Min)'; % Update time unit label
    elseif get(plotR, 'value') == 5
        Time = Time / fss / 3600; % Convert to hours
        index = index / fss / 3600; % Convert spike times to hours
        Tim = 'Time (Hour)'; % Update time unit label
    end

    % Initialize the raster matrix and plot spikes for each cluster
    j = 0; % Vertical position counter
    Raster = zeros(length(Labels), length(L)); % Initialize raster matrix
    for i = L
        I = find(Labels == i); % Find indices of spikes in the current cluster
        Raster(I, i) = 1; % Mark spikes in the raster matrix
        % Plot spikes as vertical lines
        plot(ax14, [index(I)' index(I)'], [j NClass + j], 'color', Col(i, :));
        j = j + NClass; % Update vertical position for the next cluster
        ax14.NextPlot = 'add'; % Allow additional plots on the same axes
    end

    % Set axes properties
    ax14.YTick = []; % Remove y-axis ticks
    ax14.FontWeight = 'bold'; % Use bold font
    ax14.FontName = 'Times New Roman'; % Set font to Times New Roman
    ax14.FontSize = 10; % Set font size to 10
    xlabel(ax14, Tim); % Label the x-axis with the appropriate time unit
    set(ax14, 'uicontextmenu', cm); % Attach a context menu to the axes
    xlim(ax14, [0 Time(end)]); % Set x-axis limits to cover the entire time range

    % Notify the user that the operation is completed
    msgbox('Operation Completed');
end
end
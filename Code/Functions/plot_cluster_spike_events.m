%% =============================================================================================
% ================================= Spike Extraction Software ==================================
% ================================ Presented by: Reza Saadatyar ================================
% ============================== Email: Reza.Saadatyar@outlook.com =============================
% ======================================= 2019-2020 ============================================

function MeanSpike = plot_cluster_spike_events(spikes, Labels, fss, plotSU, ax15, cm)
% This function plots clustered spike events and their mean waveforms.
% Inputs:
%   spikes: Detected spike waveforms
%   Labels: Cluster labels for each spike
%   fss: Sampling frequency
%   plotSU: Handle to the checkbox for plotting single-unit clusters
%   ax15: Handle to the axes for plotting
%   cm: Context menu for the axes

% Prepare the axes for plotting
ax15.NextPlot = 'replaceall';  % Clear the axes before plotting
cla(ax15);  % Clear the current axes
axes(ax15);  % Set the current axes
MeanSpike = 0;  % Initialize the mean spike waveform variable

% Check if the single-unit cluster plot checkbox is selected
if get(plotSU, 'value') == 1

    % Check if cluster labels are available
    if Labels == 0
        % Show warning if no cluster labels
        msgbox('Please Set Cluster Parameters in Section Clustering', '', 'warn');
        return;
    end

    % Check if spike data is available
    if spikes == 0
        % Show warning if no spike data
        msgbox('Please Set Spike Detection Parameters in Section Spike Detection', '', 'warn');
        return;
    end

    % Check if the sampling frequency is valid
    if isnan(fss) || (fss <= 0)
        fss = str2double(inputdlg({'Enter Fs'}, 'Sampling Frequency ', [1 45]));  % Prompt for sampling frequency
        if isnan(sum(fss(:))) || isempty(fss)
            msgbox('Please Enter Fs as scalars', '', 'warn');  % Show warning if sampling frequency is invalid
            return;
        end
    end

    % Create time vector in milliseconds
    Time = (0:size(spikes, 2) - 1) * 1000 / fss;

    % Get unique cluster labels
    L = unique(Labels);

    % Generate colors for each cluster
    Col = hsv(length(L));

    % Initialize variables for legend and mean spike waveforms
    Tlegend = cell(length(L), 1);  % Legend labels
    j = 0;  % Offset for plotting individual spikes
    Y = zeros(1, length(L));  % Minimum values of mean waveforms
    MeanSpike = zeros(length(L), size(spikes, 2));  % Mean spike waveforms

    % Loop through each cluster
    for i = L
        I = find(Labels == i);  % Find indices of spikes in the current cluster
        j = j + 1 / length(L) + 0.1;  % Update offset for plotting
        MeanSpike(i, :) = mean(spikes(I, :));  % Compute mean waveform for the current cluster

        % Plot the mean waveform for the current cluster
        P(i) = plot(ax15, Time, mean(spikes(I, :)), 'color', Col(i, :), 'LineWidth', 2);
        ax15.NextPlot = 'add';  % Allow adding more plots to the same axes

        % Plot individual spikes with an offset
        plot(ax15, Time, spikes(I, :) + j, 'color', Col(i, :));
        ax15.NextPlot = 'add';  % Allow adding more plots to the same axes

        % Create legend entry for the current cluster
        Tlegend{i} = ['class ' num2str(i), '; #', num2str(length(I))];

        % Update maximum value for y-axis scaling
        if i == L(end)
            Max = max(max(spikes(I, :)));
        end

        % Store the minimum value of the mean waveform for y-axis scaling
        Y(i) = min(mean(spikes(I, :)));
    end

    % Set axis limits and labels
    axis(ax15, [0 Time(end) min(Y) Max + j]);  % Set x and y-axis limits
    xlabel(ax15, 'Time (msec)');  % Label x-axis
    ylabel(ax15, 'Amp');  % Label y-axis

    % Add legend to the plot
    legend(P, Tlegend);

    % Set font properties for the axes
    ax15.FontWeight = 'bold';
    ax15.FontName = 'Times New Roman';
    ax15.FontSize = 10;

    % Attach context menu to the axes
    set(ax15, 'uicontextmenu', cm);

    % Notify the user that the operation is completed
    msgbox('Operation Completed');
end
end
%% =============================================================================================
% ================================= Spike Extraction Software ==================================
% ================================ Presented by: Reza Saadatyar ================================
% ============================== Email: Reza.Saadatyar@outlook.com =============================
% ======================================= 2019-2020 ============================================

function MeanPhaseSpaces = plot_cluster_phasespaces(spikes, Labels, plotPhU, ax16, cm)
% This function plots phase spaces for clustered spike events.
% Inputs:
%   spikes: Detected spike waveforms
%   Labels: Cluster labels for each spike
%   plotPhU: Handle to the checkbox for plotting phase spaces of single-unit clusters
%   ax16: Handle to the axes for plotting
%   cm: Context menu for the axes

% Prepare the axes for plotting
ax16.NextPlot = 'replaceall';  % Clear the axes before plotting
cla(ax16);  % Clear the current axes
axes(ax16);  % Set the current axes
MeanPhaseSpaces = 0;  % Initialize the mean phase spaces variable

% Check if the phase space plot checkbox is selected
if get(plotPhU, 'value') == 1

    % Check if cluster labels are available
    if Labels == 0 % Show warning if no cluster labels
        msgbox('Please Set Cluster Parameters in Section Clustering', '', 'warn');
        return;
    end

    % Check if spike data is available
    if spikes == 0  % Show warning if no spike data
        msgbox('Please Set Spike Detection Parameters in Section Spike Detection', '', 'warn');
        return;
    end

    % Get unique cluster labels
    L = unique(Labels);

    % Generate colors for each cluster
    Col = hsv(length(L));

    % Initialize variables for legend and mean phase spaces
    Tlegend = cell(length(L), 1);  % Legend labels
    j = 0;  % Offset for plotting individual phase spaces
    Y = zeros(1, length(L));  % Minimum values of spike amplitudes
    MeanPhaseSpaces = zeros(length(L), size(spikes, 2) - 1);  % Mean phase spaces

    % Loop through each cluster
    for i = L
        I = find(Labels == i);  % Find indices of spikes in the current cluster
        j = j + 1 / length(L) + 0.5;  % Update offset for plotting

        % Compute the first derivative of spike waveforms
        Diff1 = diff(spikes(I, :), 1, 2);

        % Compute the mean phase space for the current cluster
        MeanPhaseSpaces(i, :) = mean(Diff1);

        % Plot the mean phase space for the current cluster
        P(i) = plot(ax16, mean(Diff1), mean(spikes(I, 1:end - 1)), 'color', Col(i, :), 'LineWidth', 2);
        ax16.NextPlot = 'add';  % Allow adding more plots to the same axes

        % Plot individual phase spaces with an offset
        plot(ax16, Diff1, spikes(I, 1:end - 1) + j, '.', 'color', Col(i, :));
        ax16.NextPlot = 'add';  % Allow adding more plots to the same axes

        % Create legend entry for the current cluster
        Tlegend{i} = ['class ' num2str(i), '; #', num2str(length(I))];

        % Update maximum value for y-axis scaling
        if i == L(end)
            Max = max(max(spikes(I, :)));
        end

        % Store the minimum value of spike amplitudes for y-axis scaling
        Y(i) = min(mean(spikes(I, :)));
    end

    % Label the axes and set y-axis limits
    xlabel(ax16, 'First Derivative (Amp/ms)');  % Label x-axis
    ylabel(ax16, 'Amp');  % Label y-axis
    ylim(ax16, [min(Y) Max + j]);  % Set y-axis limits

    % Add legend to the plot
    legend(P, Tlegend);

    % Set font properties for the axes
    ax16.FontWeight = 'bold';
    ax16.FontName = 'Times New Roman';
    ax16.FontSize = 10;

    % Attach context menu to the axes
    set(ax16, 'uicontextmenu', cm);

    % Notify the user that the operation is completed
    msgbox('Operation Completed');
end
end
%% =============================================================================================
% ================================= Spike Extraction Software ==================================
% ================================ Presented by: Reza Saadatyar ================================
% ============================== Email: Reza.Saadatyar@outlook.com =============================
% ======================================= 2019-2020 ============================================

function Diff1 = plot_phase_spaces(spikes, dphaspace, ax7, cm)

% Clear the axes and set it for fresh plotting
cla(ax7); % Clear the axes
axes(ax7); % Set the current axes to ax7
Diff1 = 0; % Initialize the derivative output
ax7.NextPlot = 'replaceall'; % Ensure new plots replace existing ones

% Check if the phase space plot option is selected in the GUI
if get(dphaspace, 'value') == 1

    % Check if spikes data is loaded (minimum 2 spikes required)
    if length(spikes) < 2
        msgbox('Please Load Spikes (i.e., Set Parameters for Spike Detection)', '', 'warn');
        return; % Exit the function if spikes are not loaded
    end

    % Compute the first derivative of the spikes (difference between consecutive points)
    Diff1 = diff(spikes, 1, 2); % First derivative along the second dimension (time)

    % Plot individual phase space trajectories in light gray
    for i = 1:size(spikes, 1) / 2
        plot(ax7, Diff1(i, :), spikes(i, 1:end-1), 'Color', [176, 176, 176] / 255); % Plot phase space
        ax7.NextPlot = 'add'; % Allow additional plots on the same axes
    end

    % Plot the mean phase space trajectory in black
    ax7.NextPlot = 'add'; % Ensure the mean plot is added to the existing plot
    plot(mean(Diff1), mean(spikes(:, 1:end-1)), 'k', 'linewidth', 2); % Plot mean trajectory

    % Set axes properties
    ylabel(ax7, 'Amp'); % Label the y-axis as "Amp"
    xlabel(ax7, 'First Derivative (Amp/ms)'); % Label the x-axis as "First Derivative (Amp/ms)"
    ax7.FontName = 'Times New Roman'; % Set font to Times New Roman
    ax7.FontWeight = 'bold'; % Use bold font
    ax7.FontSize = 10; % Set font size to 10
    set(ax7, 'uicontextmenu', cm); % Attach a context menu to the axes for additional functionality

    % Notify the user that the operation is completed
    msgbox('Operation Completed');
end
end
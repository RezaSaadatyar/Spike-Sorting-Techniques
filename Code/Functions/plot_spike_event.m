%% =============================================================================================
% ================================= Spike Extraction Software ==================================
% ================================ Presented by: Reza Saadatyar ================================
% ============================== Email: Reza.Saadatyar@outlook.com =============================
% ======================================= 2019-2020 ============================================

function plot_spike_event(spikes, fss, dspikeven, ax6, cm)

% Clear the axes and set it for fresh plotting
cla(ax6); axes(ax6); ax6.NextPlot = 'replaceall';

% Check if the spike event display option is selected in the GUI
if get(dspikeven, 'value') == 1

    % Check if spikes data is loaded (minimum 2 spikes required)
    if length(spikes) < 2
        msgbox('Please Load Spikes (i.e., Set Parameters for Spike Detection)', '', 'warn');
        return;
    end

    % Validate the sampling frequency (fss)
    if isnan(fss) || (fss <= 0)
        % Prompt the user to enter the sampling frequency if it is invalid
        fss = str2double(inputdlg({'Enter Fs'}, 'Sampling frequency', [1 44]));
        if isnan(fss)
            msgbox('Please enter Fs', '', 'warn');
            return;
        end
        if isempty(fss)
            msgbox('Please enter Fs', '', 'warn');
            return;
        end
    end

    % Calculate the time vector in milliseconds
    Time = (0:size(spikes, 2) - 1) * 1000 / fss;

    % Plot individual spikes in light gray
    plot(ax6, Time, spikes, 'Color', [176, 176, 176] / 255); ax6.NextPlot = 'add';

    % Plot the mean spike waveform in black
    plot(ax6, Time, mean(spikes), 'k', 'linewidth', 2);

    % Set axes properties
    xlim(ax6, [0 Time(end)]); % Set x-axis limits
    xlabel(ax6, 'Time (msec)'); % Label x-axis
    ax6.FontName = 'Times New Roman'; ax6.FontWeight = 'bold'; ax6.FontSize = 10; % Set font properties
    ylabel(ax6, {'Amp'; 'Normalized'}); % Label y-axis

    % Attach a context menu to the axes for additional functionality
    set(ax6, 'uicontextmenu', cm);

    % Notify the user that the operation is completed
    msgbox('Operation Completed');
end
end
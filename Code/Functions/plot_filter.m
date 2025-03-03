%% =============================================================================================
% ================================= Spike Extraction Software ==================================
% ================================ Presented by: Reza Saadatyar ================================
% ============================== Email: Reza.Saadatyar@outlook.com =============================
% ======================================= 2019-2020 ============================================

function plot_filter(Input, DataFilter, fss, design, display, input, time, time1, time2, ax1, ax2, ...
    CM, cm)
% This function plots raw and filtered signals for visualization.
% Inputs:
%   Input: Raw input signal
%   DataFilter: Filtered signal
%   fss: Sampling frequency
%   design: Handle to the filter design selection
%   display: Handle to the display mode selection
%   input: Handle to the input signal selection
%   time: Handle to the time unit selection
%   time1: Handle to the start time input
%   time2: Handle to the end time input
%   ax1: Handle to the primary axes for raw signal
%   ax2: Handle to the secondary axes for filtered signal
%   CM: Context menu for the plot lines
%   cm: Context menu for the axes

% Clear the axes and prepare for plotting
cla(ax1); axes(ax1); cla(ax2); axes(ax2);
ax1.NextPlot = 'replaceall';  % Clear the axes before plotting
ax2.NextPlot = 'replaceall';  % Clear the axes before plotting

% Get input signal selection and time unit selection
SInput = get(input, 'String');  % Get the list of input signals
VInput = get(input, 'value');  % Get the selected input signal index
VSInput = SInput(VInput);  % Get the selected input signal name

Stime = get(time, 'String');  % Get the list of time units
Vtime = get(time, 'value');  % Get the selected time unit index
VStime = Stime(Vtime);  % Get the selected time unit name

% Get start and end times for plotting
time11 = str2double(get(time1, 'string'));  % Start time
time22 = str2double(get(time2, 'string'));  % End time

% Check if filtered data is available
if DataFilter == 0
    msgbox('Please select Parameters in Block Filtering', '', 'warn');  % Show warning if no filtered data
    return;
end

% Check if display mode is selected
if get(display, 'value') == 1
    % Show warning if display mode is not selected
    msgbox('Please select Display All or Part of Data in Block Plot', '', 'warn');
    return;
end

% Create time vector
tim = 0:length(DataFilter) - 1;

% Handle sampling frequency input for specific filter designs
if (get(design, 'value') == 2) && (Vtime ~= 1)
    if isnan(fss) || (fss <= 0)
        fss = str2double(inputdlg({'Enter Fs'}, 'Sampling frequency', [1 44]));  % Prompt for sampling frequency
        if isnan(fss)
            msgbox('Please enter Fs', '', 'warn');  % Show warning if sampling frequency is invalid
            return;
        end
        if isempty(fss)
            msgbox('Please enter Fs', '', 'warn');  % Show warning if sampling frequency is empty
            return;
        end
    end
end

% Convert time vector based on the selected time unit
if Vtime == 2
    tim = tim / fss;  % Convert to seconds
    VStime = 'Time (Sec)';
    if tim(end) < 1
        % Show warning if total time is too small
        msgbox('Please Select Sample; Total time < 1 Second', '', 'warn');  
        return;
    end
elseif Vtime == 3
    tim = tim / fss / 60;  % Convert to minutes
    VStime = 'Time (Min)';
    if tim(end) < 1
        % Show warning if total time is too small
        msgbox('Please Select Second OR Sample; Total time < 1 Minute', '', 'warn')
        return;
    end
elseif Vtime == 4
    tim = tim / fss / 3600;  % Convert to hours
    VStime = 'Time (Hour)';
    if tim(end) < 1
        % Show warning if total time is too small
        msgbox('Please Select Minute, Second OR Sample; Total time < 1 Hour', '', 'warn');
        return;
    end
end

% Handle display mode (partial or full data)
if get(display, 'value') == 2
    set(time1, 'enable', 'on');  % Enable start time input
    set(time2, 'enable', 'on');  % Enable end time input
    
    % Validate start and end times
    if isnan(time11) || (time11 < 0) || (time11 > tim(end))
         % Show warning for invalid start time
        msgbox(['Please Enter Number the first value; 0 < value < ', num2str(tim(end))], '', 'warn');
        return;
    end
    if isnan(time22) || (time22 < 0) || (time22 < time11) || (time22 > tim(end))
        msgbox(['Please Enter Number the second value; ', num2str(time11), '< value < ', ...
            num2str(tim(end))], '', 'warn');  % Show warning for invalid end time
        return;
    end
elseif get(display, 'value') == 3
    time11 = 0;  % Set start time to 0
    time22 = tim(end);  % Set end time to the last time point
    set(time1, 'enable', 'off');  % Disable start time input
    set(time2, 'enable', 'off');  % Disable end time input
end

% Extract the selected time range
I = find(tim == time11);  % Find start time index
II = find(tim == time22);  % Find end time index
Tim = tim(I:II);  % Time vector for the selected range
Input = Input(I:II, :);  % Raw signal for the selected range
DataFilter = DataFilter(I:II, :);  % Filtered signal for the selected range

% Plot raw signal on the first axes
plotline(1) = plot(ax1, Tim, Input);  % Plot raw signal
ax1.XTick = [];  % Remove x-axis ticks
ylabel(ax1, 'Voltage');  % Label y-axis
lg = legend(ax1, 'Raw Signal');  % Add legend
if length(SInput) > 2
    title(lg, VSInput);  % Add title to legend if multiple inputs are available
end
ax1.FontName = 'Times New Roman';  % Set font
ax1.FontWeight = 'bold';  % Set font weight
ax1.FontSize = 10;  % Set font size
xlim(ax1, [time11 time22]);  % Set x-axis limits

% Plot filtered signal on the second axes
plotline(2) = plot(ax2, Tim, DataFilter);  % Plot filtered signal
xlabel(ax2, VStime);  % Label x-axis
ylabel(ax2, 'Voltage');  % Label y-axis
lg = legend(ax2, 'Filtered signal');  % Add legend
if length(SInput) > 2
    title(lg, VSInput);  % Add title to legend if multiple inputs are available
end
ax2.FontName = 'Times New Roman';  % Set font
ax2.FontWeight = 'bold';  % Set font weight
ax2.FontSize = 10;  % Set font size
xlim(ax2, [time11 time22]);  % Set x-axis limits

% Set y-axis limits to match the range of raw and filtered signals
mi = min(min(Input), min(DataFilter));  % Find minimum value
ma = max(max(Input), max(DataFilter));  % Find maximum value
ylim(ax1, [mi ma]);  % Set y-axis limits for raw signal
ylim(ax2, [mi ma]);  % Set y-axis limits for filtered signal

% Attach context menus to the plots and axes
set(plotline, 'uicontextmenu', CM);  % Attach context menu to plot lines
set(ax1, 'uicontextmenu', cm);  % Attach context menu to first axes
set(ax2, 'uicontextmenu', cm);  % Attach context menu to second axes
end
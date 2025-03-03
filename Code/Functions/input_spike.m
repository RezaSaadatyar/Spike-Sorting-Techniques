%% =============================================================================================
% ================================= Spike Extraction Software ==================================
% ================================ Presented by: Reza Saadatyar ================================
% ============================== Email: Reza.Saadatyar@outlook.com =============================
% ======================================= 2019-2020 ============================================

% Define the function `input_spike` to process input data for spike extraction
function [xf, Sigma] = input_spike(Data, DataFilter, inputs, thrmi, thrma, thrmineg, time3, ...
    time4, time5, time6, S)

% Initialize output variables
xf = 0; Sigma = 0;

% Get the selected input option from the GUI
selected_input = get(inputs, 'SelectedObject');

% Reset GUI controls for plotting and peak detection
S.plotauto.Value = 0; % Disable auto-plotting
S.ppeak.Value = 1; % Enable positive peak detection
S.npeak.Value = 0; % Disable negative peak detection
S.bpeak.Value = 0; % Disable both positive and negative peak detection
S.plotmanual.Value = 0; % Disable manual plotting

% Process the selected input data
switch selected_input
    case S.rawS % Raw data selected
        if length(Data) < 1
            msgbox('Please Load Data', 'Error Load Data', 'error'); % Show error if no data is loaded
            return; % Exit function
        end
        xf = Data; % Use raw data

    case S.filterS % Filtered data selected
        if length(DataFilter) < 1 % Show warning if no filtered data is loaded
            msgbox('Please Load Data Filter in Block Filtering', '', 'warn'); 
            return; % Exit function
        end
        xf = DataFilter; % Use filtered data

    case S.derivS % Derivative of filtered data selected
        if length(DataFilter) < 1 % Show warning if no filtered data is loaded
            msgbox('Please Load Data Filter in Block Filtering', '', 'warn'); 
            return; % Exit function
        end
        xf = diff(DataFilter); % Compute the derivative of filtered data
end

% Calculate the noise standard deviation (Sigma) using the median absolute deviation (MAD) method
Sigma = round(median(abs(xf)) / 0.6745, 3); % MAD to Sigma conversion

% Transpose the data for further processing
xf = xf';

% Update GUI controls with calculated thresholds and time settings
set(thrmi, 'string', num2str(5 * Sigma)); % Set minimum threshold (5 * Sigma)
set(thrma, 'string', num2str(20 * Sigma)); % Set maximum threshold (20 * Sigma)
set(thrmineg, 'string', ['-', num2str(5 * Sigma)]); % Set negative threshold (-5 * Sigma)

% Set default time settings in the GUI
set(time3, 'value', 1); % Enable time setting 3
set(time4, 'value', 1); % Enable time setting 4
set(time5, 'string', '0'); % Set time setting 5 to 0

% Set time setting 6 based on the length of the data
if length(xf) > 100000
    set(time6, 'string', '100000'); % Limit to 100,000 samples if data is too large
else
    set(time6, 'string', num2str(length(xf))); % Use the actual length of the data
end

% Display completion message
msgbox('Operation Completed');
end
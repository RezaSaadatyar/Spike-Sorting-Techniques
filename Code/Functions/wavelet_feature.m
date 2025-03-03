%% =============================================================================================
% ================================= Spike Extraction Software ==================================
% ================================ Presented by: Reza Saadatyar ================================
% ============================== Email: Reza.Saadatyar@outlook.com =============================
% ======================================= 2019-2020 ============================================

function waveSpik = wavelet_feature(spikes, Tikwavelet, wave, leve, dispca, diswave)
% Initialize GUI elements and output variable
set(dispca, 'value', 0); % Reset the PCA display checkbox
set(diswave, 'value', 0); % Reset the wavelet display checkbox
waveSpik = 0; % Initialize the output variable

% Check if the wavelet feature extraction is enabled
if get(Tikwavelet, 'value') == 1

    % Check if spikes data is loaded
    if spikes == 0
        % Display a warning message if no spikes data is loaded
        msgbox('Please Load Spikes (i.e., Enter Parameters for Spike Detection)', '', 'warn');
        return; % Exit the function if no spikes data is available
    end

    % Get the selected wavelet type and decomposition level
    Swave = get(wave, 'string'); % Get the list of wavelet types
    nwave = Swave(get(wave, 'value')); % Get the selected wavelet type
    scales = get(leve, 'value'); % Get the selected decomposition level

    % Initialize the output matrix for wavelet coefficients
    waveSpik = zeros(size(spikes, 1), size(spikes, 2));

    % Perform wavelet decomposition for each spike
    for i = 1:size(spikes, 1)
        % Decompose the spike signal using the selected wavelet and level
        a = wavedec(spikes(i, :), scales, char(nwave));
        % Store the approximation coefficients (first 'size(spikes, 2)' elements)
        waveSpik(i, :) = a(1:size(spikes, 2));
    end

    % Notify the user that the operation is completed
    msgbox('Operation Completed');
end
end
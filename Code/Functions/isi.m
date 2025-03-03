%% =============================================================================================
% ================================= Spike Extraction Software ==================================
% ================================ Presented by: Reza Saadatyar ================================
% ============================== Email: Reza.Saadatyar@outlook.com =============================
% ======================================= 2019-2020 ============================================

% Define the function `isi` to calculate interspike intervals (ISI) and autocorrelograms
function [ISI, ISI_centers, Autoc, Xbin] = isi(index, Labels, fss, binTime, plotISI, ...
    plotautogram, maxnInte, minInte, bin)

% Initialize output variables
ISI = 0; ISI_centers = 0; Autoc = 0; Xbin = 0;

% Retrieve user inputs from GUI controls
Bin = str2double(get(bin, 'string')); % Bin size for ISI and autocorrelogram
VbinTime = get(binTime, 'value'); % Time unit for binning (e.g., seconds, minutes, hours)
Min_Interval = str2double(get(minInte, 'string')); % Minimum interval for ISI
Max_Interval = str2double(get(maxnInte, 'string')); % Maximum interval for ISI

% Check if clustering parameters are provided
if Labels == 0
    msgbox('Please Enter Parameters for Clustering in Section Clustering', '', 'warn');
    return; % Exit function if clustering parameters are missing
end

% Check if spike detection parameters are provided
if index == 0
    msgbox('Please Set Spike Detection Parameters in Section Spike Detection', '', 'warn');
    return; % Exit function if spike detection parameters are missing
end

% Validate bin size input
if isnan(Bin) || (Bin <= 0)
    msgbox('Please Enter Bin > 0', '', 'warn');
    return; % Exit function if bin size is invalid
end

% Validate minimum interval input
if isnan(Min_Interval) || (Min_Interval < 0)
    msgbox('Please Enter Min_Interval >= 0', '', 'warn');
    return; % Exit function if minimum interval is invalid
end

% Validate maximum interval input
if isnan(Max_Interval) || (Max_Interval < 0) || (Max_Interval <= Min_Interval)
    msgbox('Please Enter Max_Interval; Max_Interval > Min_Interval', '', 'warn');
    return; % Exit function if maximum interval is invalid
end

%% ISI for multi-unit data
% Define bin edges for ISI histogram
isi_edges = Min_Interval:Bin:Max_Interval; % Bin edges for ISI histogram
ISI_centers = isi_edges(1:end-1) + Bin / 2; % Bin centers for ISI histogram
ISI_centers = ISI_centers * 10^3; % Convert to milliseconds

% Convert spike times from samples to seconds
index = index / fss;

% Adjust time units based on user selection
if VbinTime == 2
    ISI_centers = ISI_centers * 60; % Convert to minutes
    index = index / 60; % Convert spike times to minutes
elseif VbinTime == 3
    ISI_centers = ISI_centers * 3600; % Convert to hours
    index = index / 3600; % Convert spike times to hours
end

% Initialize ISI matrix based on the number of clusters
if max(Labels) < 1
    ISI = zeros(1, length(ISI_centers)); % Single unit
else
    ISI = zeros(max(Labels) + 1, length(ISI_centers)); % Multi-unit
end

% Calculate interspike intervals (ISI) for multi-unit data
isi = diff(index); % Compute ISI
ISI(1, :) = histcounts(isi, isi_edges); % Bin ISI into histogram

%% ISI for single-unit data
if max(Labels) > 1
    for unit_isi = 1:max(Labels)
        index_ = index(Labels == unit_isi); % Spike times for the current unit
        isi1 = diff(index_); % Compute ISI for the current unit
        ISI(unit_isi + 1, :) = histcounts(isi1, isi_edges); % Bin ISI into histogram
    end
end

%% Autocorrelograms for multi-unit data
spk_t = index; % Spike times in seconds
isi_edges = -Max_Interval - Bin:Bin:Max_Interval + Bin; % Bin edges for autocorrelogram
% Initialize autocorrelogram matrix based on the number of clusters
if max(Labels) < 1
    Autoc = zeros(1, length(isi_edges) - 2); % Single unit
else
    Autoc = zeros(max(Labels) + 1, length(isi_edges) - 2); % Multi-unit
end

% Compute autocorrelogram for multi-unit data
ac = zeros(size(isi_edges));
for i = 1:length(spk_t)
    relative_spk_t = spk_t - spk_t(i); % Relative spike times
    counter = hist(relative_spk_t, isi_edges); % Bin relative spike times
    ac = ac + counter; % Accumulate counts
end

% Remove the first and last bins (used for padding) and normalize
Xbin = isi_edges(2:end-1); % Bin centers
ac = ac(2:end-1); % Remove padding bins
ac(round(length(Xbin) / 2)) = 0; % Set the center bin to zero (self-spike)
Autoc(1, :) = ac; % Store autocorrelogram for multi-unit data

%% Autocorrelograms for single-unit data
if max(Labels) > 1
    for unit_isi = 1:max(Labels)
        spk_t = index(Labels == unit_isi); % Spike times for the current unit
        ac = zeros(size(isi_edges));
        for i = 1:length(spk_t)
            relative_spk_t = spk_t - spk_t(i); % Relative spike times
            counter = hist(relative_spk_t, isi_edges); % Bin relative spike times
            ac = ac + counter; % Accumulate counts
        end
        ac = ac(2:end-1); % Remove padding bins
        ac(round(length(Xbin) / 2)) = 0; % Set the center bin to zero (self-spike)
        Autoc(unit_isi + 1, :) = ac; % Store autocorrelogram for the current unit
    end
end

% Adjust time units for autocorrelogram bin centers
Xbin = Xbin * 1000; % Convert to milliseconds
if VbinTime == 2
    Xbin = Xbin * 60; % Convert to minutes
elseif VbinTime == 3
    Xbin = Xbin * 3600; % Convert to hours
end

% Reset GUI controls and display completion message
set(plotISI, 'value', 0); % Reset ISI plot control
set(plotautogram, 'value', 0); % Reset autocorrelogram plot control
msgbox('Operation Completed'); % Display completion message
end
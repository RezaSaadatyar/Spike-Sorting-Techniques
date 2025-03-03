%% =============================================================================================
% ================================= Spike Extraction Software ==================================
% ================================ Presented by: Reza Saadatyar ================================
% ============================== Email: Reza.Saadatyar@outlook.com =============================
% ======================================= 2019-2020 ============================================

% Function to calculate the firing rate of spikes
function [Firing_Rate, Time_Firing] = firing_rate(xf, fss, index, Labels, binTime, binFR, S)

% Initialize output variables and reset GUI flags
Firing_Rate = 0; Time_Firing = 0; 
S.spikepersec.Value = 0; S.countperbin.Value = 0;

% Retrieve the bin size for firing rate calculation
Win = str2double(get(binFR, 'string')); 
VbinTime = get(binTime, 'value'); 

% Validate input data
if length(xf) < 2
    msgbox('Please Select Input Type in Block Spike Detection', '', 'warn'); 
    return; 
end
if Labels == 0
    msgbox('Please Enter Parameters Cluster in Section Clustering', '', 'warn'); 
    return; 
end
if index == 0
    msgbox('Please Set Spike Detection Parameters in Section Spike Detection', '', 'warn'); 
    return; 
end
if isnan(Win) || (Win <= 0)
    msgbox('Please Enter Bin > 0', '', 'warn'); 
    return; 
end
if isnan(fss) || (fss <= 0)
    % Prompt user to enter sampling frequency if not provided
    fss = str2double(inputdlg({'Enter Fs'}, 'Sampling Frequency', [1 45])); 
    if isnan(sum(fss(:))) || isempty(fss)
        msgbox('Please Enter Fs as scalars', '', 'warn'); 
        return; 
    end
end

% Convert spike indices to time and validate total time
Time = (0:length(xf) - 1) / fss; % Time vector for the signal
index = index / fss; % Convert spike indices to time
if Time(end) < 1
    msgbox('Total time < 1 Second', '', 'warn'); 
    return; 
end

%% ==================================== Firing Rate Multi-Unit =================================
% Initialize firing rate matrix
if max(Labels) > 1
    Firing_Rate = zeros(max(Labels) + 1, length(Time_Firing)); % For multiple units
else
    Firing_Rate = zeros(1, length(Time_Firing)); % For a single unit
end

% Calculate firing rate for the entire population (all units)
spk_times = index'; % Spike times in seconds
Time_Firing = min(Time):Win:max(Time); % Time bins for firing rate calculation
for i = 1:length(Time_Firing)
    % Count spikes in the current bin and normalize by bin size
    Firing_Rate(1, i) = sum(spk_times <= Time_Firing(i) + Win & spk_times > Time_Firing(i)) / Win;
end

%% ================================ Firing Rate Single Unit ====================================
% Calculate firing rate for individual units (if multiple units exist)
if max(Labels) > 1
    for unit_fr = 1:max(Labels)
        spk_times = index(Labels == unit_fr)'; % Spike times for the current unit
        for i = 1:length(Time_Firing)
            % Count spikes in the current bin and normalize by bin size
            Firing_Rate(unit_fr + 1, i) = sum(spk_times <= Time_Firing(i) + Win & spk_times > Time_Firing(i)) / Win;
        end
    end
end

% Notify user that the operation is completed
msgbox('Operation Completed');
end
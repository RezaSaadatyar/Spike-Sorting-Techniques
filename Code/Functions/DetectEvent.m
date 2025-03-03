%% =============================================================================================
% ================================= Spike Extraction Software ==================================
% ================================ Presented by: Reza Saadatyar ================================
% ============================== Email: Reza.Saadatyar@outlook.com =============================
% ======================================= 2019-2020 ============================================

% Function to detect spike events in the input signal
function [index, spikes, timspk] = DetectEvent(xf, Vpre, Vpos, Vpren, Vposn, Valig, Vslid, S)

% Initialize the index variable to 0
index = 0;

% Detect positive peaks if selected
if S.ppeak.Value == 1
    % Find indices where the signal exceeds the threshold (Vslid)
    [~, xaux] = find(xf(Vpre:end - Vpos) > Vslid); 
    xaux0 = 0; % Initialize previous index
    index = zeros(1, length(xaux)); % Preallocate index array
    for i = 1:length(xaux)
        % Ensure spikes are separated by at least Valig samples
        if xaux(i) >= xaux0 + Valig
            % Find the maximum point within the alignment window
            [~, iaux] = max((xf(xaux(i):xaux(i) + floor(Valig)))); 
            index(i) = iaux + xaux(i) - 1; % Store the aligned index
            xaux0 = index(i); % Update previous index
        end
    end

% Detect negative peaks if selected
elseif S.npeak.Value == 1
    % Find indices where the signal is below the negative threshold
    [~, xaux] = find(xf(Vpren:end - Vposn) < -abs(Vslid)); 
    xaux0 = 0; % Initialize previous index
    index = zeros(1, length(xaux)); % Preallocate index array
    for i = 1:length(xaux)
        % Ensure spikes are separated by at least Valig samples
        if xaux(i) >= xaux0 + Valig
            % Find the minimum point within the alignment window
            [~, iaux] = min((xf(xaux(i):xaux(i) + floor(Valig)))); 
            index(i) = iaux + xaux(i) - 1; % Store the aligned index
            xaux0 = index(i); % Update previous index
        end
    end

% Detect both positive and negative peaks if selected
elseif S.bpeak.Value == 1
    % Disable other peak detection options
    S.ppeak.Value = 0; S.npeak.Value = 0; S.bpeak.Value = 1; 
    S.pre.Enable = 'on'; S.pos.Enable = 'on'; 
    S.pren.Enable = 'on'; S.posn.Enable = 'on'; 

    % Find indices for both positive and negative peaks
    [~, xaux1] = find(xf(Vpre:end - Vpos) > abs(Vslid)); 
    [~, xaux2] = find(xf(Vpren:end - Vposn) < -abs(Vslid)); 
    xaux = [xaux1 xaux2]; % Combine indices
    xaux = sort(xaux); % Sort indices
    xaux0 = 0; % Initialize previous index
    index = zeros(1, length(xaux)); % Preallocate index array
    for i = 1:length(xaux)
        % Ensure spikes are separated by at least Valig samples
        if xaux(i) >= xaux0 + Valig
            % Find the maximum absolute point within the alignment window
            [~, iaux] = max(abs(xf(xaux(i):xaux(i) + floor(Valig)))); 
            index(i) = iaux + xaux(i) - 1; % Store the aligned index
            xaux0 = index(i); % Update previous index
        end
    end
end

%% SPIKE STORING (with or without interpolation)
% Remove any zero indices
index(index == 0) = [];

% Store spikes and their timings for positive or both peaks
if (S.ppeak.Value == 1) || (S.bpeak.Value == 1)
    ls = Vpre + Vpos + 1; % Length of each spike
    spikes = zeros(length(index), ls); % Preallocate spikes array
    timspk = spikes; % Preallocate timings array
    xf = [xf zeros(1, Vpos)]; % Pad the signal for edge cases
    for i = 1:length(index)
        INDS = index(i) - Vpre:index(i) + Vpos; % Extract spike window
        spikes(i, :) = xf(INDS); % Store spike
        timspk(i, :) = INDS; % Store spike timings
    end

% Store spikes and their timings for negative peaks
elseif S.npeak.Value == 1
    ls = Vpren + Vposn + 1; % Length of each spike
    spikes = zeros(length(index), ls); % Preallocate spikes array
    timspk = spikes; % Preallocate timings array
    xf = [xf zeros(1, Vpos)]; % Pad the signal for edge cases
    for i = 1:length(index)
        INDS = index(i) - Vpren:index(i) + Vposn; % Extract spike window
        spikes(i, :) = xf(INDS); % Store spike
        timspk(i, :) = INDS; % Store spike timings
    end
end

%% Normalize Spikes
% Normalize each spike to the range [0, 1]
mi = min(min(spikes), [], 2); % Minimum of each spike
ma = max(max(spikes), [], 2); % Maximum of each spike
spikes = (spikes - mi) ./ abs(ma - mi); % Normalize spikes

end
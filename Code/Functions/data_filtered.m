%% =============================================================================================
% ================================= Spike Extraction Software ==================================
% ================================ Presented by: Reza Saadatyar ================================
% ============================== Email: Reza.Saadatyar@outlook.com =============================
% ======================================= 2019-2020 ============================================

% Function to filter input data based on user-defined parameters
function [DataFilter, fss, Sigma] = data_filtered(Input, fs, fl, fh, rp, rs, order, design, ...
    response, window, checkFil, Fnotch, notch, display, tabel, time1, time2, time, S)

% Initialize output variables and reset GUI flags
DataFilter = 0; Sigma = 0; 
S.rawS.Value = 0; S.filterS.Value = 0; S.derivS.Value = 0;

% Retrieve user inputs from GUI
disp = get(checkFil, 'value'); % Check if filtering is enabled
fss = str2double(get(fs, 'String')); % Sampling frequency
fll = str2double(get(fl, 'String')); % Lower cutoff frequency
fhh = str2double(get(fh, 'String')); % Upper cutoff frequency
rpp = str2double(get(rp, 'String')); % Passband ripple
rss = str2double(get(rs, 'String')); % Stopband attenuation
orderr = str2double(get(order, 'String')); % Filter order
sCBF = get(design, 'String'); % Filter design method options
ValCBF = get(design, 'Value'); % Selected filter design method
typeCBF = sCBF(ValCBF); % Selected filter design type
sFT = get(response, 'String'); % Filter response type options
ValFT = get(response, 'Value'); % Selected filter response type
typeFT = sFT(ValFT); % Selected filter response type

% Check if input data is selected and filter design method is chosen
if disp == 1
    if Input == 0
        msgbox('Please Select Input Channel Type in Block Load Data', '', 'warn'); 
        return; 
    end
    if ValCBF == 1
        msgbox('Please select design method in Block Filtering:', '', 'warn'); 
        return; 
    end
end

% Apply notch filter if enabled
if get(notch, 'value') == 1
    Fo = str2double(get(Fnotch, 'string')); % Notch frequency
    set(fs, 'enable', 'On'); % Enable sampling frequency input
    if isnan(Fo) || (Fo < 0)
        msgbox('Please Enter F0 > 1', '', 'warn'); 
        return; 
    end
    if isnan(fss) || (fss < 0)
        msgbox('Please Enter Fs > 1', '', 'warn'); 
        return; 
    end
    % Design and apply notch filter
    [num, den] = iirnotch(Fo / (fss / 2), Fo / (fss / 2)); 
    Input = filtfilt(num, den, Input); % Apply zero-phase filtering
end

% Configure GUI elements based on filter design method
if ValCBF == 2
    % Moving average filter settings
    set(response, 'enable', 'Off', 'value', 1); 
    set(window, 'Enable', 'on'); 
    set(fl, 'enable', 'Off'); 
    set(fh, 'enable', 'Off'); 
    set(rp, 'enable', 'Off'); 
    set(rs, 'enable', 'Off'); 
    set(order, 'enable', 'Off'); 
    set(fs, 'enable', 'Off'); 
    if get(notch, 'value') == 1
        set(fs, 'enable', 'On'); 
    end
    typeFT = ''; % No response type for moving average filter
else
    % Other filter design methods
    set(response, 'enable', 'On'); 
    set(window, 'Enable', 'off'); 
    set(fl, 'enable', 'On'); 
    set(fh, 'enable', 'On'); 
    set(rp, 'enable', 'On'); 
    set(rs, 'enable', 'On'); 
    set(order, 'enable', 'On'); 
    set(fs, 'enable', 'On'); 
    if disp == 1
        if ValFT == 1
            msgbox('Please select Response type:', '', 'warn'); 
            return; 
        end
    end
end

% Enable/disable frequency inputs based on filter response type
if strcmp(typeFT, 'Lowpass')
    set(fl, 'Enable', 'on'); 
    set(fh, 'Enable', 'off'); 
elseif strcmp(typeFT, 'Highpass')
    set(fl, 'Enable', 'off'); 
    set(fh, 'Enable', 'on'); 
elseif strcmp(typeFT, 'Bandpass') || strcmp(typeFT, 'Bandstop')
    set(fl, 'Enable', 'on'); 
    set(fh, 'Enable', 'on'); 
end

% Apply moving average filter if selected
if ValCBF == 2
    winS = str2double(get(window, 'String')); % Window size for moving average
    if disp == 1
        if isnan(winS) || winS <= 1 || winS >= length(Input)
            msgbox(['Please Enter Window size; 1 < Value < ', num2str(length(Input))], '', 'warn'); 
            return; 
        end
        % Design and apply moving average filter
        b = (1 / winS) * ones(1, winS); 
        a = 1; 
        DataFilter = filtfilt(b, a, Input); % Apply zero-phase filtering
    end
elseif ValCBF == 3
    % Butterworth filter settings
    set(rp, 'Enable', 'off'); 
    set(rs, 'Enable', 'off'); 
elseif strcmp(typeCBF, 'Cheby1')
    % Chebyshev Type I filter settings
    set(rp, 'Enable', 'on'); 
    set(rs, 'Enable', 'off'); 
elseif strcmp(typeCBF, 'Cheby2')
    % Chebyshev Type II filter settings
    set(rp, 'Enable', 'on'); 
    set(rs, 'Enable', 'off'); 
elseif strcmp(typeCBF, 'Ellip')
    % Elliptic filter settings
    set(rp, 'Enable', 'on'); 
    set(rs, 'Enable', 'on'); 
end

% Apply FIR or IIR filter if selected
if disp == 1
    if ValCBF > 2
        % Design and apply FIR/IIR filter
        DataFilter = FIR(Input, typeFT, typeCBF, fss, orderr, fll, fhh, rpp, rss); 
    end
    if DataFilter ~= 0
        % Validate sampling frequency
        if isnan(fss) || (fss <= 0)
            fss = str2double(inputdlg({'Enter Fs'}, 'Sampling frequency', [1 44])); 
        end
        if isnan(fss)
            msgbox('Please enter Fs', '', 'warn'); 
            return; 
        end
        if isempty(fss)
            msgbox('Please enter Fs', '', 'warn'); 
            return; 
        end
        % Update GUI with filtered data information
        L = length(DataFilter); 
        set(tabel, 'Data', [L; (L - 1) / fss; (L - 1) / fss / 60; (L - 1) / fss / 3600]); 
        if length(DataFilter) > 10000
            set(time1, 'string', '0'); 
            set(time2, 'string', '10000'); 
        else
            set(time1, 'string', '0'); 
            set(time2, 'string', num2str(length(DataFilter))); 
        end
        msgbox('Operation Completed'); 
        set(display, 'value', 1); 
        set(time, 'value', 1); 
    end
end
end
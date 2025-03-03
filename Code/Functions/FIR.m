%% =============================================================================================
% ================================= Spike Extraction Software ==================================
% ================================ Presented by: Reza Saadatyar ================================
% ============================== Email: Reza.Saadatyar@outlook.com =============================
% ======================================= 2019-2020 ============================================

% Function to design and apply a Finite Impulse Response (FIR) filter
function DataFilter = FIR(Input, typeFT, typeCBF, fs, order, fl, fh, rp, rs)
% Initialize output variable
DataFilter = 0;

% Validate sampling frequency (fs)
if isnan(fs) || (fs < 1)
    msgbox('Please Enter Fs and Fs > 0', '', 'warn'); 
    return; 
end

% Validate filter order
if isnan(order) || (order < 1)
    msgbox('Please Enter Order and Order > 0', '', 'warn'); 
    return; 
end

% Validate filter parameters based on filter type
if strcmp(typeFT, 'Lowpass')
    % Validate lowpass cutoff frequency (fl)
    if fl / fs / 2 >= 1
        msgbox('Invalid Value Fpass; (Fs/Fpass /2) must be within the interval of (0,1)', '', 'warn'); 
        return; 
    end
    if isnan(fl) || (fl < 2)
        msgbox('Please Enter Fpass and Fpass > 1', '', 'warn'); 
        return; 
    end
elseif strcmp(typeFT, 'Highpass')
    % Validate highpass cutoff frequency (fh)
    if fh / fs / 2 >= 1
        msgbox('Invalid Value Fstop; (Fs/Fstop /2) must be within the interval of (0,1)', '', 'warn'); 
        return; 
    end
    if isnan(fh) || (fh < 2)
        msgbox('Please Enter Fstop and Fstop > 1', '', 'warn'); 
        return; 
    end
elseif strcmp(typeFT, 'Bandpass') || strcmp(typeFT, 'Bandstop')
    % Validate bandpass/bandstop cutoff frequencies (fl and fh)
    if fl / fs / 2 >= 1
        msgbox('Invalid Value Fpass; (Fs/Fpass /2) must be within the interval of (0,1)', '', 'warn'); 
        return; 
    end
    if fh / fs / 2 >= 1
        msgbox('Invalid Value Fstop; (Fs/Fstop /2) must be within the interval of (0,1)', '', 'warn'); 
        return; 
    end
    if isnan(fl) || (fl < 2)
        msgbox('Please Enter Fpass and Fpass > 1', '', 'warn'); 
        return; 
    end
    if isnan(fh) || (fh < 2)
        msgbox('Please Enter Fstop and Fstop > 1', '', 'warn'); 
        return; 
    end
    if fh <= fl
        msgbox('Fstop must be greater than Fpass (Fstop > Fpass)', '', 'warn'); 
        return; 
    end
end

% Validate filter design parameters based on filter type
if strcmp(typeCBF, 'Cheby1') || strcmp(typeCBF, 'Cheby2')
    % Validate Chebyshev passband ripple (rp)
    if isnan(rp) || (rp < 2)
        msgbox('Please Enter Rp and Rp > 1', '', 'warn'); 
        return; 
    end
elseif strcmp(typeCBF, 'Ellip')
    % Validate Elliptic filter parameters (rp and rs)
    if isnan(rp) || (rp < 1)
        msgbox('Please Enter Rp and Rp > 0', '', 'warn'); 
        return; 
    end
    if isnan(rs) || (rs < 1)
        msgbox('Please Enter Rs and Rs > 0', '', 'warn'); 
        return; 
    end
    if rs <= rp
        msgbox('Rs must be greater than Rp (Rs > Rp)', '', 'warn'); 
        return; 
    end
end

% Design and apply the filter based on filter type and design method
if strcmp(typeFT, 'Lowpass') && strcmp(typeCBF, 'Butter')
    % Butterworth lowpass filter
    [b, a] = butter(order, fl / fs / 2, 'low'); 
    DataFilter = filtfilt(b, a, Input);
elseif strcmp(typeFT, 'Highpass') && strcmp(typeCBF, 'Butter')
    % Butterworth highpass filter
    [b, a] = butter(order, fh / fs / 2, 'high'); 
    DataFilter = filtfilt(b, a, Input);
elseif strcmp(typeFT, 'Bandpass') && strcmp(typeCBF, 'Butter')
    % Butterworth bandpass filter
    [b, a] = butter(order, [fl / fs / 2, fh / fs / 2], 'bandpass'); 
    DataFilter = filtfilt(b, a, Input);
elseif strcmp(typeFT, 'Bandstop') && strcmp(typeCBF, 'Butter')
    % Butterworth bandstop filter
    [b, a] = butter(order, [fl / fs / 2, fh / fs / 2], 'stop'); 
    DataFilter = filtfilt(b, a, Input);
elseif strcmp(typeFT, 'Lowpass') && strcmp(typeCBF, 'Cheby1')
    % Chebyshev Type I lowpass filter
    [b, a] = cheby1(order, rp, fl / fs / 2, 'low'); 
    DataFilter = filtfilt(b, a, Input);
elseif strcmp(typeFT, 'Highpass') && strcmp(typeCBF, 'Cheby1')
    % Chebyshev Type I highpass filter
    [b, a] = cheby1(order, rp, fh / fs / 2, 'high'); 
    DataFilter = filtfilt(b, a, Input);
elseif strcmp(typeFT, 'Bandpass') && strcmp(typeCBF, 'Cheby1')
    % Chebyshev Type I bandpass filter
    [b, a] = cheby1(order, rp, [fl / fs / 2, fh / fs / 2], 'bandpass'); 
    DataFilter = filtfilt(b, a, Input);
elseif strcmp(typeFT, 'Bandstop') && strcmp(typeCBF, 'Cheby1')
    % Chebyshev Type I bandstop filter
    [b, a] = cheby1(order, rp, [fl / fs / 2, fh / fs / 2], 'stop'); 
    DataFilter = filtfilt(b, a, Input);
elseif strcmp(typeFT, 'Lowpass') && strcmp(typeCBF, 'Cheby2')
    % Chebyshev Type II lowpass filter
    [b, a] = cheby2(order, rp, fl / fs / 2, 'low'); 
    DataFilter = filtfilt(b, a, Input);
elseif strcmp(typeFT, 'Highpass') && strcmp(typeCBF, 'Cheby2')
    % Chebyshev Type II highpass filter
    [b, a] = cheby2(order, rp, fh / fs / 2, 'high'); 
    DataFilter = filtfilt(b, a, Input);
elseif strcmp(typeFT, 'Bandpass') && strcmp(typeCBF, 'Cheby2')
    % Chebyshev Type II bandpass filter
    [b, a] = cheby2(order, rp, [fl / fs / 2, fh / fs / 2], 'bandpass'); 
    DataFilter = filtfilt(b, a, Input);
elseif strcmp(typeFT, 'Bandstop') && strcmp(typeCBF, 'Cheby2')
    % Chebyshev Type II bandstop filter
    [b, a] = cheby2(order, rp, [fl / fs / 2, fh / fs / 2], 'stop'); 
    DataFilter = filtfilt(b, a, Input);
elseif strcmp(typeFT, 'Lowpass') && strcmp(typeCBF, 'Ellip')
    % Elliptic lowpass filter
    [b, a] = ellip(order, rp, rs, fl / fs / 2, 'low'); 
    DataFilter = filtfilt(b, a, Input);
elseif strcmp(typeFT, 'Highpass') && strcmp(typeCBF, 'Ellip')
    % Elliptic highpass filter
    [b, a] = ellip(order, rp, rs, fh / fs / 2, 'high'); 
    DataFilter = filtfilt(b, a, Input);
elseif strcmp(typeFT, 'Bandpass') && strcmp(typeCBF, 'Ellip')
    % Elliptic bandpass filter
    [b, a] = ellip(order, rp, rs, [fl / fs / 2, fh / fs / 2], 'bandpass'); 
    DataFilter = filtfilt(b, a, Input);
elseif strcmp(typeFT, 'Bandstop') && strcmp(typeCBF, 'Ellip')
    % Elliptic bandstop filter
    [b, a] = ellip(order, rp, rs, [fl / fs / 2, fh / fs / 2], 'stop'); 
    DataFilter = filtfilt(b, a, Input);
end
end
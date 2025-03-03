%% =============================================================================================
% ================================= Spike Extraction Software ==================================
% ================================ Presented by: Reza Saadatyar ================================
% ============================== Email: Reza.Saadatyar@outlook.com =============================
% ======================================= 2019-2020 ============================================

function [index, spikes, timspk] = threshold(xf, fss, Sigma, detec, thresh, thrmi, thrmineg, thrma, ...
    pre, pos, pren, posn, alig, Exec, time3, time4, time5, time6, waw, slid1, slid2, tabe2, ax3, ...
    ax4, ax5, CM, cm, S)

% Initialize variables
index = 0; spikes = 0; timspk = 0; S.Tikpca.Value = 0; S.Tikwavelet.Value = 0;

% Check if no input type is selected for spike detection
if (S.rawS.Value == 0) && (S.filterS.Value == 0) && (S.derivS.Value == 0)
    msgbox('Please Select Input Type in Block Spike Detection', '', 'warn');
    return;
end

% Check if the input signal is too short
if length(xf) < 2
    msgbox('Please Select Input Type in Block Spike Detection', '', 'warn');
    return;
end

%% ====================================== Set Parameters =======================================  
% Retrieve parameters from GUI inputs
Vpre = round(str2double(get(pre, 'string'))); % Pre-event samples for positive spikes
Vpos = round(str2double(get(pos, 'string'))); % Post-event samples for positive spikes
Vpren = round(str2double(get(pren, 'string'))); % Pre-event samples for negative spikes
Vposn = round(str2double(get(posn, 'string'))); % Post-event samples for negative spikes
Vthrmi = str2double(get(thrmi, 'string')); % Minimum positive threshold
Vthrma = str2double(get(thrma, 'string')); % Maximum threshold
Vthrmn = str2double(get(thrmineg, 'string')); % Minimum negative threshold
Valig = round(str2double(get(alig, 'string'))); % Dead time for alignment
dx = str2double(get(waw, 'string')); % Width of the axis for plotting

% --------------- Set Detect Type and Threshold ---------------------------
% Handle different detection types (positive, negative, or both peaks)
switch get(detec, 'SelectedObject')
    case S.ppeak % Positive peak detection
        if S.plotauto.Value == 1
            set(thrmi, 'enable', 'on'); set(thrmineg, 'enable', 'off');
            if isnan(Vthrmi) || (Vthrmi < 0)
                msgbox('Please Enter Thr_min{+} > 0', '', 'warn'); return;
            end
        end
        set(pre, 'enable', 'on'); set(pren, 'enable', 'off'); set(pos, 'enable', 'on'); set(posn, ...
            'enable', 'off');
        if isnan(Vpre) || (Vpre < 1) || isnan(Vpos) || (Vpos < 1)
            msgbox('Please Enter Number Pre_ Event{+}; Pos_ Event{+} > 0', '', 'warn'); return;
        end
    case S.npeak % Negative peak detection
        if S.plotauto.Value == 1
            set(thrmi, 'enable', 'off'); set(thrmineg, 'enable', 'on');
            if isnan(Vthrmn) || (Vthrmn >= 0)
                msgbox('Please Enter Thr_min {-} < 0', '', 'warn'); return;
            end
        end
        set(pre, 'enable', 'off'); set(pren, 'enable', 'on'); set(pos, 'enable', 'off'); set(posn, ...
            'enable', 'on');
        if isnan(Vpren) || (Vpren < 1) || isnan(Vposn) || (Vposn < 1)
            msgbox('Please Enter Number Pre_ Event{-}; Pos_ Event{-} > 0', '', 'warn'); return;
        end
    case S.bpeak % Both positive and negative peaks detection
        if S.plotauto.Value == 1
            set(thrmi, 'enable', 'on'); set(thrmineg, 'enable', 'on');
            if isnan(Vthrmi) || (Vthrmi < 0)
                msgbox('Please Enter Thr_min{+} > 0', '', 'warn'); return;
            end
            if isnan(Vthrmn) || (Vthrmn >= 0)
                msgbox('Please Enter Thr_min {-} < 0', '', 'warn'); return;
            end
        end
        set(pre, 'enable', 'on'); set(pren, 'enable', 'on'); set(pos, 'enable', 'on'); set(posn, ...
            'enable', 'on');
        if isnan(Vpre) || (Vpre < 1) || isnan(Vpos) || (Vpos < 1)
            msgbox('Please Enter Number Pre_ Event{+}; Pos_ Event{+} > 0', '', 'warn'); return;
        end
        if isnan(Vpren) || (Vpren < 1) || isnan(Vposn) || (Vposn < 1)
            msgbox('Please Enter Number Pre_ Event{-}; Pos_ Event{-} > 0', '', 'warn'); return;
        end
end

% Validate maximum threshold and dead time
if isnan(Vthrma) || (Vthrma <= Vthrmi)
    msgbox('Please Enter Thr_max; Thr_max > Thr_min {+} & Thr_min {-}', '', 'warn'); return;
end
if isnan(Valig) || (Valig < 1)
    msgbox('Please Enter Number Dead Time; Dead Time > Pos_ Event {+ or -}', '', 'warn'); return;
end

% Validate sampling frequency (Fs)
if isnan(fss) || (fss <= 0)
    fss = str2double(inputdlg({'Enter Fs'}, 'Sampling Frequency', [1 45]));
    if isnan(sum(fss(:))) || isempty(fss)
        msgbox('Please Enter Fs as scalars', '', 'warn'); return;
    end
end

% Handle threshold selection (manual or automatic)
if isempty(get(thresh, 'SelectedObject')); return; end
switch get(thresh, 'SelectedObject')
    case S.plotmanual % Manual threshold selection
        set(thrmi, 'enable', 'off'); set(thrmineg, 'enable', 'off'); set(Exec, 'enable', 'off');
        set(slid2, 'enable', 'on');
    case S.plotauto % Automatic threshold selection
        set(Exec, 'enable', 'on'); set(slid2, 'enable', 'off');
end

%% ============================ Load Signal & Slider I & Detect Event ==========================
% Remove outliers from the signal
xf(abs(xf) > Vthrma) = [];
tim = (0:length(xf) - 1); % Time vector
Ma = max(xf); Mi = min(xf); % Maximum and minimum values of the signal
stepSize = 1 / 1000; % Slider step size
Vslid = 5 * Sigma; % Initial slider value

% Configure slider for threshold adjustment
set(slid2, 'Min', Mi, 'Max', Ma, 'Value', 5 * Sigma, 'SliderStep', [stepSize 100 * stepSize], ...
    'Callback', {@Sli2});

% ------------------------------------ Detect Event --------------------------------------------
% Check if execution is enabled and manual mode is not selected
if (get(Exec, 'value') == 0) && (S.plotmanual.Value ~= 1); return; end
% Detect spikes using the DetectEvent function
[index, spikes, timspk] = DetectEvent(xf, Vpre, Vpos, Vpren, Vposn, Valig, Vslid, S);
% Update the table with results
set(tabe2, 'Data', [Sigma; Vslid; length(index)]);

% -------------------------------------- Time --------------------------------------------------
% Handle time unit conversion (samples, seconds, or minutes)
vtm4 = get(time4, 'string'); tim4 = vtm4(get(time4, 'value'));
tim5 = str2double(get(time5, 'string')); tim6 = str2double(get(time6, 'string'));
if get(time4, 'value') == 1 % Time in samples
    INDEX = index; Timsp = timspk;
elseif get(time4, 'value') == 2 % Time in seconds
    tim = tim / fss;
    if tim(end) < 1
        msgbox('Please Select Sample; Total time < 1 Second', '', 'warn'); return;
    end
    INDEX = index / fss; Timsp = timspk / fss; tim4 = 'Time (Sec)';
elseif get(time4, 'value') == 3 % Time in minutes
    tim = tim / fss / 60;
    if tim(end) / 60 < 1
        msgbox(['Please Select Second; Total time:', num2str(round(tim(end) * 60, 3)), ' Second'], ...
            '', 'warn'); return;
    end
    INDEX = index / fss / 60; Timsp = timspk / fss / 60; tim4 = 'Time (Min)';
end

% Handle custom time range selection
if get(time3, 'value') == 1
    set(time5, 'enable', 'on'); set(time6, 'enable', 'on');
    if isnan(tim5) || (tim5 < 0) || (tim5 > tim(end))
        msgbox(['Please Enter First value; 0 < Value <', num2str(round(tim(end), 3))], '', 'warn'); return;
    end
    if isnan(tim6) || (tim6 < 0) || (tim6 <= tim5) || (tim6 > tim(end))
        msgbox(['Please Enter Number Second value; ', num2str(round(tim5, 3)), '  <  Value <', ...
            num2str(round(tim(end), 3))], '', 'warn'); return;
    end
    I1 = find(tim == tim5); I2 = find(tim == tim6);
    I3 = find(INDEX >= tim5, 1, 'first'); I4 = find(INDEX >= tim6, 1, 'first');
elseif get(time3, 'value') == 2
    set(time5, 'enable', 'off'); set(time6, 'enable', 'off'); tim5 = 0; tim6 = tim(end); I1 = 1;
    I2 = size(xf, 2); I3 = 1; I4 = size(INDEX, 2);
end

%% ======================================== Plot Results =======================================
% Validate axis width
if dx >= tim6
    msgbox(['Please Enter Width_axis < ', num2str(tim6)], '', 'warn'); return;
end

% Clear axes and prepare for plotting
cla(ax3); axes(ax3); cla(ax4); axes(ax4); ax3.NextPlot = 'replaceall'; ax4.NextPlot = 'replaceall';

% Plot detected spikes
if ~isempty(INDEX)
    for j = I3:I4
        plot(ax3, Timsp(j, :), spikes(j, :), 'm'); ax3.NextPlot = 'add';
    end
    ax3.XTick = []; ax3.FontName = 'Times New Roman'; ax3.FontWeight = 'bold'; ax3.FontSize = 10;
    ylabel(ax3, 'Voltage');
    plot(ax4, [INDEX(I3:I4)' INDEX(I3:I4)'], [0 1], 'color', 'b'); ax4.XTick = []; ax4.YTick = [];
    xlim(ax4, [tim5 tim6]); xlim(ax3, [tim5 tim6]); til = legend(ax3, 'Spike waveform');
    title(til, ['Total Spikes:', num2str(length(INDEX))]);
end

% Plot the original signal and thresholds
cla(ax5); axes(ax5); ax5.NextPlot = 'replaceall';
p = plot(ax5, tim(I1:I2), xf(I1:I2)); hold on; plot(ax5, [tim(I1) tim(I2)], [Sigma, Sigma], '--k', 'linewidth', 2);

% Plot thresholds based on detection type
if S.ppeak.Value == 1 % Positive peak detection
    Y1 = plot(ax5, [tim5 tim6], 5 * [Sigma, Sigma], '--r', 'linewidth', 2); Leg = {['Thr^+:', num2str(5 * Sigma)]};
elseif S.npeak.Value == 1 % Negative peak detection
    set(slid2, 'Value', -5 * Sigma);
    Y1 = plot(ax5, [tim5 tim6], 5 * [-Sigma, -Sigma], '--r', 'linewidth', 2); Leg = {['Thr^-:', num2str(5 * Sigma)]};
elseif S.bpeak.Value == 1 % Both positive and negative peaks detection
    Y1 = plot(ax5, [tim5 tim6], 5 * [Sigma, Sigma], '--r', 'linewidth', 2); Y2 = plot(ax5, [tim5 tim6], 5 * [-Sigma, -Sigma], '--r', 'linewidth', 2);
    Leg = {['Thr^+:', num2str(5 * Sigma)]; ['Thr^-:', num2str(-5 * Sigma)]};
end
legend(ax5, ['Signal'; ['\sigma: ', num2str(Sigma)]; Leg], 'Orientation', 'horizontal');

% Configure plot axes and labels
xlim(ax5, [tim5 tim6]); ylim(ax5, [min(xf) max(xf)]); xlabel(ax5, tim4);
ax5.FontName = 'Times New Roman'; ax5.FontWeight = 'bold'; ax5.FontSize = 10; ylabel(ax5, 'Voltage');

% Set context menus for plots
set(p, 'uicontextmenu', CM); set(ax3, 'uicontextmenu', cm); set(ax4, 'uicontextmenu', cm);
set(ax5, 'uicontextmenu', cm); msgbox('Operation Completed'); persistent isMessageDisplayed;

% Validate axis width for large datasets
if get(time4, 'value') == 1
    if (length(xf) > 10000) && (abs(tim6 - tim5) < 10000) || (dx < 1000)
        if isempty(isMessageDisplayed)
            msgbox('Please Enter Width_axis > 1000 and Custom range Difference > 10000', '', 'warn');
            isMessageDisplayed = 1; return;
        end
    end
end

% Configure slider for axis adjustment
set(slid1, 'Min', tim5 / dx, 'Max', tim6 / dx, 'Value', tim5 / dx, 'Callback', {@Sli1});
set(slid1, 'SliderStep', [1 / (slid1.Max - slid1.Min) 100 / (slid1.Max - slid1.Min)]);

%% ============================================= Slider I ======================================
function Sli1(~, ~, ~)
    % Adjust the x-axis limits based on slider value
    Vslid1 = round(get(slid1, 'value'), 3);
    if round(Vslid1) <= tim5 / dx
        set(ax3, 'xlim', [tim5 tim6]); set(ax4, 'xlim', [tim5 tim6]); set(ax5, 'xlim', [tim5 tim6]);
    else
        val = [(round(Vslid1) - 1) * dx, round(Vslid1) * dx]; set(ax3, 'xlim', val); set(ax4, 'xlim', val);
        set(ax5, 'xlim', val);
    end
end

%% ======================================== Slider II ==========================================
function Sli2(~, ~, ~)
    % Adjust the threshold based on slider value
    if S.plotmanual.Value == 0
        msgbox('Please Select Manual', '', 'warn'); return;
    end
    Vslid = round(get(slid2, 'value'), 3); S.Tikpca.Value = 0; S.Tikwavelet.Value = 0;

    % Update threshold lines and legend based on detection type
    if S.bpeak.Value == 1
        delete(Y1); Y1 = plot(ax5, [tim5 tim6], abs([Vslid, Vslid]), '--r', 'linewidth', 2);
        delete(Y2); Y2 = plot(ax5, [tim5 tim6], -1 * abs([Vslid, Vslid]), '--r', 'linewidth', 2);
        legend(ax5, 'Signal', ['\sigma:', num2str(Sigma)], ['Thr^+:', num2str(abs(Vslid))], ['Thr^-:-', ...
            num2str(abs(Vslid))], 'Orientation', 'horizontal');
    else
        delete(Y1); Y1 = plot(ax5, [tim5 tim6], [Vslid, Vslid], '--r', 'linewidth', 2);
        legend(ax5, 'Signal', ['\sigma:', num2str(Sigma)], ['Thr:', num2str(Vslid)], 'Orientation', 'horizontal');
    end

    % Update detection type based on threshold value
    if S.bpeak.Value ~= 1
        if Vslid > 0
            S.ppeak.Value = 1; S.npeak.Value = 0; S.bpeak.Value = 0; S.pre.Enable = 'on';
            S.pos.Enable = 'on'; S.pren.Enable = 'off'; S.posn.Enable = 'off';
        elseif Vslid < 0
            S.ppeak.Value = 0; S.npeak.Value = 1; S.bpeak.Value = 0; S.pre.Enable = 'off';
            S.pos.Enable = 'off'; S.pren.Enable = 'on'; S.posn.Enable = 'on';
        end
    else
        S.ppeak.Value = 0; S.npeak.Value = 0; S.bpeak.Value = 1; S.pre.Enable = 'on';
        S.pos.Enable = 'on'; S.pren.Enable = 'on'; S.posn.Enable = 'on';
    end

    % Re-detect spikes with the updated threshold
    [index, spikes, timspk] = DetectEvent(xf, Vpre, Vpos, Vpren, Vposn, Valig, Vslid, S);
    cla(ax3); axes(ax3); cla(ax4); axes(ax4);

    % Plot the updated spikes
    if ~isempty(index)
        if get(time4, 'value') == 1
            INDEX = index; Timsp = timspk;
        elseif get(time4, 'value') == 2
            INDEX = index / fss; Timsp = timspk / fss;
        elseif get(time4, 'value') == 3
            INDEX = index / fss / 60; Timsp = timspk / fss / 60;
        end
        if get(time3, 'value') == 1
            I3 = find(INDEX >= tim5, 1, 'first'); I4 = find(INDEX >= tim6, 1, 'first');
        elseif get(time3, 'value') == 2
            I3 = 1; I4 = size(INDEX, 2);
        end
        for i = I3:I4
            plot(ax3, Timsp(i, :), spikes(i, :), 'm'); ax3.NextPlot = 'add';
        end
        ax3.XTick = []; plot(ax4, [INDEX(I3:I4)' INDEX(I3:I4)'], [0 1], 'color', 'b'); ax4.XTick = []; ax4.YTick = [];
        xlim(ax4, [tim5 tim6]); xlim(ax3, [tim5 tim6]); til = legend(ax3, 'Spike waveform');
        title(til, ['Total Spikes:', num2str(length(INDEX))]);
    end

    % Update plot limits and table
    set(ax3, 'xlim', [tim5 tim6]); set(ax4, 'xlim', [tim5 tim6]); set(ax5, 'xlim', [tim5 tim6]);
    set(slid1, 'Value', tim5 / dx); set(tabe2, 'Data', [Sigma; Vslid; length(index)]);
end

end
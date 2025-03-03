%% =============================================================================================
% ================================= Spike Extraction Software ==================================
% ================================ Presented by: Reza Saadatyar ================================
% ============================== Email: Reza.Saadatyar@outlook.com =============================
% ======================================= 2019-2020 ============================================

function wavfea = plot_wavelet(spikes, waveletSpik, Feat31, Feat32, Feat33, dispca, diswave, ...
    ax8, ax9, ax10, ax11, cm, S)

% Initialize the wavelet feature output
wavfea = 0;

% Reset the PCA display checkbox and clear the axes
set(dispca, 'value', 0);
cla(ax8); axes(ax8); cla(ax9); axes(ax9); cla(ax10); axes(ax10); cla(ax11); axes(ax11);

% Set the axes to replace all plots
ax8.NextPlot = 'replaceall'; ax9.NextPlot = 'replaceall'; ax10.NextPlot = 'replaceall'; ax11.NextPlot = 'replaceall';

% Reset the input cluster and plot checkboxes in the GUI
S.inpclust.Value = 1; S.plotc.Value = 0;

% Check if the wavelet display option is selected
if get(diswave, 'value') == 1

    % Check if spikes data is loaded
    if length(spikes) < 2
        msgbox('Please Load Spikes (i.e., Enter Parameters for Spike Detection)', '', 'warn');
        return;
    end

    % Check if wavelet data is available
    if length(waveletSpik) < 2
        msgbox('Please Select Make Spike Wavelet', '', 'warn');
        return;
    end

    % Get the feature indices from the GUI input fields
    F1 = str2double(get(Feat31, 'string'));
    F2 = str2double(get(Feat32, 'string'));
    F3 = str2double(get(Feat33, 'string'));

    % Handle 2D plot case
    if S.plot2D.Value == 1
        set(Feat33, 'enable', 'off'); % Disable the third feature input for 2D plots

        % Validate the feature indices for 2D plots
        if isnan(F1) || isnan(F2) || (F1 == F2) || (F1 > size(spikes, 2)) || (F2 > size(spikes, 2))
            msgbox(['Please Enter Feature 1 & Feature 2; Feature 1 ~= Feature 2; Feature 1 & Feature 2 < ', ...
                num2str(size(spikes, 2))], '', 'warn');
            return;
        end
    else
        % Handle 3D plot case
        set(Feat33, 'enable', 'on'); % Enable the third feature input for 3D plots

        % Validate the feature indices for 3D plots
        if isnan(F1) || isnan(F2) || isnan(F3) || (F1 == F3) || (F2 == F3) || (F3 > size(spikes, 2)) ...
                || (F1 > size(spikes, 2)) || (F2 > size(spikes, 2))
            msgbox(['Please Enter Feature 3; Feature 3 ~= Feature 1 & Feature 2; Feature 3 < ', ...
                num2str(size(spikes, 2))], '', 'warn');
            return;
        end
    end

    % Set the title for the plot
    til = 'Wavelet';

    % Normalize the wavelet data
    waveletSpik = (waveletSpik - min(waveletSpik)) ./ (max(waveletSpik) - min(waveletSpik));

    % Call the plotting function with the selected features
    PF(spikes, waveletSpik, F1, F2, Feat33, F3, til, ax8, ax9, ax10, ax11, cm, S);

    % Prepare the output features based on the plot type (2D or 3D)
    if S.plot2D.Value == 1
        wavfea = waveletSpik(:, [F1 F2]); % Output 2D features
    elseif S.plot3D.Value == 1
        wavfea = waveletSpik(:, [F1 F2 F3]); % Output 3D features
    end
end
end
%% =============================================================================================
% ================================= Spike Extraction Software ==================================
% ================================ Presented by: Reza Saadatyar ================================
% ============================== Email: Reza.Saadatyar@outlook.com =============================
% ======================================= 2019-2020 ============================================

function pcafea = plot_pca(spikes, PcaSpik, Feat1, Feat2, Feat3, dispca, diswave, ax8, ax9, ax10, ...
    ax11, cm, S)

% Reset the wavelet display checkbox and initialize PCA feature output
set(diswave, 'value', 0); % Disable wavelet display
pcafea = 0; % Initialize PCA feature output

% Set axes properties for fresh plotting
ax8.NextPlot = 'replaceall'; ax9.NextPlot = 'replaceall';
ax10.NextPlot = 'replaceall'; ax11.NextPlot = 'replaceall';

% Reset GUI checkboxes for clustering and plotting
S.inpclust.Value = 1; S.plotc.Value = 0;

% Clear all axes for fresh plotting
cla(ax8); axes(ax8); cla(ax9); axes(ax9); cla(ax10); axes(ax10); cla(ax11); axes(ax11);

% Check if the PCA display option is selected in the GUI
if get(dispca, 'value') == 1

    % Check if spikes data is loaded (minimum 2 spikes required)
    if length(spikes) < 2
        msgbox('Please Load Spikes (i.e., Enter Parameters for Spike Detection)', '', 'warn');
        return; % Exit the function if spikes are not loaded
    end

    % Check if PCA data is available
    if length(PcaSpik) < 2
        msgbox('Please Select Active PCA', '', 'warn');
        return; % Exit the function if PCA data is not available
    end

    % Get the feature indices from the GUI input fields
    Feat1 = str2double(get(Feat1, 'string')); % Feature 1 index
    Feat2 = str2double(get(Feat2, 'string')); % Feature 2 index
    Feat = str2double(get(Feat3, 'string')); % Feature 3 index

    % Handle 2D plot case
    if S.plot2D.Value == 1
        set(Feat3, 'enable', 'off'); % Disable the third feature input for 2D plots

        % Validate the feature indices for 2D plots
        if isnan(Feat1) || isnan(Feat2) || (Feat1 == Feat2) || (Feat1 > size(spikes, 2)) || (Feat2 > size(spikes, 2))
            msgbox(['Please Enter Feature 1 & Feature 2; Feature 1 ~= Feature 2; Feature 1 & Feature 2 < ', num2str(size(spikes, 2))], '', 'warn');
            return; % Exit if feature indices are invalid
        end
    else
        % Handle 3D plot case
        set(Feat3, 'enable', 'on'); % Enable the third feature input for 3D plots

        % Validate the feature indices for 3D plots
        if isnan(Feat1) || isnan(Feat2) || isnan(Feat) || (Feat1 == Feat) || (Feat2 == Feat) || ...
                (Feat1 > size(spikes, 2)) || (Feat2 > size(spikes, 2)) || (Feat > size(spikes, 2))
            msgbox(['Please Enter Feature 3; Feature 3 ~= Feature 1 & Feature 2; Feature 3 < ', ...
                num2str(size(spikes, 2))], '', 'warn');
            return; % Exit if feature indices are invalid
        end
    end

    % Set the title for the plot
    til = 'PCA';

    % Normalize the PCA data to the range [0, 1]
    PcaSpik = (PcaSpik - min(PcaSpik)) ./ (max(PcaSpik) - min(PcaSpik));

    % Call the plotting function with the selected features
    PF(spikes, PcaSpik, Feat1, Feat2, Feat3, Feat, til, ax8, ax9, ax10, ax11, cm, S);

    % Prepare the output features based on the plot type (2D or 3D)
    if S.plot2D.Value == 1
        pcafea = PcaSpik(:, [Feat1 Feat2]); % Output 2D features (Feature 1 and Feature 2)
    elseif S.plot3D.Value == 1
        pcafea = PcaSpik(:, [Feat1 Feat2 Feat]); % Output 3D features (Feature 1, Feature 2, and Feature 3)
    end
end
end
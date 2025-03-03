%% =============================================================================================
% ================================= Spike Extraction Software ==================================
% ================================ Presented by: Reza Saadatyar ================================
% ============================== Email: Reza.Saadatyar@outlook.com =============================
% ======================================= 2019-2020 ============================================

function InputClust = input_cluster(pcafea, wavfea, plotc, inpclust, cursor, numcl, ax12, cm, S)
% Initialize output variable and GUI settings
InputClust = 0; S.auto.Value = 0; S.manual.Value = 0; set(numcl, 'value', 1);
ax12.NextPlot = 'replaceall'; % Prepare axes for new plots

% Check if no input type is selected for clustering
if get(inpclust, 'value') == 1
    msgbox('Please Select Input Type in Section Clustering', '', 'warn');
    return;
elseif get(inpclust, 'value') == 2 % PCA features selected
    % Check if PCA features are available
    if size(pcafea, 1) <= 1
        msgbox('Please Select PCA Analysis in Section Feature Extraction', '', 'warn');
        return;
    end
    InputClust = pcafea; % Use PCA features for clustering
    til = 'PCA'; % Title for plots
    % Define feature labels based on the number of features
    if size(InputClust, 2) == 2
        Feat1 = ['Feature ' S.Feat1.String]; Feat2 = ['Feature ' S.Feat2.String];
    else
        Feat1 = ['Feature ' S.Feat1.String]; Feat2 = ['Feature ' S.Feat2.String]; Feat3 = ['Feature ' S.Feat3.String];
    end
elseif get(inpclust, 'value') == 3 % Wavelet features selected
    % Check if wavelet features are available
    if size(wavfea, 1) <= 1
        msgbox('Please Select Wavelet Analysis in Section Feature Extraction', '', 'warn');
        return;
    end
    InputClust = wavfea; % Use wavelet features for clustering
    til = 'Wavelet'; % Title for plots
    % Define feature labels based on the number of features
    if size(InputClust, 2) == 2
        Feat1 = ['Feature ' S.Feat31.String]; Feat2 = ['Feature ' S.Feat32.String];
    else
        Feat1 = ['Feature ' S.Feat31.String]; Feat2 = ['Feature ' S.Feat32.String]; Feat3 = ['Feature ' S.Feat33.String];
    end
end

% Plot the selected features if plotting is enabled
if get(plotc, 'value') == 1
    if size(InputClust, 2) == 2 % 2D plot for two features
        plot(ax12, InputClust(:, 1), InputClust(:, 2), '.'); % Scatter plot
        xlabel(ax12, Feat1); ylabel(ax12, Feat2); % Label axes
        title(ax12, til); % Set plot title
        ax12.FontWeight = 'bold'; ax12.FontName = 'Times New Roman'; ax12.FontSize = 10; % Format axes
        ax12.XMinorGrid = 'on'; ax12.YMinorGrid = 'on'; % Enable minor grid lines
        dcm = datacursormode; % Enable data cursor mode
        dcm.Enable = 'off'; dcm.DisplayStyle = 'datatip'; % Configure data cursor
        dcm.UpdateFcn = @displayCoordinates; % Set callback for displaying coordinates
        if get(cursor, 'value') == 1; dcm.Enable = 'on'; end % Enable cursor if selected
    elseif size(InputClust, 2) == 3 % 3D plot for three features
        plot3(ax12, InputClust(:, 1), InputClust(:, 2), InputClust(:, 3), '.'); % 3D scatter plot
        xlabel(ax12, Feat1); ylabel(ax12, Feat2); zlabel(ax12, Feat3); % Label axes
        title(ax12, til); % Set plot title
        ax12.FontWeight = 'bold'; ax12.FontName = 'Times New Roman'; ax12.FontSize = 10; % Format axes
        ax12.XMinorGrid = 'on'; ax12.YMinorGrid = 'on'; % Enable minor grid lines
        dcm = datacursormode; % Enable data cursor mode
        dcm.Enable = 'on'; dcm.DisplayStyle = 'datatip'; % Configure data cursor
        dcm.UpdateFcn = @displayCoordinates3D; % Set callback for displaying coordinates
        if get(cursor, 'value') == 1; dcm.Enable = 'off'; end % Disable cursor if selected
    end
    set(ax12, 'uicontextmenu', cm); % Set context menu for the axes
end
end
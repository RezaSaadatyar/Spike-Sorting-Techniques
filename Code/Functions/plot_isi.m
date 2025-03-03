%% =============================================================================================
% ================================= Spike Extraction Software ==================================
% ================================ Presented by: Reza Saadatyar ================================
% ============================== Email: Reza.Saadatyar@outlook.com =============================
% ======================================= 2019-2020 ============================================

% Define the function `plot_isi` to plot interspike interval (ISI) histograms
function plot_isi(ISI, ISI_centers, plotISI, bin, ax21, ax22, cm)

% Prepare axes for plotting
ax21.NextPlot = 'replaceall'; % Clear previous plots in ax21
cla(ax21); % Clear ax21
subplot(1, 1, 1, 'replace', 'Parent', ax22); % Prepare ax22 for subplots

% Check if ISI plotting is enabled
if get(plotISI, 'value') == 1
    
    % Retrieve bin size from GUI
    Bin = str2double(get(bin, 'string'));

    % Validate ISI data and bin size
    if ISI == 0 % Show warning if ISI data is missing
        msgbox('Please Select ISI & Autocorrelogram parameters', '', 'warn'); 
        return; % Exit function
    end
    if isnan(Bin) || (Bin <= 0)
        msgbox('Please Enter Bin > 0', '', 'warn'); % Show warning if bin size is invalid
        return; % Exit function
    end

    % Plot ISI histogram for single unit
    if size(ISI, 1) < 2
        bar(ax21, ISI_centers, ISI(1, :), 'FaceColor', 'k', 'EdgeColor', 'k'); % Plot ISI histogram
        ax21.NextPlot = 'add'; % Allow adding more plots
        % Highlight refractory period
        bar(ax21, abs(ISI_centers(find(ISI(1, :), 1, 'first')) - Bin * 1000) / 2, max(ISI(1, :)), ...
            'r', 'EdgeColor', 'r', 'BarWidth', 2);
        % Add label for refractory period
        labels1 = ['Refractory Period(', num2str(abs(ISI_centers(find(ISI(1, :), 1, 'first')) - ...
            Bin * 1000)), 'ms)'];
        text(ISI_centers(find(ISI(1, :), 1, 'first')), max(ISI(1, :)), labels1, 'HorizontalAlignment', ...
            'left', 'Color', ...
            'r', 'FontSize', 10, 'FontWeight', 'bold', 'FontName', 'Times New Roman');
        % Set axis labels and title
        xlabel(ax21, 'ISI (ms)'); ylabel(ax21, 'Number of Spikes');
        title(ax21, ['Interspike Interval Histograms; bin = ', num2str(Bin * 1000), ' ms']);
        % Set font properties
        ax21.FontWeight = 'bold'; ax21.FontName = 'Times New Roman'; ax21.FontSize = 10;
    end

    % Plot ISI histograms for multiple units
    if size(ISI, 1) > 1
        % Plot ISI histogram for multi-unit data
        bar(ax21, ISI_centers, ISI(1, :), 'FaceColor', 'k', 'EdgeColor', 'k');
        title(ax21, ['Interspike Interval Histograms for multi Units; bin = ', num2str(Bin * 1000), ...
            ' ms']);
        xlabel(ax21, 'ISI (ms)'); ylabel(ax21, 'Number of Spikes');
        ax21.FontWeight = 'bold'; ax21.FontName = 'Times New Roman'; ax21.FontSize = 10;

        % Plot ISI histograms for each unit in subplots
        subplot(1, 1, 1, 'replace', 'Parent', ax22); % Prepare ax22 for subplots
        Ma = max(max(ISI(2:end, :))); % Find maximum ISI count for scaling
        for i = 2:size(ISI, 1)
            p(i - 1) = subplot(size(ISI, 1) - 1, 1, i - 1); % Create subplot for each unit
            % Plot ISI histogram
            bar(p(i - 1), ISI_centers, ISI(i, :), 'FaceColor', 'k', 'EdgeColor', 'k'); hold on; 
            % Highlight refractory period
            bar(p(i - 1), abs(ISI_centers(find(ISI(i, :), 1, 'first')) - Bin * 1000) / 2, ...
                max(ISI(i, :)), 'r', 'EdgeColor', 'r', 'BarWidth', 2);
            % Add legend for unit and refractory period
            u1 = ['Unit ', num2str(i - 1)];
            u2 = ['Refractory Period: ', num2str(abs(ISI_centers(find(ISI(i, :), 1, 'first')) - Bin ...
                * 1000)), 'ms'];
            legend({u1, u2}); ylim([0, Ma + 1]); % Set y-axis limits
            % Add title for the first subplot
            if i == 2
                title(['Interspike Interval Histograms, bin = ', num2str(Bin * 1000), ' ms']);
            end
            % Remove x-axis ticks for intermediate subplots
            if i ~= size(ISI, 1)
                ax.XTick = [];
            end
            % Set font properties for subplots
            ax = gca; ax.FontWeight = 'bold'; ax.FontName = 'Times New Roman'; ax.FontSize = 10;
            ylabel('Number of Spikes');
        end
        xlabel('ISI (ms)'); % Add x-axis label for the last subplot
    end

    % Set context menu for subplots and main axes
    set(p, 'uicontextmenu', cm); set(ax21, 'uicontextmenu', cm);
    msgbox('Operation Completed'); % Display completion message
end
end
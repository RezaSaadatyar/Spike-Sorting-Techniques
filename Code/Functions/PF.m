%% =============================================================================================
% ================================= Spike Extraction Software ==================================
% ================================ Presented by: Reza Saadatyar ================================
% ============================== Email: Reza.Saadatyar@outlook.com =============================
% ======================================= 2019-2020 ============================================

% Define the main function PF for spike extraction and visualization
function PF(spikes, FSpik, Feat1, Feat2, Feat3, Feat, til, ax8, ax9, ax10, ax11, cm, S)

% Check if 2D plot is selected
if S.plot2D.Value == 1
   
   % Plot spikes in 2D using Feature 1 and Feature 2
   plot(ax8, spikes(:, Feat1), spikes(:, Feat2), '.'); 
   title(ax8, 'Spikes'); % Set title for the plot
   xlabel(ax8, ['Feature ', num2str(Feat1)]); % Label x-axis
   ylabel(ax8, ['Feature ', num2str(Feat2)]); % Label y-axis
   ax8.FontWeight = 'bold'; ax8.FontName = 'Times New Roman'; ax8.FontSize = 10; % Set font properties
   ax8.XGrid = 'on'; ax8.YGrid = 'on'; ax8.XMinorGrid = 'on'; ax8.YMinorGrid = 'on'; % Enable grid lines
   
   % Plot histograms for Feature 1 and Feature 2
   hist1 = histogram(ax9, spikes(:, Feat1), 50, 'Normalization', 'probability', 'EdgeColor', 'r', ...
       'FaceColor', 'r'); 
   ax9.NextPlot = 'add'; % Allow adding more plots
   hist2 = histogram(ax9, spikes(:, Feat2), 50, 'Normalization', 'probability', 'EdgeColor', 'g', ...
       'FaceColor', 'g'); 
   ax9.NextPlot = 'add'; % Allow adding more plots
   
   % Fit kernel distribution to Feature 1 and plot the PDF
   pd = fitdist(spikes(:, Feat1), 'Kernel', 'Kernel', 'epanechnikov'); 
   pdfEst = pdf(pd, hist1.BinEdges); 
   ax9.NextPlot = 'add'; % Allow adding more plots
   plot(ax9, hist1.BinEdges, pdfEst * max(hist1.Values) / max(pdfEst), '--r', 'LineWidth', 2.5); 
   
   % Fit kernel distribution to Feature 2 and plot the PDF
   pd = fitdist(spikes(:, Feat2), 'Kernel', 'Kernel', 'epanechnikov'); 
   pdfEst = pdf(pd, hist2.BinEdges); 
   ax9.NextPlot = 'add'; % Allow adding more plots
   plot(ax9, hist2.BinEdges, pdfEst * max(hist2.Values) / max(pdfEst), 'g', 'LineWidth', 2.5); 
   
   % Set font properties and grid for the histogram plot
   ax9.FontWeight = 'bold'; ax9.FontName = 'Times New Roman'; ax9.FontSize = 10; ax9.YGrid = 'on'; 
   ylabel(ax9, 'Probability'); % Label y-axis
   legend(ax9, {['Feature ', num2str(Feat1)], ['Feature ', num2str(Feat2)]}, 'Orientation', 'horizontal'); % Add legend
   
   % Plot filtered spikes in 2D using Feature 1 and Feature 2
   plot(ax10, FSpik(:, Feat1), FSpik(:, Feat2), '.'); 
   ax10.FontSize = 10; ax10.XGrid = 'on'; ax10.YGrid = 'on'; % Set font and grid properties
   xlabel(ax10, ['Feature ', num2str(Feat1)]); % Label x-axis
   ylabel(ax10, ['Feature ', num2str(Feat2)]); % Label y-axis
   title(ax10, til); % Set title for the plot
   ax10.FontWeight = 'bold'; ax10.FontName = 'Times New Roman'; ax10.FontSize = 10; ax10.XMinorGrid = 'on'; 
   ax10.YMinorGrid = 'on'; % Enable minor grid lines
   
   % Plot histograms for filtered spikes using Feature 1 and Feature 2
   hist1 = histogram(ax11, FSpik(:, Feat1), 50, 'Normalization', 'probability', 'EdgeColor', 'r', ...
       'FaceColor', 'r'); 
   ax11.NextPlot = 'add'; % Allow adding more plots
   hist2 = histogram(ax11, FSpik(:, Feat2), 50, 'Normalization', 'probability', 'EdgeColor', 'g', ...
       'FaceColor', 'g'); 
   
   % Fit kernel distribution to filtered Feature 1 and plot the PDF
   pd = fitdist(FSpik(:, Feat1), 'Kernel', 'Kernel', 'epanechnikov'); 
   pdfEst = pdf(pd, hist1.BinEdges); 
   ax11.NextPlot = 'add'; % Allow adding more plots
   plot(ax11, hist1.BinEdges, pdfEst * max(hist1.Values) / max(pdfEst), '--r', 'LineWidth', 2.5); 
   
   % Fit kernel distribution to filtered Feature 2 and plot the PDF
   pd = fitdist(FSpik(:, Feat2), 'Kernel', 'Kernel', 'epanechnikov'); 
   pdfEst = pdf(pd, hist2.BinEdges); 
   ax11.NextPlot = 'add'; % Allow adding more plots
   plot(ax11, hist2.BinEdges, pdfEst * max(hist2.Values) / max(pdfEst), 'g', 'LineWidth', 2.5); 
   
   % Set font properties and grid for the histogram plot
   ax11.FontWeight = 'bold'; ax11.FontName = 'Times New Roman'; ax11.FontSize = 10; ax11.YGrid = 'on'; 
   ylabel(ax11, 'Probability'); % Label y-axis
   legend(ax11, {['Feature ', num2str(Feat1)], ['Feature ', num2str(Feat2)]}, 'Orientation', 'horizontal'); % Add legend

% Check if 3D plot is selected
elseif S.plot3D.Value == 1
   set(Feat3, 'enable', 'on'); % Enable Feature 3 input
   
   % Check if Feature 3 is valid
   if isnan(Feat) || (Feat1 == Feat) || (Feat2 == Feat) || (Feat > size(spikes, 2))
       msgbox(['Please Enter Feature 3; Feature 3 ~= Feature 1 & Feature 2; Feature 3 < ', ...
           num2str(size(spikes, 2))], '', 'warn'); 
       return; % Exit function if Feature 3 is invalid
   end
   
   % Plot spikes in 3D using Feature 1, Feature 2, and Feature 3
   plot3(ax8, spikes(:, Feat1), spikes(:, Feat2), spikes(:, Feat), '.'); 
   title(ax8, 'Spikes'); % Set title for the plot
   xlabel(ax8, ['Feature ', num2str(Feat1)]); % Label x-axis
   ylabel(ax8, ['Feature ', num2str(Feat2)]); % Label y-axis
   zlabel(ax8, ['Feature ', num2str(Feat)]); % Label z-axis
   ax8.FontWeight = 'bold'; ax8.FontName = 'Times New Roman'; ax8.FontSize = 10; ax8.XMinorGrid = 'on';
   ax8.YMinorGrid = 'on'; 
   ax8.ZMinorGrid = 'on'; % Enable minor grid lines
   
   % Plot histograms for Feature 1, Feature 2, and Feature 3
   hist1 = histogram(ax9, spikes(:, Feat1), 50, 'Normalization', 'probability', 'EdgeColor', 'r', ...
       'FaceColor', 'r'); 
   ax9.NextPlot = 'add'; % Allow adding more plots
   hist2 = histogram(ax9, spikes(:, Feat2), 50, 'Normalization', 'probability', 'EdgeColor', 'g', ...
       'FaceColor', 'g'); 
   ax9.NextPlot = 'add'; % Allow adding more plots
   hist3 = histogram(ax9, spikes(:, Feat), 50, 'Normalization', 'probability', 'EdgeColor', 'b', ...
       'FaceColor', 'b'); 
   ax9.NextPlot = 'add'; % Allow adding more plots
   
   % Fit kernel distribution to Feature 1 and plot the PDF
   pd = fitdist(spikes(:, Feat1), 'Kernel', 'Kernel', 'epanechnikov'); 
   pdfEst = pdf(pd, hist1.BinEdges); 
   ax9.NextPlot = 'add'; % Allow adding more plots
   plot(ax9, hist1.BinEdges, pdfEst * max(hist1.Values) / max(pdfEst), '--r', 'LineWidth', 2.5); 
   
   % Fit kernel distribution to Feature 2 and plot the PDF
   pd = fitdist(spikes(:, Feat2), 'Kernel', 'Kernel', 'epanechnikov'); 
   pdfEst = pdf(pd, hist2.BinEdges); 
   ax9.NextPlot = 'add'; % Allow adding more plots
   plot(ax9, hist2.BinEdges, pdfEst * max(hist2.Values) / max(pdfEst), 'g', 'LineWidth', 2.5); 
   
   % Fit kernel distribution to Feature 3 and plot the PDF
   pd = fitdist(spikes(:, Feat), 'Kernel', 'Kernel', 'epanechnikov'); 
   pdfEst = pdf(pd, hist3.BinEdges); 
   ax9.NextPlot = 'add'; % Allow adding more plots
   plot(ax9, hist3.BinEdges, pdfEst * max(hist3.Values) / max(pdfEst), 'b', 'LineWidth', 2.5); 
   
   % Set font properties and grid for the histogram plot
   ax9.FontWeight = 'bold'; ax9.FontName = 'Times New Roman'; ax9.FontSize = 10; ax9.YGrid = 'on'; 
   ylabel(ax9, 'Probability'); % Label y-axis
   legend(ax9, {['Feature ', num2str(Feat1)], ['Feature ', num2str(Feat2)], ['Feature ', num2str(Feat)]}, ...
       'Orientation', 'horizontal'); % Add legend
   
   % Plot filtered spikes in 3D using Feature 1, Feature 2, and Feature 3
   plot3(ax10, FSpik(:, Feat1), FSpik(:, Feat2), FSpik(:, Feat), '.'); 
   ax10.XMinorGrid = 'on'; ax10.YMinorGrid = 'on'; 
   ax10.ZMinorGrid = 'on'; % Enable minor grid lines
   xlabel(ax10, ['Feature ', num2str(Feat1)]); % Label x-axis
   ylabel(ax10, ['Feature ', num2str(Feat2)]); % Label y-axis
   zlabel(ax10, ['Feature ', num2str(Feat)]); % Label z-axis
   ax10.FontWeight = 'bold'; ax10.FontName = 'Times New Roman'; 
   ax10.FontSize = 10; title(ax10, til); % Set title for the plot
   
   % Plot histograms for filtered spikes using Feature 1, Feature 2, and Feature 3
   hist1 = histogram(ax11, FSpik(:, Feat1), 50, 'Normalization', 'probability', 'EdgeColor', 'r', ...
       'FaceColor', 'r'); 
   ax11.NextPlot = 'add'; % Allow adding more plots
   hist2 = histogram(ax11, FSpik(:, Feat2), 50, 'Normalization', 'probability', 'EdgeColor', 'g', ...
       'FaceColor', 'g'); 
   ax11.NextPlot = 'add'; % Allow adding more plots
   hist3 = histogram(ax11, FSpik(:, Feat), 50, 'Normalization', 'probability', 'EdgeColor', 'b', ...
       'FaceColor', 'b'); 
   
   % Fit kernel distribution to filtered Feature 1 and plot the PDF
   pd = fitdist(FSpik(:, Feat1), 'Kernel', 'Kernel', 'epanechnikov'); 
   pdfEst = pdf(pd, hist1.BinEdges); 
   ax11.NextPlot = 'add'; % Allow adding more plots
   plot(ax11, hist1.BinEdges, pdfEst * max(hist1.Values) / max(pdfEst), '--r', 'LineWidth', 2.5); 
   
   % Fit kernel distribution to filtered Feature 2 and plot the PDF
   pd = fitdist(FSpik(:, Feat2), 'Kernel', 'Kernel', 'epanechnikov'); 
   pdfEst = pdf(pd, hist2.BinEdges); 
   ax11.NextPlot = 'add'; % Allow adding more plots
   plot(ax11, hist2.BinEdges, pdfEst * max(hist2.Values) / max(pdfEst), 'g', 'LineWidth', 2.5); 
   
   % Fit kernel distribution to filtered Feature 3 and plot the PDF
   pd = fitdist(FSpik(:, Feat), 'Kernel', 'Kernel', 'epanechnikov'); 
   pdfEst = pdf(pd, hist3.BinEdges); 
   ax11.NextPlot = 'add'; % Allow adding more plots
   plot(ax11, hist3.BinEdges, pdfEst * max(hist3.Values) / max(pdfEst), ':b', 'LineWidth', 2.5); 
   
   % Set font properties and grid for the histogram plot
   ax11.FontWeight = 'bold'; ax11.FontName = 'Times New Roman'; ax11.FontSize = 10; ax11.YGrid = 'on'; 
   ylabel(ax11, 'Probability'); % Label y-axis
   legend(ax11, {['Feature ', num2str(Feat1)], ['Feature ', num2str(Feat2)], ['Feature ', num2str(Feat)]}, ...
       'Orientation', 'horizontal'); % Add legend
end

% Set context menu for the axes
set(ax8, 'uicontextmenu', cm); 
set(ax9, 'uicontextmenu', cm); 
set(ax10, 'uicontextmenu', cm); 
set(ax11, 'uicontextmenu', cm); 
end
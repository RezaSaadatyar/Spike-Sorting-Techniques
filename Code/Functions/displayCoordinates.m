%% =============================================================================================
% ================================= Spike Extraction Software ==================================
% ================================ Presented by: Reza Saadatyar ================================
% ============================== Email: Reza.Saadatyar@outlook.com =============================
% ======================================= 2019-2020 ============================================

% Function to display coordinates of a point in a plot
function txt = displayCoordinates(~, info)
    % Extract the x and y coordinates from the input 'info' structure
    x = info.Position(1); % X-coordinate of the point
    y = info.Position(2); % Y-coordinate of the point

    % Create a cell array of strings to display the coordinates
    % Each coordinate is rounded to 2 decimal places for readability
    txt = {['X: ' num2str(round(x, 2))]; % X-coordinate as a string
           ['Y: ' num2str(round(y, 2))]}; % Y-coordinate as a string
end
%% =============================================================================================
% ================================= Spike Extraction Software ==================================
% ================================ Presented by: Reza Saadatyar ================================
% ============================== Email: Reza.Saadatyar@outlook.com =============================
% ======================================= 2019-2020 ============================================

% Function to display coordinates of a point in a 3D plot
function txt = displayCoordinates3D(~, info)
    % Extract the x, y, and z coordinates from the input 'info' structure
    x = info.Position(1); % X-coordinate of the point
    y = info.Position(2); % Y-coordinate of the point
    z = info.Position(3); % Z-coordinate of the point

    % Create a cell array of strings to display the coordinates
    % Each coordinate is rounded to 2 decimal places for readability
    txt = {['X: ' num2str(round(x, 2))]; % X-coordinate as a string
           ['Y: ' num2str(round(y, 2))]; % Y-coordinate as a string
           ['Z: ' num2str(round(z, 2))]}; % Z-coordinate as a string
end
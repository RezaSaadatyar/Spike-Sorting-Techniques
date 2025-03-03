%% =============================================================================================
% ================================= Spike Extraction Software ==================================
% ================================ Presented by: Reza Saadatyar ================================
% ============================== Email: Reza.Saadatyar@outlook.com =============================
% ======================================= 2019-2020 ============================================

function [Inputch, DataFilter] = select_input(Data, str, values, FF, radio, input, inp, radio1)
% Initialize output variables
Inputch = 0; DataFilter = 0;

% Check if data is loaded
if Data == 0
    msgbox('Please Load Data in Block Load Data', 'Error Load Data', 'error');
    return;
end

% Convert data to double if it is single precision
if isa(Data, 'single')
    Data = double(Data);
end

% Reset radio button value and get input selection
set(radio, 'value', 0);
Sinp = get(inp, 'String'); % Get the list of input options
Vinp = get(inp, 'Value'); % Get the selected input index
typinp = Sinp(Vinp); % Get the selected input type

% Check if no input is selected
if get(inp, 'value') == 1
    msgbox('Please Select Input in Block Load Data', '', 'warn');
    return;
end

% Load data based on file type
if strcmp(str, 'xlsx') % Excel file
    Data = xlsread(FF, char(typinp)); % Read data from the selected sheet
elseif strcmp(str, 'mat') % MATLAB .mat file
    Val = struct2cell(values); % Convert struct to cell array
    Data = cell2mat(Val(Vinp - 1)); % Extract data for the selected field
elseif strcmp(str, 'txt') % Text file
    Data = values; % Use the loaded data directly
end

% Ensure data is in the correct orientation (columns as channels)
if size(Data, 1) < size(Data, 2)
    Data = Data';
end

% Prepare input selection options for multi-channel data
if size(Data, 2) == 1 % Single-channel data
    set(input, 'value', 1); % Set default selection
    set(input, 'string', {'Select:'; 'data'}); % Set input options
else % Multi-channel data
    Cell = cell(size(Data, 2) + 1, 1); % Create a cell array for channel selection
    Cell{1} = 'Select:'; % First option is "Selection"
    for i = 2:size(Data, 2) + 1
        Cell{i} = ['Ch', num2str(i - 1)]; % Label channels as Ch1, Ch2, etc.
    end
    set(input, 'value', 1); % Set default selection
    set(input, 'string', Cell); % Set input options
end

% Normalize data if the radio button is selected
Vradi = get(radio1, 'value');
if Vradi == 1
    mu = max(Data, [], 1); % Maximum value of each channel
    sd = min(Data, [], 1); % Minimum value of each channel
    mami = mu - sd; % Range of each channel
    mu1 = repmat(mami, size(Data, 1), 1); % Replicate range for normalization
    mi = repmat(sd, size(Data, 1), 1); % Replicate minimum for normalization
    Data = (Data - mi) ./ mu1; % Normalize data to [0, 1] range
end

% Set output variable
Inputch = Data;

end
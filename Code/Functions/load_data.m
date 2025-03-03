%% =============================================================================================
% ================================= Spike Extraction Software ==================================
% ================================ Presented by: Reza Saadatyar ================================
% ============================== Email: Reza.Saadatyar@outlook.com =============================
% ======================================= 2019-2020 ============================================

function [str, FF, Data, values] = load_data(inp, text1)
% Initialize variables
Data=0;str='';FF=0;values=0;

% Open a file selection dialog box to allow the user to select a file
[F,P]=uigetfile({'*.mat','Data file';'*.txt','Data file';'*.xlsx',...
    'Excel file';'*.mdl','Model file';'*.*','All Files'},'File Selection',...
    'multiselect','on');

% Check if the user canceled the file selection dialog
if F==0
    % Display an error message if no file is selected
    msgbox('Please Load Data','Error Load Data','error');
    % Clear the text in the input text box
    set(text1,'string','');
    % Exit the function
    return;
end

% Set the text in the input text box to the selected file name
set(text1,'string',F);
% Store the selected file name and path
FF=F;PP=P;
% Find the file extension
ind=strfind(F,'.');str=F(ind+1:end);

% Handle different file types
if strcmp(str,'xlsx')
    % If the file is an Excel file, get the sheet names
    [~,sheet]=xlsfinfo(FF);
    % Create a cell array to store the sheet names
    u=cell(length(sheet)+1,1);u{1}='Select Labels';
    % Populate the cell array with sheet names
    for i=1:length(sheet);u(i+1,1)=sheet(i);end
    % Set the input dropdown menu to the sheet names
    u{1}='Select Input:';set(inp,'string',u);
    % Load the data from the first sheet if there are multiple sheets
    if length(u)>1;Data=xlsread(FF,char(u(2)));end
elseif strcmp(str,'mat')
    % If the file is a MATLAB .mat file, load the data
    values= load([PP,FF]);
    % Get the field names in the loaded data
    fields = fieldnames(values);
    % Create a cell array to store the field names
    u=cell(length(fields)+1,1);u{1}='Select Labels';
    % Populate the cell array with field names
    for i=1:length(fields);u(i+1,1)=fields(i);end
    % Convert the struct to a cell array and extract the data
    Val=struct2cell(values);Data=cell2mat(Val(1));
    % Set the input dropdown menu to the field names
    u{1}='Select Input';set(inp,'value',1,'string',u);
elseif strcmp(str,'txt')
    % If the file is a text file, load the data
    values= load([PP,FF]);Data=values;
    % Set the input dropdown menu to a default option
    set(inp,'string',{'Select Input';'Inputs'});
end

% Ensure the data is in the correct orientation (columns as variables)
[handles.a,handles.b]=size(Data);if (handles.a<handles.b);Data=Data';end

end
%% =============================================================================================
% ================================= Spike Extraction Software ==================================
% ================================ Presented by: Reza Saadatyar ================================
% ============================== Email: Reza.Saadatyar@outlook.com =============================
% ======================================= 2019-2020 ============================================

function Input = select_channels(Inputch,Chi,Chj,input,inp,checkFil)
% Initialize the output variable
Input=0;

% Check if the input selection is not made in the GUI
if get(inp,'value')==1
    msgbox('Please Select Input in Block Load Data','','warn');
    return;
end

% Check if the input channel data is not loaded
if Inputch==0
    msgbox('Please Select Input in Block Load Data','Error Load Data','error');
    return;
end

% Convert input data to double precision if it is in single precision
if isa(Inputch,'single')
    Inputch=double(Inputch);
end

% Disable the Chi and Chj input fields
set(Chj,'Enable','off');
set(Chi,'Enable','off');

% Get the selected input channel type from the GUI
VInput=get(input,'Value');

% Check if the input channel type is not selected
if VInput==1
    msgbox('Please Select Input Channel Type in Block Load Data','','warn');
    return;
end

% Select the appropriate input channel based on the selection
if size(Inputch,2)>1
    Input=Inputch(:,VInput-1);
elseif size(Inputch,2)==1
    Input=Inputch;
end

% Reset the filter checkbox
set(checkFil,'value',0)

% The following commented section is for handling multiple channels and specific channel ranges
% if (VInput==2)&&(size(Inputch,2)>1)
%     set(Chi,'Enable','on');set(Chj,'Enable','on');
%     Vchi=str2double(get(Chi,'string'));Vchj=str2double(get(Chj,'string'));
%     if  isnan(Vchi);msgbox('Please Enter Chi','','warn');return;end
%     if  Vchi<1;msgbox(['0 < Chi < ',num2str(size(Inputch,2)-1)],'','warn');return;end
%     if  isnan(Vchj)||(Vchj<=Vchi);msgbox('Please Enter Chj and  Chj > Chi','','warn');return;end
%     if  Vchj>size(Inputch,2);msgbox([num2str(Vchi),'< Chj <',num2str(size(Inputch,2)+1)],'','warn');return;end
%     Input=Inputch(:,Vchi:Vchj);
% elseif (VInput==2);Input=Inputch;set(Chi,'Enable','off');set(Chj,'Enable','off');
% else;Input=Inputch(:,VInput-2);set(Chi,'Enable','off');set(Chj,'Enable','off');
% end
end
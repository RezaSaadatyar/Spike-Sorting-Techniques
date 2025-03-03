%% =============================================================================================
% ================================= Spike Extraction Software ==================================
% ================================ Presented by: Reza Saadatyar ================================
% ============================== Email: Reza.Saadatyar@outlook.com =============================
% ======================================= 2019-2020 ============================================

function [str, FF, Data, values] = load_data(inp, text1)
Data=0;str='';FF=0;values=0;

[F,P]=uigetfile({'*.mat','Data file';'*.txt','Data file';'*.xlsx',...
    'Excel file';'*.mdl','Model file';'*.*','All Files'},'File Selection',...
    'multiselect','on');
if F==0;msgbox('Please Load Data','Error Load Data','error');set(text1,'string','');return;end
set(text1,'string',F);FF=F;PP=P;ind=strfind(F,'.');str=F(ind+1:end);

if strcmp(str,'xlsx')
    [~,sheet]=xlsfinfo(FF);u=cell(length(sheet)+1,1);u{1}='Select Labels';
    for i=1:length(sheet);u(i+1,1)=sheet(i);end
    u{1}='Select Input:';set(inp,'string',u);
    if length(u)>1;Data=xlsread(FF,char(u(2)));end
elseif strcmp(str,'mat')
    values= load([PP,FF]);fields = fieldnames(values);u=cell(length(fields)+1,1);
    u{1}='Select Labels';for i=1:length(fields);u(i+1,1)=fields(i);end
    Val=struct2cell(values);Data=cell2mat(Val(1));
    u{1}='Select Input';set(inp,'value',1,'string',u);
elseif strcmp(str,'txt')
    values= load([PP,FF]);Data=values;
    set(inp,'string',{'Select Input';'Inputs'});
end

[handles.a,handles.b]=size(Data);if (handles.a<handles.b);Data=Data';end

end

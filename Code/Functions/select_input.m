function [Inputch,DataFilter]=select_input(Data,str,values,FF,radio,input,inp,radio1)
 
Inputch=0;DataFilter=0;

if Data==0;msgbox('Please Load Data in Block Load Data','Error Load Data','error');return;end

if isa(Data,'single');Data=double(Data);end
set(radio,'value',0);Sinp=get(inp,'String');Vinp=get(inp,'Value');typinp=Sinp(Vinp);

if get(inp,'value')==1;msgbox('Please Select Input in Block Load Data','','warn');return;end
if strcmp(str,'xlsx');Data=xlsread(FF,char(typinp));
elseif strcmp(str,'mat');Val=struct2cell(values);Data=cell2mat(Val(Vinp-1));
elseif strcmp(str,'txt');Data=values;
end

if size(Data,1)<size(Data,2);Data=Data';end
% Cell=cell(size(Data,2)+2,1);Cell(1:3)={'Selection';'All Ch';'Multi Ch'};
if size(Data,2)==1;set(input,'value',1);set(input,'string',{'Selection';'data'});
else;Cell=cell(size(Data,2)+1,1);Cell{1}='Selection';
for i=2:size(Data,2)+1;Cell{i}=['Ch', num2str(i-1)];end
set(input,'value',1);set(input,'string',Cell);
end
Vradi=get(radio1,'value');
% if Vradi==1;mu=mean(Data,1);mu1=repmat(mu,size(Data,1),1);
%     sd=std(Data,0,1);Data=(Data-mu1)./repmat(sd,size(Data,1),1);end
if Vradi==1;mu=max(Data,[],1);sd=min(Data,[],1);mami=mu-sd;
    mu1=repmat(mami,size(Data,1),1);mi=repmat(sd,size(Data,1),1);
    Data=(Data-mi)./mu1;
end

Inputch=Data;

end

%% =============================================================================================
% ================================= Spike Extraction Software ==================================
% ================================ Presented by: Reza Saadatyar ================================
% ============================== Email: Reza.Saadatyar@outlook.com =============================
% ======================================= 2019-2020 ============================================

function [xf,Sigma]=input_spike(Data,DataFilter,inputs,thrmi,thrma,thrmineg,time3,...
time4,time5,time6,S) 

xf=0;Sigma=0;selected_input=get(inputs,'SelectedObject');S.plotauto.Value=0;
S.ppeak.Value=1;S.npeak.Value=0;S.bpeak.Value=0;S.plotmanual.Value=0;


switch selected_input
    case S.rawS
        if length(Data)<1;msgbox('Please Load Data','Error Load Data','error');return;end
        xf=Data;
    case S.filterS
        if length(DataFilter)<1;msgbox('Please Load Data Filter in Block Filtering','','warn');return;end
        xf=DataFilter;
    case S.derivS
        if length(DataFilter)<1;msgbox('Please Load Data Filter in Block Filtering','','warn');return;end
        xf=diff(DataFilter);
end

Sigma=round(median(abs(xf))/0.6745,3);xf=xf';set(thrmi,'string',num2str(5*Sigma));
set(thrma,'string',num2str(20*Sigma));set(thrmineg,'string',['-',num2str(5*Sigma)]);
set(time3,'value',1);set(time4,'value',1);set(time5,'string','0');
if length(xf)>100000;set(time6,'string','100000');else;set(time6,'string',num2str(length(xf)));end
msgbox('Operation Completed');

end
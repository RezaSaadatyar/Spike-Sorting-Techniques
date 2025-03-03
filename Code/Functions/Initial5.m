%% =============================================================================================
% ================================= Spike Extraction Software ==================================
% ================================ Presented by: Reza Saadatyar ================================
% ============================== Email: Reza.Saadatyar@outlook.com =============================
% ======================================= 2019-2020 ============================================

function [INDEX,tim,ti,Time,Timsp]=Initial5(Data,xf,index,spikes,timspk,fss,Vthrmi,...
Vthrmn,time3,time4,time5,time6,inp,inputf,detec,waw,tab3,cm,ax2)

INDEX=0;ti=0;Timsp=0;
Time=(0:length(Data)-1)/fss;xf=xf(1:size(Data,1));
vtm=get(time4,'string');tim=vtm(get(time4,'value'));Vtime3=get(time3,'value');
tim5=str2double(get(time5,'string'));tim6=str2double(get(time6,'string'));
dx=str2double(get(waw,'string'));

if Data==0;msgbox('Please Load Data','Error Load Data','error');return;end
if get(inp,'value')==1;msgbox('Please Select Input:','','warn');return;end
if get(inputf,'Value')==1;msgbox('Please Select Input Type:','','warn');return;end
if get(detec,'Value')==1;msgbox('Please Select Detection Type:','','warn');return;end
if spikes==0;msgbox('Please Eneter Thr_min & Thr_max','','warn');return;end
if get(time3,'value')==1;msgbox('Please Select Plot Type','','warn');return;end
if isnan(dx)||(dx<=0);msgbox('Please Enter width_axis window  >  0','','warn');return;end

subplot(2,1,1,'replace','Parent',ax2);subplot(2,1,2,'replace','Parent',ax2);

if get(time4,'value')==1
if Time(end)<1;msgbox('Totall time < 1 Second','','error');return;end   
INDEX=index/fss;Timsp=timspk/fss; % spike times in sec.
elseif get(time4,'value')==2
if Time(end)/60<1;msgbox(['Please Select Second; Totall time:',num2str(Time(end)/fss),' Second'],'','warn');return;end    
Time=Time/60;INDEX=index/fss/60;Timsp=timspk/fss/60;% spike times in min.
end 

if Vtime3==2
set(time5,'enable','off');set(time6,'enable','off');tim5=0;tim6=Time(end);I1=1;
I2=size(xf,2);I=1;II=size(spikes,1);
elseif Vtime3==3
set(time5,'enable','on');set(time6,'enable','on')
if isnan(tim5)||(tim5<0);msgbox('Please Enter value > 0','','warn');return;end
if isnan(tim6)||(tim6<0)||(tim6<=tim5);msgbox(['Please Enter Number value > ',num2str(tim5)],'','warn');return;end
I1=find(Time==tim5);I2=find(Time==tim6);I=find(Timsp(:,1)>=tim5,1,'first');II=find(Timsp(:,1)>=tim6,1,'first'); 
end

p(1)=subplot(2,1,1,'Parent',ax2);
for i=I:II;plot(p(1),Timsp(i,:),spikes(i,:),'m','linewidth',1.5);hold on;end
gc1=gca;gc1.FontWeight='bold';gc1.FontName='Times New Roman';gc1.FontSize=10;xlim([tim5 tim6])
ylabel({'Ampiltude';'(Normalized)'},'FontSize',12);legend(p(1),'Spike waveform')

p(2)=subplot(2,1,2,'Parent',ax2);plot(p(2),Time(I1:I2),xf(I1:I2));hold on;
if get(detec,'Value')==2;plot(p(2),[tim5 tim6],[Vthrmi,Vthrmi],'--r','linewidth',2.7);
legend({'Signal Flitred','Thr^+'},'FontWeight','bold','FontName','Times New Roman','FontSize',9,'Orientation','Horizontal')
elseif get(detec,'Value')==3;plot(p(2),[tim5 tim6],[Vthrmn,Vthrmn],'--k','linewidth',2.7);
legend({'Signal Flitred','Thr^-'},'FontWeight','bold','FontName','Times New Roman','FontSize',9,'Orientation','Horizontal')
elseif get(detec,'Value')==4;plot(p(2),[tim5 tim6],[Vthrmi,Vthrmi],'--r','linewidth',2.7);
plot(p(2),[tim5 tim6],[Vthrmn,Vthrmn],'--k','linewidth',2.7);
legend({'Signal Flitred','Thr^+','Thr^-'},'FontWeight','bold','FontName','Times New Roman','FontSize',9,'Orientation','Horizontal')
end
xlabel(tim,'FontSize',12);ylabel('Ampiltude','FontSize',12);xlim([tim5 tim6])
gc2=gca;gc2.FontWeight='bold';gc2.FontName='Times New Roman';gc2.FontSize=10;
set(gcf,'doublebuffer','on');% Set appropriate axis limits and settings
h=uicontrol(tab3,'style','slider','units','normalized','position',[0.008,0,0.985,0.05],...
'min',tim5/dx,'max',tim6/dx,'value',tim5/dx,'BackgroundColor','g','Callback',{@Sli,gc1,gc2});
stepSize=1/(h.Max-h.Min);h.SliderStep=[stepSize 100*stepSize];  

set(p,'uicontextmenu',cm);msgbox('Operation Completed')
function Sli(h,~,gc1,gc2)
    if round(h.Value)<=tim5/dx
        set(gc1,'xlim',[tim5 tim6]);set(gc2,'xlim',[tim5 tim6]);
    else
       val=[(round(h.Value)-1)*dx  round(h.Value)*dx];set(gc1,'xlim',val);set(gc2,'xlim',val);                        
    end
end
end
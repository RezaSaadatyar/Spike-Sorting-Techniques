function plot_spikesorting(xf,spikes,timspk,Labels,index,fss,time7,time8,...
Xlim,slid3,tabe3,ax17,ax18,cm,S)

ax17.NextPlot='replaceall';cla(ax17);axes(ax17);ax18.NextPlot='replaceall';cla(ax18);axes(ax18)

tim7=str2double(get(time7,'string'));tim8=str2double(get(time8,'string'));
dx=str2double(get(Xlim,'string'));tim=(0:length(xf)-1);L=unique(Labels);Col=hsv(length(L));
Data=zeros(length(L),2);set(tabe3,'Data',Data)

if length(spikes)<2;msgbox('Please Load Spikes(i.e., Set Parameters Spike Detection)','','warn');return;end
if Labels==0;msgbox('Please Set Cluster Parameters in Section Clustering','','warn');return;end
if index==0;msgbox('Please Set Spike Detection Parameters in Section Spike Detection','','warn');return;end
if isnan(fss)||(fss<=0);fss=str2double(inputdlg({'Enter Fs'},'Sampling Frequency ',[1 45]));
if isnan(sum(fss(:)))||isempty(fss);msgbox('Please Enter Fs as scalars','','warn');return;end
end 

tim4='Sample';
if S.second.Value==1;tim=tim/fss;   
if tim(end)<1;msgbox('Please Select Sample; Totall time < 1 Second','','warn');return;end  
index=index/fss;timspk=timspk/fss;tim4='Time (Sec)';
elseif S.minute.Value==1;tim=tim/fss/60;    
if tim(end)/60<1;msgbox(['Please Select Second; Totall time:',num2str(round(tim(end)*60,3)),' Second'],'','warn');return;end    
index=index/fss/60;timspk=timspk/fss/60;tim4='Time (Min)';
elseif S.hour.Value==1;tim=tim/fss/3600;    
if tim(end)/3600<1;msgbox(['Please Select Minute; Totall time:',num2str(round(tim(end)*3600,3)),' Minute'],'','warn');return;end    
index=index/fss/3600;timspk=timspk/fss/3600;tim4='Time (Hour)';
end

if isnan(tim7)||(tim7<0)||(tim7>=tim(end));msgbox(['Please Enter First value; 0 < Value <', num2str(round(tim(end),3))],'','warn');return;end
if isnan(tim8)||(tim8<0)||(tim8<=tim7)||(tim8>=tim(end));msgbox(['Please Enter Number Second value; ',num2str(round(tim7,3)),'  <  Value <', num2str(round(tim(end),3))],'','warn');return;end
if isnan(dx)||(dx<0)||(dx>tim8);msgbox(['Please Enter Width_axes; 0 < Width_axes < ',num2str(tim8)],'','warn');return;end

I1=find(tim==tim7);I2=find(tim==tim8);I3=find(index>=tim7,1,'first');I4=find(index<=tim8,1,'last');

if S.plotmanual.Value==1;Sigma1=S.slid2.Value;Sigma2=Sigma1;else;if S.ppeak.Value==1;Sigma1=str2double(S.thrmi.String);
elseif S.npeak.Value==1;Sigma2=str2double(S.thrmineg.String);elseif S.bpeak.Value==1
Sigma1=str2double(S.thrmi.String);Sigma2=str2double(S.thrmineg.String);end
end
%% ==================== Plot =============================================
for i=L
Labels1=Labels(I3:I4);I=find(Labels1==i);
if ~isempty(I);for j=I; plot(ax17,timspk(j,:),spikes(j,:),'color',Col(i,:));ax17.NextPlot='add';end;end
Data(i,:)=[length(find(Labels1==i)),length(find(Labels==i))];
end
ax17.XTick=[];ylabel(ax17,'Voltage');xlim(ax17,[tim7 tim8]);ax17.FontWeight='bold';
ax17.FontSize=10;ax17.FontName='Times New Roman';

plot(ax18,tim(I1:I2),xf(I1:I2));ax18.NextPlot='add';
if S.ppeak.Value==1
plot(ax18,[tim7 tim8],[Sigma1,Sigma1],'--r','linewidth',2);Leg={['Thr^+:',num2str(Sigma1)]}; 
elseif S.npeak.Value==1
plot(ax18,[tim7 tim8],[Sigma2,Sigma2],'--r','linewidth',2);Leg={['Thr^-:',num2str(Sigma2)]}; 
elseif S.bpeak.Value==1
plot(ax18,[tim7 tim8],[Sigma1,Sigma1],'--r','linewidth',2);ax18.NextPlot='add';
plot(ax18,[tim7 tim8],[Sigma2,Sigma2],'--r','linewidth',2);
Leg={['Thr^+:',num2str(Sigma1)];['Thr^-:',num2str(Sigma2)]};          
end
xlabel(ax18,tim4);ax18.FontWeight='bold';ax18.FontSize=10;ax18.FontName='Times New Roman';
legend(ax18,['Signal';Leg],'Orientation','horizontal');xlim(ax18,[tim7 tim8]);
ylabel(ax18,'Voltage');

set(tabe3,'Data',Data)
set(ax17,'uicontextmenu',cm);set(ax18,'uicontextmenu',cm);msgbox('Operation Completed')
%% ============================ Slider I ==================================
set(slid3,'Min',tim7/dx,'Max',tim8/dx,'Value',tim7/dx,'Callback',{@Sli});
set(slid3,'SliderStep',[1/(slid3.Max-slid3.Min) 100/(slid3.Max-slid3.Min)]);
function Sli(~,~,~)
    Vslid1=round(get(slid3,'value'),3);
    if round(Vslid1)<=tim7/dx
     set(ax17,'xlim',[tim7 tim8]);set(ax18,'xlim',[tim7 tim8]);
    else
       val=[(round(Vslid1)-1)*dx  round(Vslid1)*dx];set(ax17,'xlim',val);set(ax18,'xlim',val);
    end
end

end
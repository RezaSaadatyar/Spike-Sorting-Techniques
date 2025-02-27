function plot_filter(Input,DataFilter,fss,design,display,input,time,time1,time2,ax1,ax2,CM,cm)

cla(ax1);axes(ax1);cla(ax2);axes(ax2);ax1.NextPlot='replaceall';ax2.NextPlot='replaceall';

SInput=get(input,'String');VInput=get(input,'value');VSInput=SInput(VInput);
% Vchi=str2double(get(Chi,'string'));Vchj=str2double(get(Chj,'string'));
Stime=get(time,'String');Vtime=get(time,'value');VStime=Stime(Vtime);
time11=str2double(get(time1,'string'));time22=str2double(get(time2,'string'));

% if Data==0;msgbox('Please Load Data in Block Load Data','Error Load Data','error');return;end
if DataFilter==0;msgbox('Please select Parameters in Block Filtering','','warn');return;end
if get(display,'value')==1;msgbox('Please select Display All or Part of Data in Block Plot','','warn');return;end
tim=0:length(DataFilter)-1;

if (get(design,'value')==2)&&(Vtime~=1)
if isnan(fss)||(fss<=0);fss=str2double(inputdlg({'Enter Fs'},'Sampling frequency',[1 44]));
if isnan(fss);msgbox('Please enter Fs','','warn');return;end
if isempty(fss);msgbox('Please enter Fs','','warn');return;end   
end
end
if Vtime==2;tim=tim/fss;VStime='Time (Sec)';
if tim(end)<1;msgbox('Please Select Sample; Totall time < 1 Second','','warn');return;end
elseif Vtime==3;tim=tim/fss/60;VStime='Time (Min)';
if tim(end)<1;msgbox('Please Select Second OR Sample; Totall time < 1 Minut','','warn');return;end
elseif Vtime==4;tim=tim/fss/3600;VStime='Time (Hour)';
if tim(end)<1;msgbox('Please Select Minute, Second OR Sample; Totall time < 1 Hour','','warn');return;end
end

if get(display,'value')==2
set(time1,'enable','on');set(time2,'enable','on')    
if isnan(time11)||(time11<0)||(time11>tim(end));msgbox(['Please Enter Number the first value; 0 < value < ',num2str(tim(end))],'','warn');return;end
if isnan(time22)||(time22<0)||(time22<time11)||(time22>tim(end));msgbox(['Please Enter Number the second value; ',num2str(time11),'< value < ',num2str(tim(end))],'','warn');return;end
elseif get(display,'value')==3
time11=0;time22=tim(end);set(time1,'enable','off');set(time2,'enable','off')       
end

I=find(tim==time11);II=find(tim==time22);Tim=tim(I:II);
Input=Input(I:II,:);DataFilter=DataFilter(I:II,:);

% subplot(1,1,1,'replace','Parent',ax1);% p(1)=subplot(2,1,1,ax1);
plotline(1)=plot(ax1,Tim,Input);ax1.XTick=[];ylabel(ax1,'Voltage');lg=legend(ax1,'Raw Signal');
if length(SInput)>2;title(lg,VSInput);end;ax1.FontName='Times New Roman';ax1.FontWeight='bold';
ax1.FontSize=10;xlim(ax1,[time11 time22]);

plotline(2)=plot(ax2,Tim,DataFilter);xlabel(ax2,VStime);ylabel(ax2,'Voltage');
lg=legend(ax2,'Filtered signal');if length(SInput)>2;title(lg,VSInput);end
ax2.FontName='Times New Roman';ax2.FontWeight='bold';ax2.FontSize=10;xlim(ax2,[time11 time22]);

mi=min(min(Input),min(DataFilter));ma=max(max(Input),max(DataFilter));
ylim(ax1,[mi ma]);ylim(ax2,[mi ma])
set(plotline,'uicontextmenu',CM);set(ax1,'uicontextmenu',cm);set(ax2,'uicontextmenu',cm);  
% [~,KK]=size(Data);[~,KKK]=size(Input);j=0;
% if (KK~=1)&&(KKK~=1)&&(VInput~=2)
%     for i=1:KK
%         p(j+i) = subplot(2,1,1,'Parent',ax1);plotline(j+i)=plot(p(j+i),Tim,Input(:,i));%#ok
%         p(i+j).XTick=[];hold on;ylabel(p(j+i),'Amplitude');%#ok
%         if i==KK;lg=legend(SInput(3:end));title(lg,'Raw Signal');end;%#ok
%         p(2*i)=subplot(2,1,2,'Parent',ax1);plotline(2*i)=plot(p(2*i),Tim,DataFilter(:,i));%#ok
%         hold on;ylabel(p(2*i),'Amplitude');
%         if i==KK;lg=legend(SInput(3:end));title(lg,'Filtered signal');end;j=j+1;
%         xlabel(p(2*i),char(VStime));
%     end
%     p(j+i).FontName='Times New Roman';p(j+i).FontWeight='bold';p(j+i).FontSize=10;
%     p(2*i).FontName='Times New Roman';p(2*i).FontWeight='bold';p(2*i).FontSize=10;
% elseif (KK==1)&&(KKK==1)&&(VInput~=2)
%     p(1)=subplot(2,1,1,'Parent',ax1);plotline(1)=plot(p(1),Tim,Input);
%     ylabel(p(1),'Amplitude');p(1).XTick=[];legend('Raw Signal');xlim(p(1),[time11 time22])
%     p(1).FontName='Times New Roman';p(1).FontWeight='bold';p(1).FontSize=10;
%     p(2)=subplot(2,1,2,'Parent',ax1);plotline(2)=plot(p(2),Tim,DataFilter);
%     ylabel(p(2),'Amplitude');xlim(p(2),[time11 time22]);xlabel(p(2),char(VStime));legend('Filtered Signal');
%     p(2).FontName='Times New Roman';p(2).FontWeight='bold';p(2).FontSize=10;
% elseif (KK~=1)&&(KKK==1)&&(VInput~=2)
%     p(1)=subplot(2,1,1,'Parent',ax1);plotline(1)=plot(p(1),Tim,Input);
%     p(1).XTick=[];lg=legend(VSInput);title(lg,'Filter Signal');xlim(p(1),[time11 time22])
%     ylabel(p(1),'Amplitude');p(1).FontName='Times New Roman';p(1).FontWeight='bold';p(1).FontSize=10;
%     p(2)=subplot(2,1,2,'Parent',ax1);plotline(2)=plot(p(2),Tim,DataFilter);
%     lg=legend(VSInput);title(lg,'Filter Signal');xlim(p(2),[time11 time22])
%     ylabel(p(2),'Amplitude');xlabel(p(2),char(VStime));
%     p(2).FontName='Times New Roman';p(2).FontWeight='bold';p(2).FontSize=10;
% elseif VInput==2
%     Ki=Vchi:Vchj;u=[];for i=1:KKK;u= [u;'Ch',num2str(Ki(i))];end;%#ok
%     for i=1:KKK
%         p(i+j) = subplot(2,1,1,'Parent',ax1);plotline(j+i)=plot(p(i+j),Tim,Input(:,i));%#ok
%         ylabel(p(i+j),'Amplitude','FontName','Times New Roman');p(i+j).XTick=[]; hold on;%#ok
%         if i==KKK;lg=legend(u);title(lg,'Raw Signal');end;xlim([time11 time22])
%         p(2*i)=subplot(2,1,2,'Parent',ax1);plotline(2*i)=plot(p(2*i),Tim,DataFilter(:,i));%#ok
%         ylabel(p(2*i),'Amplitude','FontName','Times New Roman');xlim([time11 time22])
%         xlabel(p(2*i),char(VStime),'FontName','Times New Roman');hold on;
%         if i==KKK;lg=legend(u);title(lg,'Filtered Signal');end;j=j+1;
%     end
%     p(j+i).FontName='Times New Roman';p(j+i).FontWeight='bold';p(j+i).FontSize=10;
%     p(2*i).FontName='Times New Roman';p(2*i).FontWeight='bold';p(2*i).FontSize=10;
% end
end


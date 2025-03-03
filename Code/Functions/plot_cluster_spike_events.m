function MeanSpike = plot_cluster_spike_events(spikes,Labels,fss,plotSU,ax15,cm)

ax15.NextPlot='replaceall';cla(ax15);axes(ax15);MeanSpike=0;

if get(plotSU,'value')==1

if Labels==0;msgbox('Please Set Cluster Parameters in Section Clustering','','warn');return;end
if spikes==0;msgbox('Please Set Spike Detection Parameters in Section Spike Detection','','warn');return;end
if isnan(fss)||(fss<=0);fss=str2double(inputdlg({'Enter Fs'},'Sampling Frequency ',[1 45]));
if isnan(sum(fss(:)))||isempty(fss);msgbox('Please Enter Fs as scalars','','warn');return;end
end

Time=(0:size(spikes,2)-1)*1000/fss;L=unique(Labels);Col=hsv(length(L));
Tlegend=cell(length(L),1);j=0;
Y=zeros(1,length(L));MeanSpike=zeros(length(L),size(spikes,2));
for i=L
I=find(Labels==i);j=j+1/length(L)+0.1;MeanSpike(i,:)=mean(spikes(I,:)); 
P(i)=plot(ax15,Time,mean(spikes(I,:)),'color',Col(i,:),'LineWidth',2);ax15.NextPlot='add';%#ok
plot(ax15,Time,spikes(I,:)+j,'color',Col(i,:));ax15.NextPlot='add';
Tlegend{i}=['class ' num2str(i),'; #',num2str(length(I))];
if i==L(end);Max=max(max(spikes(I,:)));end;Y(i)=min(mean(spikes(I,:)));
end 
axis(ax15,[0 Time(end) min(Y) Max+j]);xlabel(ax15,'Time (msec)');ylabel(ax15,'Amp');
legend(P,Tlegend);ax15.FontWeight='bold';ax15.FontName='Times New Roman';ax15.FontSize=10;
set(ax15,'uicontextmenu',cm);msgbox('Operation Completed');

end
end
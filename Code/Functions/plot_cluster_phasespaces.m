function MeanPhaseSpaces = plot_cluster_phasespaces(spikes,Labels,plotPhU,ax16,cm)

ax16.NextPlot='replaceall';cla(ax16);axes(ax16);MeanPhaseSpaces=0;

if get(plotPhU,'value')==1

if Labels==0;msgbox('Please Set Cluster Parameters in Section Clustering','','warn');return;end
if spikes==0;msgbox('Please Set Spike Detection Parameters in Section Spike Detection','','warn');return;end

L=unique(Labels);Col=hsv(length(L));Tlegend=cell(length(L),1);j=0;
Y=zeros(1,length(L));MeanPhaseSpaces=zeros(length(L),size(spikes,2)-1);
for i=L
I=find(Labels==i);j=j+1/length(L)+0.5; 
Diff1=diff(spikes(I,:),1,2);MeanPhaseSpaces(i,:)=mean(Diff1);
P(i)=plot(ax16,mean(Diff1),mean(spikes(I,1:end-1)),'color',Col(i,:),'LineWidth',2);ax16.NextPlot='add';%#ok
plot(ax16,Diff1,spikes(I,1:end-1)+j,'.','color',Col(i,:));ax16.NextPlot='add';
Tlegend{i}=['class ' num2str(i),'; #',num2str(length(I))];
if i==L(end);Max=max(max(spikes(I,:)));end;Y(i)=min(mean(spikes(I,:)));
end 
xlabel(ax16,'First Derivative (Amp/ms)');ylabel(ax16,'Amp');ylim(ax16,[min(Y) Max+j])
legend(P,Tlegend);ax16.FontWeight='bold';ax16.FontName='Times New Roman';ax16.FontSize=10;
set(ax16,'uicontextmenu',cm);msgbox('Operation Completed');

end
end
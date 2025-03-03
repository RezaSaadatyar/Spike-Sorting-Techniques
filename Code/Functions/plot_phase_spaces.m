function Diff1 = plot_phase_spaces(spikes,dphaspace,ax7,cm)

cla(ax7);axes(ax7);Diff1=0;ax7.NextPlot='replaceall';

if get(dphaspace,'value')==1
if length(spikes)<2;msgbox('Please Load Spikes(i.e., Set Parameters Spike Detection)','','warn');return;end

Diff1=diff((spikes),1,2);
for i=1:size(spikes,1)/2
plot(ax7,Diff1(i,:),spikes(i,1:end-1),'Color',[176,176,176]/255);ax7.NextPlot='add';
end
ax7.NextPlot='add';plot(mean(Diff1),mean(spikes(:,1:end-1)),'k','linewidth',2)
ylabel(ax7,'Amp');xlabel(ax7,'First Derivative (Amp/ms)');ax7.FontName='Times New Roman';
ax7.FontWeight='bold';ax7.FontSize=10;set(ax7,'uicontextmenu',cm);msgbox('Operation Completed')
end
end
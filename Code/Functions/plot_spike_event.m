%% =============================================================================================
% ================================= Spike Extraction Software ==================================
% ================================ Presented by: Reza Saadatyar ================================
% ============================== Email: Reza.Saadatyar@outlook.com =============================
% ======================================= 2019-2020 ============================================

function plot_spike_event(spikes,fss,dspikeven,ax6,cm)

cla(ax6);axes(ax6);ax6.NextPlot='replaceall';

if get(dspikeven,'value')==1
if length(spikes)<2;msgbox('Please Load Spikes(i.e., Set Parameters Spike Detection)','','warn');return;end
if isnan(fss)||(fss<=0);fss=str2double(inputdlg({'Enter Fs'},'Sampling frequency',[1 44]));
if isnan(fss);msgbox('Please enter Fs','','warn');return;end
if isempty(fss);msgbox('Please enter Fs','','warn');return;end   
end
Time=(0:size(spikes,2)-1)*1000/fss;
plot(ax6,Time,spikes,'Color',[176,176,176]/255);ax6.NextPlot='add';
plot(ax6,Time,mean(spikes),'k','linewidth',2);
xlim(ax6,[0 Time(end)]);xlabel(ax6,'Time (msec)')
ax6.FontName='Times New Roman';ax6.FontWeight='bold';ax6.FontSize=10;ylabel(ax6,{'Amp';'Normalized'});
set(ax6,'uicontextmenu',cm);msgbox('Operation Completed')
end
end
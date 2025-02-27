function pcafea=plot_pca(spikes,PcaSpik,Feat1,Feat2,Feat3,dispca,diswave,ax8,ax9,ax10,ax11,cm,S)

set(diswave,'value',0);pcafea=0;ax8.NextPlot='replaceall';ax9.NextPlot='replaceall';
ax10.NextPlot='replaceall';ax11.NextPlot='replaceall';S.inpclust.Value=1;S.plotc.Value=0;
cla(ax8);axes(ax8);cla(ax9);axes(ax9);cla(ax10);axes(ax10);cla(ax11);axes(ax11);

if get(dispca,'value')==1

if length(spikes)<2;msgbox('Please Load Spikes(i.e., Eneter Parameters Spike Detection)','','warn');return;end
if length(PcaSpik)<2;msgbox('Please Select Active PCA','','warn');return;end    

Feat1=str2double(get(Feat1,'string'));Feat2=str2double(get(Feat2,'string'));Feat=str2double(get(Feat3,'string'));

if S.plot2D.Value==1;set(Feat3,'enable','off')
if isnan(Feat1)||isnan(Feat2)||(Feat1==Feat2)||(Feat1>size(spikes,2))||(Feat2>size(spikes,2))
msgbox(['Please Enter Feature 1 & Feature 2; Feature 1 ~= Feature 2; Feature 1 & Feature 2 < ',num2str(size(spikes,2))],'','warn');return;end
else;set(Feat3,'enable','on')
if isnan(Feat1)||isnan(Feat2)||isnan(Feat)||(Feat1==Feat)||(Feat2==Feat)||(Feat1>size(spikes,2))||(Feat2>size(spikes,2))||(Feat>size(spikes,2))
msgbox(['Please Enter Feature 3; Feature 3 ~= Feature 1 & Feature 2; Feature 3 < ',num2str(size(spikes,2))],'','warn');return;end    
end
til='PCA';

PcaSpik=(PcaSpik-min(PcaSpik))./(max(PcaSpik)-min(PcaSpik));

PF(spikes,PcaSpik,Feat1,Feat2,Feat3,Feat,til,ax8,ax9,ax10,ax11,cm,S)

if S.plot2D.Value==1;pcafea=PcaSpik(:,[Feat1 Feat2]);elseif S.plot3D.Value==1;pcafea=PcaSpik(:,[Feat1 Feat2 Feat]);end

end
end
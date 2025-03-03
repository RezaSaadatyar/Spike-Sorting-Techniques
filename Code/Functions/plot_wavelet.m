function wavfea = plot_wavelet(spikes,waveletSpik,Feat31,Feat32,Feat33,dispca,diswave,...
ax8,ax9,ax10,ax11,cm,S)

wavfea=0;set(dispca,'value',0);cla(ax8);axes(ax8);cla(ax9);axes(ax9);cla(ax10);
axes(ax10);cla(ax11);axes(ax11);ax8.NextPlot='replaceall';ax9.NextPlot='replaceall';
ax10.NextPlot='replaceall';ax11.NextPlot='replaceall';S.inpclust.Value=1;S.plotc.Value=0;

if get(diswave,'value')==1    

if length(spikes)<2;msgbox('Please Load Spikes(i.e., Eneter Parameters Spike Detection)','','warn');return;end
if length(waveletSpik)<2;msgbox('Please Select Make Spike Wavelet','','warn');return;end    

F1=str2double(get(Feat31,'string'));F2=str2double(get(Feat32,'string'));
F3=str2double(get(Feat33,'string'));  

if S.plot2D.Value==1;set(Feat33,'enable','off')
if isnan(F1)||isnan(F2)||(F1==F2)||(F1>size(spikes,2))||(F2>size(spikes,2))
msgbox(['Please Enter Feature 1 & Feature 2; Feature 1 ~= Feature 2; Feature 1 & Feature 2 < ',num2str(size(spikes,2))],'','warn');return;end
else;set(Feat33,'enable','on')
if isnan(F1)||isnan(F2)||isnan(F3)||(F1==F3)||(F2==F3)||(F3>size(spikes,2))||(F1>size(spikes,2))||(F2>size(spikes,2))
msgbox(['Please Enter Feature 3; Feature 3 ~= Feature 1 & Feature 2; Feature 3 < ',num2str(size(spikes,2))],'','warn');return;end    
end
til='Wavelet';

waveletSpik=(waveletSpik-min(waveletSpik))./(max(waveletSpik)-min(waveletSpik));

PF(spikes,waveletSpik,F1,F2,Feat33,F3,til,ax8,ax9,ax10,ax11,cm,S)

if S.plot2D.Value==1;wavfea=waveletSpik(:,[F1 F2]);
elseif S.plot3D.Value==1;wavfea=waveletSpik(:,[F1 F2 F3]);end

end
end
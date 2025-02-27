function PF(spikes,FSpik,Feat1,Feat2,Feat3,Feat,til,ax8,ax9,ax10,ax11,cm,S)

if S.plot2D.Value==1
   
   plot(ax8,spikes(:,Feat1),spikes(:,Feat2),'.');title(ax8,'Spikes')
   xlabel(ax8,['Feature ',num2str(Feat1)]);ylabel(ax8,['Feature ',num2str(Feat2)]);
   ax8.FontWeight='bold';ax8.FontName='Times New Roman';ax8.FontSize=10;ax8.XGrid='on';
   ax8.YGrid='on';ax8.XMinorGrid='on';ax8.YMinorGrid='on';
   
   hist1=histogram(ax9,spikes(:,Feat1),50,'Normalization','probability','EdgeColor','r','FaceColor','r');ax9.NextPlot='add';
   hist2=histogram(ax9,spikes(:,Feat2),50,'Normalization','probability','EdgeColor','g','FaceColor','g');ax9.NextPlot='add';
   pd=fitdist(spikes(:,Feat1),'Kernel','Kernel','epanechnikov');pdfEst=pdf(pd,hist1.BinEdges);ax9.NextPlot='add';
   plot(ax9,hist1.BinEdges,pdfEst*max(hist1.Values)/max(pdfEst),'--r','LineWidth',2.5);
   pd=fitdist(spikes(:,Feat2),'Kernel','Kernel','epanechnikov');pdfEst=pdf(pd,hist2.BinEdges);ax9.NextPlot='add';
   plot(ax9,hist2.BinEdges,pdfEst*max(hist2.Values)/max(pdfEst),'g','LineWidth',2.5);
   ax9.FontWeight='bold';ax9.FontName='Times New Roman';ax9.FontSize=10;ax9.YGrid='on';ylabel(ax9,'Probability')
   legend(ax9,{['Feature ',num2str(Feat1)],['Feature ',num2str(Feat2)]},'Orientation','horizontal');
   
   plot(ax10,FSpik(:,Feat1),FSpik(:,Feat2),'.');ax10.FontSize=10;ax10.XGrid='on';ax10.YGrid='on';
   xlabel(ax10,['Feature ',num2str(Feat1)]);ylabel(ax10,['Feature ',num2str(Feat2)]);title(ax10,til)
   ax10.FontWeight='bold';ax10.FontName='Times New Roman';ax10.FontSize=10;ax10.XMinorGrid='on';
   ax10.YMinorGrid='on';
    
   hist1=histogram(ax11,FSpik(:,Feat1),50,'Normalization','probability','EdgeColor','r','FaceColor','r');ax11.NextPlot='add';
   hist2=histogram(ax11,FSpik(:,Feat2),50,'Normalization','probability','EdgeColor','g','FaceColor','g');
   pd=fitdist(FSpik(:,Feat1),'Kernel','Kernel','epanechnikov');pdfEst=pdf(pd,hist1.BinEdges);ax11.NextPlot='add';
   plot(ax11,hist1.BinEdges,pdfEst*max(hist1.Values)/max(pdfEst),'--r','LineWidth',2.5);
   pd=fitdist(FSpik(:,Feat2),'Kernel','Kernel','epanechnikov');pdfEst=pdf(pd,hist2.BinEdges);ax11.NextPlot='add';
   plot(ax11,hist2.BinEdges,pdfEst*max(hist2.Values)/max(pdfEst),'g','LineWidth',2.5);
   ax11.FontWeight='bold';ax11.FontName='Times New Roman';ax11.FontSize=10;ax11.YGrid='on';ylabel(ax11,'Probability')
   legend(ax11,{['Feature ',num2str(Feat1)],['Feature ',num2str(Feat2)]},'Orientation','horizontal'); 

elseif S.plot3D.Value==1
   set(Feat3,'enable','on')
   if isnan(Feat)||(Feat1==Feat)||(Feat2==Feat)||(Feat>size(spikes,2))
   msgbox(['Please Enter Feature 3; Feature 3 ~= Feature 1 & Feature 2; Feature 3 < ',num2str(size(spikes,2))],'','warn');return;end
   plot3(ax8,spikes(:,Feat1),spikes(:,Feat2),spikes(:,Feat),'.');title(ax8,'Spikes');
   xlabel(ax8,['Feature ',num2str(Feat1)]);ylabel(ax8,['Feature ',num2str(Feat2)]);zlabel(ax8,['Feature ',num2str(Feat)])
   ax8.FontWeight='bold';ax8.FontName='Times New Roman';ax8.FontSize=10;ax8.XMinorGrid='on';ax8.YMinorGrid='on';
   ax8.ZMinorGrid='on';
   
   hist1=histogram(ax9,spikes(:,Feat1),50,'Normalization','probability','EdgeColor','r','FaceColor','r');ax9.NextPlot='add';
   hist2=histogram(ax9,spikes(:,Feat2),50,'Normalization','probability','EdgeColor','g','FaceColor','g');ax9.NextPlot='add';
   hist3=histogram(ax9,spikes(:,Feat),50,'Normalization','probability','EdgeColor','b','FaceColor','b');ax9.NextPlot='add';
   pd=fitdist(spikes(:,Feat1),'Kernel','Kernel','epanechnikov');pdfEst=pdf(pd,hist1.BinEdges);ax9.NextPlot='add';
   plot(ax9,hist1.BinEdges,pdfEst*max(hist1.Values)/max(pdfEst),'--r','LineWidth',2.5);
   pd=fitdist(spikes(:,Feat2),'Kernel','Kernel','epanechnikov');pdfEst=pdf(pd,hist2.BinEdges);ax9.NextPlot='add';
   plot(ax9,hist2.BinEdges,pdfEst*max(hist2.Values)/max(pdfEst),'g','LineWidth',2.5);
   pd=fitdist(spikes(:,Feat),'Kernel','Kernel','epanechnikov');pdfEst=pdf(pd,hist3.BinEdges);ax9.NextPlot='add';
   plot(ax9,hist3.BinEdges,pdfEst*max(hist3.Values)/max(pdfEst),'b','LineWidth',2.5);
   ax9.FontWeight='bold';ax9.FontName='Times New Roman';ax9.FontSize=10;ax9.YGrid='on';ylabel(ax9,'Probability')
   legend(ax9,{['Feature ',num2str(Feat1)],['Feature ',num2str(Feat2)],['Feature ',num2str(Feat)]},'Orientation','horizontal');
   
   plot3(ax10,FSpik(:,Feat1),FSpik(:,Feat2),FSpik(:,Feat),'.');ax10.XMinorGrid='on';ax10.YMinorGrid='on';
   ax10.ZMinorGrid='on';xlabel(ax10,['Feature ',num2str(Feat1)]);ylabel(ax10,['Feature ',num2str(Feat2)]);
   zlabel(ax10,['Feature ',num2str(Feat)]);ax10.FontWeight='bold';ax10.FontName='Times New Roman';
   ax10.FontSize=10;title(ax10,til)
   
   hist1=histogram(ax11,FSpik(:,Feat1),50,'Normalization','probability','EdgeColor','r','FaceColor','r');ax11.NextPlot='add';
   hist2=histogram(ax11,FSpik(:,Feat2),50,'Normalization','probability','EdgeColor','g','FaceColor','g');ax11.NextPlot='add';
   hist3=histogram(ax11,FSpik(:,Feat),50,'Normalization','probability','EdgeColor','b','FaceColor','b');
   pd=fitdist(FSpik(:,Feat1),'Kernel','Kernel','epanechnikov');pdfEst=pdf(pd,hist1.BinEdges);ax11.NextPlot='add';
   plot(ax11,hist1.BinEdges,pdfEst*max(hist1.Values)/max(pdfEst),'--r','LineWidth',2.5);
   pd=fitdist(FSpik(:,Feat2),'Kernel','Kernel','epanechnikov');pdfEst=pdf(pd,hist2.BinEdges);ax11.NextPlot='add';
   plot(ax11,hist2.BinEdges,pdfEst*max(hist2.Values)/max(pdfEst),'g','LineWidth',2.5);
   pd=fitdist(FSpik(:,Feat),'Kernel','Kernel','epanechnikov');pdfEst=pdf(pd,hist3.BinEdges);ax11.NextPlot='add';
   plot(ax11,hist3.BinEdges,pdfEst*max(hist3.Values)/max(pdfEst),':b','LineWidth',2.5);
   ax11.FontWeight='bold';ax11.FontName='Times New Roman';ax11.FontSize=10;ax11.YGrid='on';ylabel(ax11,'Probability')
   legend(ax11,{['Feature ',num2str(Feat1)],['Feature ',num2str(Feat2)],['Feature ',num2str(Feat)]},'Orientation','horizontal');
end
set(ax8,'uicontextmenu',cm);set(ax9,'uicontextmenu',cm);set(ax10,'uicontextmenu',cm);set(ax11,'uicontextmenu',cm);
end
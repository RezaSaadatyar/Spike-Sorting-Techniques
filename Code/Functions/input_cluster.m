function InputClust = input_cluster(pcafea,wavfea,plotc,inpclust,cursor,numcl,ax12,cm,S)

InputClust=0;S.auto.Value=0;S.manual.Value=0;set(numcl,'value',1)
ax12.NextPlot='replaceall';%cla(ax12);axes(ax12);

if get(inpclust,'value')==1
   msgbox('Please Select Input Type in Section Clustering','','warn');return  
elseif get(inpclust,'value')==2
if size(pcafea,1)<=1;msgbox('Please Select PCA Analysis in Section Feature Extraction','','warn');return;end
InputClust=pcafea;til='PCA';
if size(InputClust,2)==2
Feat1=['Feature ' S.Feat1.String];Feat2=['Feature ' S.Feat2.String];else;Feat1=['Feature ' S.Feat1.String];
Feat2=['Feature ' S.Feat2.String];Feat3=['Feature ' S.Feat3.String];
end
elseif get(inpclust,'value')==3
if size(wavfea,1)<=1;msgbox('Please Select Wavelet Analysis in Section Feature Extraction','','warn');return;end
InputClust=wavfea;til='Wavelet';
if size(InputClust,2)==2
Feat1=['Feature ' S.Feat31.String];Feat2=['Feature ' S.Feat32.String];else;Feat1=['Feature ' S.Feat31.String];
Feat2=['Feature ' S.Feat32.String];Feat3=['Feature ' S.Feat33.String];
end
end

if get(plotc,'value')==1
if size(InputClust,2)==2 
plot(ax12,InputClust(:,1),InputClust(:,2),'.');xlabel(ax12,Feat1);ylabel(ax12,Feat2);
title(ax12,til);ax12.FontWeight='bold';ax12.FontName='Times New Roman';ax12.FontSize=10;
ax12.XMinorGrid='on';ax12.YMinorGrid='on';dcm=datacursormode;dcm.Enable='off';dcm.DisplayStyle='datatip';
dcm.UpdateFcn=@displayCoordinates;if get(cursor,'value')==1;dcm.Enable='on';end
elseif size(InputClust,2)==3   
plot3(ax12,InputClust(:,1),InputClust(:,2),InputClust(:,3),'.');xlabel(ax12,Feat1);ylabel(ax12,Feat2);
zlabel(ax12,Feat3);title(ax12,til);ax12.FontWeight='bold';ax12.FontName='Times New Roman';ax12.FontSize=10;
ax12.XMinorGrid='on';ax12.YMinorGrid='on';dcm=datacursormode;dcm.Enable='on';dcm.DisplayStyle='datatip';
dcm.UpdateFcn=@displayCoordinates3D;if get(cursor,'value')==1;dcm.Enable='off';end
end
set(ax12,'uicontextmenu',cm); 
end
end
function Raster=plot_raster(xf,index,Labels,fss,plotR,time4,ax14,cm)

ax14.NextPlot='replaceall';cla(ax14);axes(ax14);Raster=0;

if get(plotR,'value')~=1

if Labels==0;msgbox('Please Set Cluster Parameters in Section Clustering','','warn');return;end
if index==0;msgbox('Please Set Spike Detection Parameters in Section Spike Detection','','warn');return;end
if isnan(fss)||(fss<=0);fss=str2double(inputdlg({'Enter Fs'},'Sampling Frequency ',[1 45]));
if isnan(sum(fss(:)))||isempty(fss);msgbox('Please Enter Fs as scalars','','warn');return;end
end

Time=(0:length(xf)-1);L=unique(Labels);Col=hsv(length(L));NClass=1/length(L);Tim='Sample';

if get(plotR,'value')==3;Time=Time/fss;index=index/fss;Tim='Time (Sec)';
elseif get(plotR,'value')==4;Time=Time/fss/60;index=index/fss/60;Tim='Time (Min)';
elseif get(plotR,'value')==5;Time=Time/fss/3600;index=index/fss/3600;Tim='Time (Hour)';
end

j=0;Raster=zeros(length(Labels),length(L));
for i=L
I=find(Labels==i);Raster(I,i)=1; 
plot(ax14,[index(I)' index(I)'],[j NClass+j],'color',Col(i,:));j=j+NClass;      
ax14.NextPlot='add';
end   
ax14.YTick=[];ax14.FontWeight='bold';ax14.FontName='Times New Roman';
ax14.FontSize=10;xlabel(ax14,Tim);set(ax14,'uicontextmenu',cm);xlim(ax14,[0 Time(end)]);
msgbox('Operation Completed');
end
end
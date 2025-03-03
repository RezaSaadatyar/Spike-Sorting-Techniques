function plot_isi(ISI,ISI_centers,plotISI,bin,ax21,ax22,cm)

ax21.NextPlot='replaceall';cla(ax21);subplot(1,1,1,'replace','Parent',ax22);

if get(plotISI,'value')==1
    
Bin=str2double(get(bin,'string'));

if ISI==0;msgbox('Please Select ISI & Autocorrelogram parameters','','warn');return;end
if isnan(Bin)||(Bin<=0);msgbox('Please Enter Bin > 0','','warn');return;end

 if size(ISI,1)<2
     bar(ax21,ISI_centers,ISI(1:end),'FaceColor','k','EdgeColor','k');ax21.NextPlot='add';
     bar(ax21,abs(ISI_centers(find(ISI(1,:),1,'first'))-Bin*1000)/2,max(ISI(1,:)),'r','EdgeColor','r','BarWidth',2);
     labels1=['Refractory Period(',num2str(abs(ISI_centers(find(ISI(1,:),1,'first'))-Bin*1000)),'ms)'];
     text(ISI_centers(find(ISI(1,:),1,'first')),max(ISI(1,:)),labels1,'HorizontalAlignment','left','Color',...
    'r','FontSize',10,'FontWeight','bold','FontName','Times New Roman')
     xlabel(ax21,'ISI (ms)');ylabel(ax21,'Number of Spikes');
     title(ax21,['Interspike Interval Histograms; bin = ' num2str(Bin*1000) ' ms']);
     ax21.FontWeight='bold';ax21.FontName='Times New Roman';ax21.FontSize=10;  
 end
if size(ISI,1)>1
    bar(ax21,ISI_centers,ISI(1,1:end),'FaceColor','k','EdgeColor','k');
     title(ax21,['Interspike Interval Histograms for multi Units; bin = ' num2str(Bin*1000) ' ms']);
     xlabel(ax21,'ISI (ms)');ylabel(ax21,'Number of Spikes');
     ax21.FontWeight='bold';ax21.FontName='Times New Roman';ax21.FontSize=10;
     subplot(1,1,1,'replace','Parent',ax22);Ma=max(max(ISI(2:end,:)));    
     for i=2:size(ISI,1)
         p(i-1)=subplot(size(ISI,1)-1,1,i-1);%#ok
         bar(p(i-1),ISI_centers,ISI(i,1:end),'FaceColor','k','EdgeColor','k');hold on;
         bar(p(i-1),abs(ISI_centers(find(ISI(i,:),1,'first'))-Bin*1000)/2,max(ISI(i,:)),'r','EdgeColor','r','BarWidth',2);
         
         u1=['Uint ',num2str(i-1)];
         u2=['Refractory Period: ',num2str(abs(ISI_centers(find(ISI(i,:),1,'first'))-Bin*1000)),'ms'];
         legend({u1,u2});ylim([0 Ma+1]);
         if i==2;title(['Interspike Interval Histograms, bin = ' num2str(Bin*1000) ' ms']);end
         if i~=size(ISI,1);ax.XTick=[];end
         ax=gca;ax.FontWeight='bold';ax.FontName='Times New Roman';ax.FontSize=10;ylabel('Number of Spikes');  
     end
     xlabel('ISI (ms)')
end
set(p,'uicontextmenu',cm);set(ax21,'uicontextmenu',cm);msgbox('Operation Completed')
end
end
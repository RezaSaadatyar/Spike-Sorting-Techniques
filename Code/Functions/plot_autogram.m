function plot_autogram(Autoc,Xbin,plotautogram,maxnInte,minInte,bin,ax23,ax24,cm)

ax23.NextPlot='replaceall';cla(ax23);subplot(1,1,1,'replace','Parent',ax24);

if get(plotautogram,'value')

Bin=str2double(get(bin,'string'));Min_Interval=str2double(get(minInte,'string'));
Max_Interval=str2double(get(maxnInte,'string'));

if Autoc==0;msgbox('Please Set Parameters in Section ISI & Autocorrelogram','','warn');return;end
if isnan(Bin)||(Bin<=0);msgbox('Please Enter Bin > 0','','warn');return;end
if isnan(Min_Interval)||(Min_Interval<0);msgbox('Please Enter Min_Interval >= 0','','warn');return;end
if isnan(Max_Interval)||(Max_Interval<0)||(Max_Interval<=Min_Interval);msgbox('Please Enter Max_Interval > Min_Interval','','warn');return;end
  
 if size(Autoc,1)<2
     bar(ax23,Xbin,Autoc,'FaceColor','k','EdgeColor','k'); 
     xlabel(ax23,'Time (ms)');ylabel(ax23,'Number of Spikes');
     title(ax23,['Autocorrelograms; bin = ' num2str(Bin*1000) ' ms']);
     ax23.FontWeight='bold';ax23.FontName='Times New Roman';ax23.FontSize=10;    
 end  
  if size(Autoc,1)>1
     bar(ax23,Xbin,Autoc(1,:),'FaceColor','k','EdgeColor','k');
     title(ax23,['Autocorrelograms for multi Units; bin = ' num2str(Bin*1000) ' ms']);
     xlabel(ax23,'Time (ms)');ylabel(ax23,'Spikes/Sec');ax23.FontWeight='bold';
     ax23.FontName='Times New Roman';ax23.FontSize=10;
     subplot(1,1,1,'replace','Parent',ax24);Ma=max(max(Autoc(2:end,:)));
     for i=2:size(Autoc,1)
         p(i-1)=subplot(size(Autoc,1)-1,1,i-1);%#ok
         bar(p(i-1),Xbin,Autoc(i,:),'FaceColor','k','EdgeColor','k');
         ylabel('Spikes/Sec');legend(['Uint ',num2str(i-1)]);ax=gca;ax.FontWeight='bold';
         ax.FontName='Times New Roman';ax.FontSize=10;if i~=size(Autoc,1);ax.XTick=[];end
         if i==2;title(['Autocorrelograms, bin = ' num2str(Bin*1000) ' ms']);end;ylim([0 Ma+1]);   
     end
  end
xlabel('Time (ms)');set(ax23,'uicontextmenu',cm);set(p,'uicontextmenu',cm);msgbox('Operation Completed')
end
end
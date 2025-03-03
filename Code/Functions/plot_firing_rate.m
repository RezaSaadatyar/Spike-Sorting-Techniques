%% =============================================================================================
% ================================= Spike Extraction Software ==================================
% ================================ Presented by: Reza Saadatyar ================================
% ============================== Email: Reza.Saadatyar@outlook.com =============================
% ======================================= 2019-2020 ============================================

function plot_firing_rate(Firing_Rate,Time_Firing,binTime,binFR,ax19,ax20,cm,S)

ax19.NextPlot='replaceall';subplot(1,1,1,'replace','Parent',ax20);

Win=str2double(get(binFR,'string'));til='Time (Second)';ti=['; bin = ', num2str(Win) ' Sec'];
typ='Spikes/Sec';


if Firing_Rate==0;msgbox('Please Select Firing Rate parameters','','warn');return;end
if isnan(Win)||(Win<=0);msgbox('Please Enter Bin > 0','','warn');return;end 
if get(binTime,'value')==3;til='Time (Minute)';typ='SpikeS/Min';ti=['; bin = ', num2str(Win) ' Min'];
elseif get(binTime,'value')==4;til='Time (Hour)';typ='SpikeS/Hour';ti=['; bin = ', num2str(Win) ' Hour'];end
if S.spikepersec.Value==1;xlab=1;else;xlab=Win;typ='Counts/bin';ti='';end

if size(Firing_Rate, 1)<2
    for i=1:size(Firing_Rate,1);bar(ax19,Time_Firing+Win,Firing_Rate*xlab,'FaceColor','k','EdgeColor','k');end
    ax19.FontWeight='bold';ax19.FontName='Times New Roman';ax19.FontSize=10;
    title(ax19,['Firing Rate Histograms' ti]);
    xlabel(ax19,til);ylabel(ax19,typ);
end
if size(Firing_Rate,1)>1
    bar(ax19,Time_Firing+Win,Firing_Rate(1,:)*xlab,'FaceColor','k','EdgeColor','k');
    ax19.FontWeight='bold';ax19.FontSize=10;ax19.FontName='Times New Roman';title(ax19,['Firing Rate for all uint' ti]);
    xlabel(ax19,til);ylabel(ax19,typ);subplot(1,1,1,'replace','Parent',ax20);Ma=max(max(Firing_Rate(2:end,:)));    
    for i=2:size(Firing_Rate,1)
        p(i-1)=subplot(size(Firing_Rate,1)-1,1,i-1);bar(p(i-1),Time_Firing+Win,Firing_Rate(i,:)*xlab,'FaceColor','k','EdgeColor','k');%#ok
        ax=gca;ax.FontWeight='bold';ax.FontName='Times New Roman';ax.FontSize=10;
        if i==2;title(['Firing Rate Histograms' ti]);end
        if i~=size(Firing_Rate,1);ax.XTick=[];end;ylabel(typ);
        legend(['Unit ',num2str(i-1)]);ylim([0 Ma*xlab+2]);
    end
    xlabel(til)
end
set(ax19,'uicontextmenu',cm);set(p,'uicontextmenu',cm);msgbox('Operation Completed')
end
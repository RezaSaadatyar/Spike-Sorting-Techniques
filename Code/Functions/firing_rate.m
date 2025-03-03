%% =============================================================================================
% ================================= Spike Extraction Software ==================================
% ================================ Presented by: Reza Saadatyar ================================
% ============================== Email: Reza.Saadatyar@outlook.com =============================
% ======================================= 2019-2020 ============================================

function [Firing_Rate, Time_Firing] = firing_rate(xf, fss, index, Labels, binTime, binFR,S)

Firing_Rate=0;Time_Firing=0;S.spikepersec.Value=0;S.countperbin.Value=0;
Win=str2double(get(binFR,'string')); VbinTime=get(binTime,'value');

if length(xf)<2;msgbox('Please Select Input Type in Block Spike Detection','','warn');return;end
if Labels==0;msgbox('Please Enter Parameters Cluster in Section Clustring','','warn');return;end%&&
if index==0;msgbox('Please Set Spike Detection Parameters in Section Spike Detection','','warn');return;end
if isnan(Win)||(Win<=0);msgbox('Please Enter Bin > 0','','warn');return;end
if isnan(fss)||(fss<=0);fss=str2double(inputdlg({'Enter Fs'},'Sampling Frequency ',[1 45]));
if isnan(sum(fss(:)))||isempty(fss);msgbox('Please Enter Fs as scalars','','warn');return;end
end       

Time = (0:length(xf)-1)/fss; index=index/fss;
if Time(end)<1; msgbox('Totall time < 1 Second','','warn');return;end  
% if VbinTime==3; Time=Time/60;index=index/60;
% if Time(end)<1;msgbox('Please Select Second; Totall time < 60 Second','','warn');return;end    
% elseif VbinTime==4;Time=Time/3600;index=index/3600;
% if Time(end)<1;msgbox('Please Select Minute; Totall time < 60 Minute','','warn');return;end      
% end

%% ==================================== firing rate multi unit =================================
if max(Labels)>1;Firing_Rate=zeros(max(Labels)+1,length(Time_Firing));else
Firing_Rate=zeros(1,length(Time_Firing));end

spk_times=index';Time_Firing=min(Time):Win:max(Time);
for i=1:length(Time_Firing);Firing_Rate(1,i)=sum(spk_times<=Time_Firing(i)+Win & spk_times>Time_Firing(i))/Win;end
%% ================================ firing rate single unit ====================================
if max(Labels)>1
for unit_fr=1:max(Labels);spk_times=index(Labels==unit_fr)';       
  for i=1:length(Time_Firing);Firing_Rate(unit_fr+1,i)=sum(spk_times<=Time_Firing(i)+Win & spk_times>Time_Firing(i))/Win;end
end 
end
msgbox('Operation Completed');
end
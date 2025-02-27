function [ISI,ISI_centers,Autoc,Xbin]=isi(index,Labels,fss,binTime,plotISI,...
plotautogram,maxnInte,minInte,bin)

ISI=0;ISI_centers=0;Autoc=0;Xbin=0;Bin=str2double(get(bin,'string'));VbinTime=get(binTime,'value');
Min_Interval=str2double(get(minInte,'string'));Max_Interval=str2double(get(maxnInte,'string'));
if Labels==0;msgbox('Please Enter Parameters Cluster in Section Clustring','','warn');return;end%&&
if index==0;msgbox('Please Set Spike Detection Parameters in Section Spike Detection','','warn');return;end
if isnan(Bin)||(Bin<=0);msgbox('Please Enter Bin > 0','','warn');return;end
if isnan(Min_Interval)||(Min_Interval<0);msgbox('Please Enter Min_Interval >= 0','','warn');return;end
if isnan(Max_Interval)||(Max_Interval<0)||(Max_Interval<=Min_Interval);msgbox('Please Enter Max_Interval; Max_Interval > Min_Interval','','warn');return;end
%% ISI multi unit.......................................................
isi_edges = Min_Interval:Bin:Max_Interval; % bin edges for ISI histogram
ISI_centers = isi_edges(1:end-1)+Bin/2;ISI_centers=ISI_centers*10^3;
index=index/fss;

if VbinTime==2;ISI_centers=ISI_centers*60;index=index/60;elseif VbinTime==3;ISI_centers=ISI_centers*3600;index=index/3600;end
if max(Labels)<1;ISI=zeros(1,length(ISI_centers));else;ISI=zeros(max(Labels)+1,length(ISI_centers));end

isi = diff(index);ISI(1,:)=histcounts(isi,isi_edges); % interspike intervals;
%% ISI single unit...........................................................
if max(Labels)>1
    for unit_isi=1:max(Labels)
       index_=index(Labels==unit_isi);isi1=diff(index_);
       ISI(unit_isi+1,:)=histcounts(isi1,isi_edges);% isi in spike times;
    end
end
%% Autocorrelograms multi unit
spk_t=index; % sec
isi_edges=-Max_Interval-Bin:Bin:Max_Interval+Bin; % first and last bins are to be deleted later
if max(Labels)<1;Autoc=zeros(1,length(isi_edges)-2);else;Autoc=zeros(max(Labels)+1,length(isi_edges)-2);end
ac=zeros(size(isi_edges));
for i=1:length(spk_t)
 relative_spk_t=spk_t-spk_t(i);counter= hist(relative_spk_t,isi_edges);ac=ac+counter;
end
Xbin=isi_edges(2:end-1);ac=ac(2:end-1);ac(round(length(Xbin)/2))=0;Autoc(1,:)=ac; % normalize      % normalize 
 %% Autocorrelograms signal unit ...................................
if max(Labels)>1
    for unit_isi=1:max(Labels)
        spk_t=index(Labels==unit_isi);ac=zeros(size(isi_edges));
        for i=1:length(spk_t)
            relative_spk_t=spk_t-spk_t(i);counter=hist(relative_spk_t,isi_edges);ac=ac+counter;
        end
        ac=ac(2:end-1);ac(round(length(Xbin)/2))=0;Autoc(unit_isi+1,:)=ac; % normalize        
    end
end
Xbin=Xbin*1000;
if VbinTime==2;Xbin=Xbin*60;elseif VbinTime==3;Xbin=Xbin*3600;end
set(plotISI,'value',0);set(plotautogram,'value',0);msgbox('Operation Completed');
end
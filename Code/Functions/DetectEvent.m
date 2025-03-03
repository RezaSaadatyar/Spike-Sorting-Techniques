%% =============================================================================================
% ================================= Spike Extraction Software ==================================
% ================================ Presented by: Reza Saadatyar ================================
% ============================== Email: Reza.Saadatyar@outlook.com =============================
% ======================================= 2019-2020 ============================================

function [index,spikes,timspk]=DetectEvent(xf,Vpre,Vpos,Vpren,Vposn,Valig,Vslid,S)
index=0;
if S.ppeak.Value==1
  [~,xaux]=find(xf(Vpre:end-Vpos)>Vslid);xaux0=0;index=zeros(1,length(xaux));
        for i=1:length(xaux)
            if xaux(i) >= xaux0 + Valig
                [~,iaux]=max((xf(xaux(i):xaux(i)+floor(Valig))));    %introduces alignment
                index(i) = iaux + xaux(i)-1;xaux0 = index(i);
            end
        end
elseif S.npeak.Value==1
    [~,xaux]=find(xf(Vpren:end-Vposn)<-abs(Vslid));xaux0=0;index=zeros(1,length(xaux));
        for i=1:length(xaux)
            if xaux(i) >= xaux0 + Valig
                [~, iaux]=min((xf(xaux(i):xaux(i)+floor(Valig))));    %introduces alignment
                index(i) = iaux + xaux(i) -1;xaux0 = index(i);
            end
        end
elseif S.bpeak.Value==1
    S.ppeak.Value=0;S.npeak.Value=0;S.bpeak.Value=1;S.pre.Enable='on';S.pos.Enable='on';
    S.pren.Enable='on';S.posn.Enable='on';
    [~,xaux1]=find(xf(Vpre:end-Vpos)>abs(Vslid));[~,xaux2]=find(xf(Vpren:end-Vposn)<-abs(Vslid));
    xaux=[xaux1 xaux2];xaux=sort(xaux);xaux0=0;index=zeros(1,length(xaux));
     for i=1:length(xaux)
         if xaux(i) >= xaux0 + Valig
             [~,iaux]=max(abs(xf(xaux(i):xaux(i)+floor(Valig))));    %introduces alignment
             index(i) = iaux + xaux(i)-1;xaux0 = index(i);
         end
     end 
end
%% SPIKE STORING (with or without interpolation)
index(index==0)=[];
if (S.ppeak.Value==1)||(S.bpeak.Value==1)
ls=Vpre+Vpos+1;spikes=zeros(length(index),ls);timspk=spikes;
xf=[xf zeros(1,Vpos)];   
for i=1:length(index);INDS=index(i)-Vpre:index(i)+Vpos;spikes(i,:)=xf(INDS);   
timspk(i,:)=INDS;
end
elseif S.npeak.Value==1
ls=Vpren+Vposn+1;spikes=zeros(length(index),ls);timspk=spikes;
xf=[xf zeros(1,Vpos)];   
for i=1:length(index);INDS=index(i)-Vpren:index(i)+Vposn;spikes(i,:)=xf(INDS);   
timspk(i,:)=INDS;
end
end
%% Normalize Spike
mi=min(min(spikes),[],2);ma=max(max(spikes),[],2);spikes=(spikes-mi)./abs(ma-mi);     
end
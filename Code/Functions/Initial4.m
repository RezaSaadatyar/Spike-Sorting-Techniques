function [xf,spikes,index,Vthrmi,Vthrmn,timspk]=Initial4(Data,DataFilter,inp,inputf,detec,...
pre,pos,thrmi,thrma,alig,xlt,thrmineg,pren,posn,Exec,time3)

xf=0;spikes=0;index=0;timspk=0;

Vpop1=get(inputf,'Value');Vpop2=get(detec,'Value');set(xlt,'value',1);set(time3,'value',1)
Vpre=round(str2double(get(pre,'string')));Vpos=round(str2double(get(pos,'string')));
Vpren=round(str2double(get(pren,'string')));Vposn=round(str2double(get(posn,'string')));
Vthrmi=str2double(get(thrmi,'string'));Vthrma=str2double(get(thrma,'string'));
Vthrmn=str2double(get(thrmineg,'string'));Valig=round(str2double(get(alig,'string')));

if Vpop2==2;set(pre,'enable','on');set(pren,'enable','off');set(pos,'enable','on');set(posn,'enable','off')
set(thrmi,'enable','on');set(thrmineg,'enable','off');
elseif Vpop2==3;set(pre,'enable','off');set(pren,'enable','on');set(pos,'enable','off');set(posn,'enable','on')    
set(thrmi,'enable','off');set(thrmineg,'enable','on');
elseif Vpop2==4;set(pre,'enable','on');set(pren,'enable','on');set(pos,'enable','on');set(posn,'enable','on')
set(thrmi,'enable','on');set(thrmineg,'enable','on');
end 

if get(Exec,'value')==1
if length(Data)<1;msgbox('Please Load Data','Error Load Data','error');return;end
if get(inp,'value')==1;msgbox('Please Select Input:','','warn');return;end
if Vpop1==1;msgbox('Please Select Input Type','','warn');return;elseif Vpop1==2;xf=Data;
else;xf=DataFilter;if length(xf)<1;msgbox('Please Load Data Filter in Block Filtering','','warn');return;end;end
if  Vpop2==1;msgbox('Please Select Detection Type','','warn');return;end
if  isnan(Vpre)||(Vpre<1);msgbox('Please Enter Number Pre_ Event {+} > 1','','warn');return;end
if  isnan(Vpos)||(Vpos<1);msgbox('Please Enter Number Pos_ Event {+} > 1','','warn');return;end
if  isnan(Vpren)||(Vpren<1);msgbox('Please Enter Number Pre_ Event {-} > 0','','warn');return;end
if  isnan(Vposn)||(Vposn<1);msgbox('Please Enter Number Pos_ Event {-} > 0','','warn');return;end
if  isnan(Vthrmi)||(Vthrmi<0);msgbox('Please Enter Thr_min {+} > 0','','warn');return;end
if  isnan(Vthrma)||(Vthrma<=Vthrmi);msgbox('Please Enter Thr_max; Thr_max > Thr_min {+} & Thr_min {-}','','warn');return;end
if isnan(Valig)||(Valig<1);msgbox('Please Enter Number Pre_ Event >1','','warn');return;end
if Vpop2~=2;set(thrmineg,'enable','on')    
if isnan(Vthrmn)||(Vthrmn>=0);msgbox('Please Enter Thr_min {-} < 0','','warn');return;end
else;set(thrmineg,'enable','off')
end

xf(abs(xf)>Vthrma)=[];xf=xf';

if Vpop2==2
    [~,xaux]=find(xf(Vpre:end-Vpos)>Vthrmi);xaux0=0;
    index=zeros(1,length(xaux));
        for i=1:length(xaux)
            if xaux(i) >= xaux0 + Valig
                [~,iaux]=max((xf(xaux(i):xaux(i)+floor(Valig))));    %introduces alignment
                index(i) = iaux + xaux(i)-1;xaux0 = index(i);
            end
        end
elseif Vpop2==3
    [~,xaux]=find(xf(Vpren:end-Vposn)<Vthrmn);xaux0=0;index=zeros(1,length(xaux));
        for i=1:length(xaux)
            if xaux(i) >= xaux0 + Valig
                [~, iaux]=min((xf(xaux(i):xaux(i)+floor(Valig))));    %introduces alignment
                index(i) = iaux + xaux(i) -1;xaux0 = index(i);
            end
        end
elseif Vpop2==4
    [~,xaux1]=find(xf(Vpre:end-Vpos)>Vthrmi);[~,xaux2]=find(xf(Vpren:end-Vposn)<Vthrmn);
    xaux=[xaux1 xaux2];xaux=sort(xaux);xaux0=0;index=zeros(1,length(xaux));
     for i=1:length(xaux)
         if xaux(i) >= xaux0 + Valig
             [~,iaux]=max(abs(xf(xaux(i):xaux(i)+floor(Valig))));    %introduces alignment
             index(i) = iaux + xaux(i)-1;xaux0 = index(i);
         end
     end 
end
%% SPIKE STORING (with or without interpolation)
index(index==0)=[];ls=Vpre+Vpos+1;spikes=zeros(length(index),ls);
timspk=spikes;xf=[xf zeros(1,Vpos)];%sp=zeros(1,size(xf,2));   
for i=1:length(index);INDS=index(i)-Vpre:index(i)+Vpos;spikes(i,:)=xf(INDS);   
timspk(i,:)=INDS;% sp(index(i)-Vpre:index(i)+Vpos)=xf(INDS);
end
%% Normalize Spike
mi=min(min(spikes),[],2);ma=max(max(spikes),[],2);spikes=(spikes-mi)./abs(ma-mi);

% if Vpop2==2;index(index==0)=[];
% %     R=[8491;8492;8493];index(R)=[];
% %     ls=Vpre+Vpos+1;spikes=zeros(length(index),ls);
% % timspk=spikes;xf=[xf zeros(1,Vpos)];   
% % for i=1:length(index);INDS=index(i)-Vpre:index(i)+Vpos;spikes(i,:)=xf(INDS);   
% % % [~,a]=max(xf(INDS),[],2);[~,b]=min(xf(INDS),[],2); 
% % % if a>b;INDS=index(i)-Vpos:index(i)+Vpre;spikes(i,:)=xf(INDS);end;timspk(i,:)=INDS;
% % timspk(i,:)=INDS;sp(index(i)-Vpre:index(i)+Vpos)=xf(INDS);
%  end
% % aux=find(spikes(:,Vpre)==0);spikes(aux,:)=[];index(aux)=[];
% % xf(length(xf)-Vpos)=[];%erases indexes that were artifacts
% % elseif Vpop2==3
% % index(index==0)=[];ls=Vpren+Vposn+1;spikes=zeros(length(index),ls);timspk=spikes;xf=[xf zeros(1,Vposn)];    
% % for i=1:length(index);INDS=index(i)-Vpren:index(i)+Vposn;spikes(i,:)=xf(INDS);
% % % [~,a]=max(xf(INDS),[],2);[~,b]=min(xf(INDS),[],2);
% % % if a<Vposn;[~,a]=max(xf(INDS(1)+Vposn:INDS(end)),[],2);a=a+Vposn;end 
% % % if a>b;INDS=index(i)-Vposn:index(i)+Vpren;spikes(i,:)=xf(INDS);
% % % end
% % timspk(i,:)=INDS;sp(index(i)-Vpren:index(i)+Vposn)=xf(INDS);
% % end
% % % aux=find(spikes(:,Vpren)==0);spikes(aux,:)=[];index(aux)=[];
% % xf=xf(:,1:end-Vposn); %erases indexes that were artifacts
% % else
% index(index==0)=[];ls=max(Vpre,Vpren)+max(Vpos,Vposn)+1;spikes=zeros(length(index),ls);timspk=spikes;
% if Vpren+Vposn==Vpre+Vpos;ls=Vpren+Vposn+1;spikes=zeros(length(index),ls);timspk=spikes;end
% xf=[xf zeros(1,max(Vpos,Vposn))];
% for i=1:length(index)
%     if xf(index(i))>0;INDS=index(i)-Vpre:index(i)+Vpos;
%       aaa=abs(size(INDS,2)-ls);spikes(i,:)=[xf(INDS) zeros(1,aaa)];
% %       [~,a]=max(xf(INDS),[],2);[~,b]=min(xf(INDS),[],2);
% %       if a>b;INDS=index(i)-Vpos:index(i)+Vpre;spikes(i,:)=[xf(INDS) zeros(1,aaa)];end
%        timspk(i,:)=[INDS INDS(end)+1:aaa+INDS(end)];
%        sp(index(i)-Vpre:index(i)+Vpos+aaa)=xf([INDS INDS(end)+1:aaa+INDS(end)]);
%     else
%     INDS=index(i)-Vpren:index(i)+Vposn;aaa=abs(size(INDS,2)-ls);spikes(i,:)=[xf(INDS) zeros(1,aaa)];
% %     [~,a]=max(xf(INDS),[],2);[~,b]=min(xf(INDS),[],2);
% %     if a<Vposn;[~,a]=max(xf(INDS(1)+Vposn:INDS(end)),[],2);a=a+Vposn;end    
% %       if a>b;INDS=index(i)-Vposn:index(i)+Vpren;spikes(i,:)=[xf(INDS) zeros(1,aaa)];end
%       timspk(i,:)=[INDS INDS(end)+1:aaa+INDS(end)];  
%       sp(index(i)-Vpren:index(i)+Vposn+aaa)=xf([INDS INDS(end)+1:aaa+INDS(end)]);
%     end
% end
% % aux = find(spikes(:,Vpre)==0);  %erases indexes that were artifacts
% % spikes(aux,:)=[];index(aux)=[];
% % xf=xf(:,1:end-max(Vpos,Vposn));
% end
% 
% save('Sub1-15min;Spikes,Index,Timesample','spikes','index','sp','timspk')
msgbox('Operation Completed');
end
end

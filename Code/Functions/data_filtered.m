function [DataFilter,fss,Sigma]=data_filtered(Input,fs,fl,fh,rp,rs,order,design,...
response,window,checkFil,Fnotch,notch,display,tabel,time1,time2,time,S)

DataFilter=0;Sigma=0;S.rawS.Value=0;S.filterS.Value=0;S.derivS.Value=0;

disp=get(checkFil,'value');fss=str2double(get(fs,'String'));fll=str2double(get(fl,'String'));
fhh=str2double(get(fh,'String'));rpp=str2double(get(rp,'String'));rss=str2double(get(rs,'String'));
orderr=str2double(get(order,'String'));sCBF=get(design,'String');ValCBF=get(design,'Value');
typeCBF=sCBF(ValCBF);sFT=get(response,'String');ValFT=get(response,'Value');typeFT=sFT(ValFT);

if disp==1;if Input==0;msgbox('Please Select Input Channel Type in Block Load Data','','warn');return;end
if ValCBF==1;msgbox('Please select design method in Block Filtering:','','warn');return;end
end

if get(notch,'value')==1;Fo=str2double(get(Fnotch,'string'));set(fs,'enable','On');
   if isnan(Fo)||(Fo<0);msgbox('Please Enter F0 > 1','','warn');return;end
   if isnan(fss)||(fss<0);msgbox('Please Enter Fs > 1','','warn');return;end
   [num,den]=iirnotch(Fo/(fss/2),Fo/(fss/2));Input=filtfilt(num,den,Input);
%    X=fft2(Input);X=abs(X(1:round(length(Input)/2)));f=linspace(0,fss/2,round(length(Input)/2));
end

if ValCBF==2
set(response,'enable','Off','value',1);set(window,'Enable','on');set(fl,'enable','Off');
set(fh,'enable','Off');set(rp,'enable','Off');set(rs,'enable','Off');set(order,'enable','Off')
set(fs,'enable','Off');if get(notch,'value')==1;set(fs,'enable','On');end;typeFT='';
else
set(response,'enable','On');set(window,'Enable','off');set(fl,'enable','On');set(fh,'enable','On');
set(rp,'enable','On');set(rs,'enable','On');set(order,'enable','On')
set(fs,'enable','On');if disp==1;if ValFT==1;msgbox('Please select Response type:','','warn');return;end;end
end
if strcmp(typeFT,'Lowpass');set(fl,'Enable','on');set(fh,'Enable','off'); 
elseif strcmp(typeFT,'Highpass');set(fl,'Enable','off');set(fh,'Enable','on');
elseif strcmp(typeFT,'Bandpass')||strcmp(typeFT,'Bandstop');set(fl,'Enable','on');set(fh,'Enable','on');
end
if ValCBF==2
winS=str2double(get(window,'String'));
if disp==1;if isnan(winS)||winS<=1||winS>=length(Input);msgbox(['Please Enter Window size; 1 < Value < ', num2str(length(Input))],'','warn');return;end
b=(1/winS)*ones(1,winS);a=1;DataFilter=filtfilt(b,a,Input);end 
elseif ValCBF==3;set(rp,'Enable','off');set(rs,'Enable','off');
elseif strcmp(typeCBF,'Cheby1');set(rp,'Enable','on');set(rs,'Enable','off');
elseif strcmp(typeCBF,'Cheby2');set(rp,'Enable','on');set(rs,'Enable','off');
elseif strcmp(typeCBF,'Ellip');set(rp,'Enable','on');set(rs,'Enable','on');
end
if disp==1;if ValCBF>2;DataFilter=FIR(Input,typeFT,typeCBF,fss,orderr,fll,fhh,rpp,rss);end
if DataFilter~=0
if isnan(fss)||(fss<=0);fss=str2double(inputdlg({'Enter Fs'},'Sampling frequency',[1 44]));end
if isnan(fss);msgbox('Please enter Fs','','warn');return;end
if isempty(fss);msgbox('Please enter Fs','','warn');return;end
L=length(DataFilter);set(tabel,'Data',[L;(L-1)/fss;(L-1)/fss/60;(L-1)/fss/3600])
if length(DataFilter)>10000;set(time1,'string','0');set(time2,'string','10000');else
set(time1,'string','0');set(time2,'string',num2str(length(DataFilter)));
end   
msgbox('Operation Completed');set(display,'value',1);set(time,'value',1)
end
end
end

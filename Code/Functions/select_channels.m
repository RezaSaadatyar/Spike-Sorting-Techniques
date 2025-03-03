function Input=Select_Channels(Inputch,Chi,Chj,input,inp,checkFil)
Input=0;
if get(inp,'value')==1;msgbox('Please Select Input in Block Load Data','','warn');return;end
if Inputch==0;msgbox('Please Select Input in Block Load Data','Error Load Data','error');return;end
if isa(Inputch,'single');Inputch=double(Inputch);end
set(Chj,'Enable','off');set(Chi,'Enable','off');VInput=get(input,'Value');
if VInput==1;msgbox('Please Select Input Channel Type in Block Load Data','','warn');return;end

if size(Inputch,2)>1;Input=Inputch(:,VInput-1);elseif size(Inputch,2)==1;Input=Inputch;end
set(checkFil,'value',0)

% if (VInput==2)&&(size(Inputch,2)>1)
%     set(Chi,'Enable','on');set(Chj,'Enable','on');
%     Vchi=str2double(get(Chi,'string'));Vchj=str2double(get(Chj,'string'));
%     if  isnan(Vchi);msgbox('Please Enter Chi','','warn');return;end
%     if  Vchi<1;msgbox(['0 < Chi < ',num2str(size(Inputch,2)-1)],'','warn');return;end
%     if  isnan(Vchj)||(Vchj<=Vchi);msgbox('Please Enter Chj and  Chj > Chi','','warn');return;end
%     if  Vchj>size(Inputch,2);msgbox([num2str(Vchi),'< Chj <',num2str(size(Inputch,2)+1)],'','warn');return;end
%     Input=Inputch(:,Vchi:Vchj);
% elseif (VInput==2);Input=Inputch;set(Chi,'Enable','off');set(Chj,'Enable','off');
% else;Input=Inputch(:,VInput-2);set(Chi,'Enable','off');set(Chj,'Enable','off');
% end
end
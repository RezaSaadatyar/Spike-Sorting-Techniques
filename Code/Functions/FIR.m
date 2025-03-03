function DataFilter= FIR(Input,typeFT,typeCBF,fs,order,fl,fh,rp,rs)
DataFilter=0;

if isnan(fs)||(fs<1);msgbox('Please Enter Fs and Fs > 0','','warn');return;end
if isnan(order)||(order<1);msgbox('Please Enter Order and Order >0','','warn');return;end
if strcmp(typeFT,'Lowpass')
   if fl/fs/2>=1;msgbox('Invalid Value Fpass; (Fs/Fpass /2) must be within the interval of (0,1)','','warn');return;end
   if isnan(fl)||(fl<2);msgbox('Please Enter Fpass and Fpass >1','','warn');return;end
elseif strcmp(typeFT,'Highpass')
    if fh/fs/2>=1;msgbox('Invalid Value Fstop; (Fs/Fstop /2) must be within the interval of (0,1)','','warn');return;end
    if isnan(fh)||(fh<2);msgbox('Please Enter Fstop and Fstop > 1','','warn');return;end
elseif strcmp(typeFT,'Bandpass')||strcmp(typeFT,'Bandstop')
    if fl/fs/2>=1;msgbox('Invalid Value Fpass; (Fs/pass /2) must be within the interval of (0,1)','','warn');return;end
    if fh/fs/2>=1;msgbox('Invalid Value Fstop; (Fs/Fstop /2) must be within the interval of (0,1)','','warn');return;end
    if isnan(fl)|| (fl<2);msgbox('Please Enter Fpass and Fpass >1','','warn');return;end
    if isnan(fh)||(fh<2);msgbox('Please Enter Fstop and Fstop > 1','','warn');return;end
    if fh<=fl;msgbox('Fstop must be greater than Fpass (Fstop > Fpass)','','warn');return;end
end
if strcmp(typeCBF,'Cheby1')||strcmp(typeCBF,'Cheby2')
    if isnan(rp)||(rp<2);msgbox('Please Enter Rp and Rp > 1','','warn');return;end
elseif strcmp(typeCBF,'Ellip')
   if isnan(rp)||(rp<1);msgbox('Please Enter Rp and Rp > 0','','warn');return;end
   if isnan(rs)||(rs<1);msgbox('Please Enter Rp and Rs > 0','','warn');return;end
   if rs<=rp;msgbox('Rs must be greater than Rp (Rs > Rp)','','warn');return;end    
end

if strcmp(typeFT,'Lowpass') && strcmp(typeCBF,'Butter')
    [b,a] = butter(order,fl/fs/2,'low');DataFilter=filtfilt(b,a,Input);
elseif strcmp(typeFT,'Highpass') && strcmp(typeCBF,'Butter')
    [b,a] = butter(order,fh/fs/2,'high');DataFilter=filtfilt(b,a,Input);
elseif strcmp(typeFT,'Bandpass') && strcmp(typeCBF,'Butter')
    [b,a] = butter(order,[fl/fs/2 fh/fs/2],'bandpass');DataFilter=filtfilt(b,a,Input);
elseif strcmp(typeFT,'Bandstop') && strcmp(typeCBF,'Butter')
    [b,a] = butter(order,[fl/fs/2 fh/fs/2],'stop');DataFilter=filtfilt(b,a,Input);
elseif strcmp(typeFT,'Lowpass') && strcmp(typeCBF,'Cheby1')
    [b,a] = cheby1(order,rp,fl/fs/2,'low');DataFilter=filtfilt(b,a,Input);
elseif strcmp(typeFT,'Highpass') && strcmp(typeCBF,'Cheby1')
    [b,a] = cheby1(order,rp,fh/fs/2,'high');DataFilter=filtfilt(b,a,Input);
elseif strcmp(typeFT,'Bandpass') && strcmp(typeCBF,'Cheby1')
    [b,a] = cheby1(order,rp,[fl/fs/2 fh/fs/2],'bandpass'); DataFilter=filtfilt(b,a,Input);
elseif strcmp(typeFT,'Bandstop')&& strcmp(typeCBF,'Cheby1')
    [b,a] = cheby1(order,rp,[fl/fs/2 fh/fs/2],'stop');DataFilter=filtfilt(b,a,Input);
elseif  strcmp(typeFT,'Lowpass') && strcmp(typeCBF,'Cheby2')
    [b,a] = cheby2(order,rp,fl/fs/2,'low');DataFilter=filtfilt(b,a,Input);
elseif strcmp(typeFT,'Highpass') && strcmp(typeCBF,'Cheby2')
    [b,a] = cheby2(order,rp,fh/fs/2,'high');DataFilter=filtfilt(b,a,Input);
elseif strcmp(typeFT,'Bandpass') && strcmp(typeCBF,'Cheby2')
    [b,a] = cheby2(order,rp,[fl/fs/2 fh/fs/2],'bandpass');DataFilter=filtfilt(b,a,Input);
elseif strcmp(typeFT,'Bandstop') && strcmp(typeCBF,'Cheby2')
    [b,a] = cheby2(order,rp,[fl/fs/2 fh/fs/2],'stop');DataFilter=filtfilt(b,a,Input);
elseif strcmp(typeFT,'Lowpass') && strcmp(typeCBF,'Ellip')
    [b,a] = ellip(order,rp,rs,fl/fs/2,'low');DataFilter=filtfilt(b,a,Input);
elseif strcmp(typeFT,'Highpass') && strcmp(typeCBF,'Ellip')
    [b,a] = ellip(order,rp,rs,fh/fs/2,'high');DataFilter=filtfilt(b,a,Input);
elseif strcmp(typeFT,'Bandpass') && strcmp(typeCBF,'Ellip')
    [b,a] = ellip(order,rp,rs,[fl/fs/2 fh/fs/2],'bandpass');DataFilter=filtfilt(b,a,Input);
elseif strcmp(typeFT,'Bandstop') && strcmp(typeCBF,'Ellip')
    [b,a] = ellip(order,rp,rs,[fl/fs/2 fh/fs/2],'stop');DataFilter=filtfilt(b,a,Input);
end
end
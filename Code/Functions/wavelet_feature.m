function waveSpik = wavelet_feature(spikes,Tikwavelet,wave,leve,dispca,diswave)   

set(dispca,'value',0);set(diswave,'value',0);waveSpik=0;

if get(Tikwavelet,'value')==1

if spikes==0;msgbox('Please Load Spikes(i.e., Eneter Parameters Spike Detection)','','warn');return;end
     
Swave=get(wave,'string');nwave=Swave(get(wave,'value'));scales=get(leve,'value');   
waveSpik=zeros(size(spikes,1),size(spikes,2));   
    
for i=1:size(spikes,1);a=wavedec(spikes(i,:),scales,char(nwave));waveSpik(i,:)=a(1:size(spikes,2));end

msgbox('Operation Completed')
end
end




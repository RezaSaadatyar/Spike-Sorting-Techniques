function [Inputch,DataFilter,Input,fss,Sigma,xf,index,spikes,timspk,Diff1,PcaSpik,...
pcafea,waveletSpik,wavfea,InputClust,Labels,Raster,MeanSpike,MeanPhaseSpaces,Firing_Rate,...
Time_Firing,ISI,ISI_centers,Autoc,Xbin]=clear_parameters(S)

Inputch=0;DataFilter=0;Input=0;fss=0;Sigma=0;xf=0;index=0;spikes=0;timspk=0;Diff1=0;
PcaSpik=0;pcafea=0;waveletSpik=0;wavfea=0;InputClust=0;Labels=0;Raster=0;MeanSpike=0;
MeanPhaseSpaces=0;Firing_Rate=0;Time_Firing=0;ISI=0;ISI_centers=0;Autoc=0;Xbin=0;clear global;

S.radio.Value=0;S.inp.Value=1;S.radio1.Value=0;S.input.Value=1;S.notch.Value=0;
S.Fnotch.String='50';S.design.Value=1;S.response.Value=1;S.response.Visible='on';
S.Parameters.Visible='on';S.fs.String='';S.order.String='3';S.fl.String='';
S.fh.String='';S.rp.String='2';S.rs.String='3';S.window.String='3';S.checkFil.Value=0;
S.tabel.Data=[];S.display.Value=1;S.time.Value=1;S.time1.String='';S.time2.String='';
cla(S.ax(1));cla(S.ax(2));

S.rawS.Value=0;S.filterS.Value=0;S.derivS.Value=0;S.ppeak.Value=1;S.npeak.Value=0;
S.bpeak.Value=0;S.plotmanual.Value=0;S.plotauto.Value=0;S.thrmi.String='';
S.thrmineg.String='';S.thrma.String='';S.pre.String='20';S.pos.String='40';
S.pren.String='20';S.posn.String='20';S.alig.String='50';S.Exec.Value=0;S.time3.Value=1;
S.time4.Value=1;S.time5.String='0';S.time6.String='100000';S.waw.String='1000';
S.dspikeven.Value=0;S.dphaspace.Value=0;S.slid1.Value=0;S.slid1.Enable='on';S.slid2.Value=0;
S.tabe2.Data=[];cla(S.ax(3));cla(S.ax(4));cla(S.ax(5));cla(S.ax(6));cla(S.ax(7));      
             
S.Tikpca.Value=0;S.Feat1.String='1';S.Feat2.String='2';S.Feat3.String='3';S.dispca.Value=0;
S.Tikwavelet.Value=0;S.wave.Value=1;S.leve.Value=1;S.Feat31.String='1';S.Feat32.String='2';
S.Feat33.String='3';S.diswave.Value=0;cla(S.ax(8));cla(S.ax(9));cla(S.ax(10));cla(S.ax(11));

S.inpclust.Value=1;S.plotc.Value=0;S.manual.Value=0;S.auto.Value=0;S.cursor.Value=0;
S.clus.Value=1;S.numcl.Value=1;S.plotR.Value=1;S.plotSU.Value=0;S.plotPhU.Value=0;
S.slid3.Value=0;S.sample.Value=0;S.second.Value=0;S.minute.Value=0;S.hour.Value=0;
S.time7.String='';S.time8.String='';S.Xlim.String='1000';S.tabe3.Data=[];cla(S.ax(12));
cla(S.ax(13));cla(S.ax(14));cla(S.ax(15));

S.binTime.Value=1;S.binFR.String='';S.spikepersec.Value=0;S.countperbin.Value=0;
S.minInte.String='0';S.maxnInte.String='';S.bin.String='0.0005';S.plotISI.Value=0;
S.plotautogram.Value=0;cla(S.ax(13));cla(S.ax(14));cla(S.ax(15));cla(S.ax(16));
cla(S.ax(17));cla(S.ax(18));cla(S.ax(19));subplot(1,1,1,'replace','Parent',S.ax(20));
cla(S.ax(21));subplot(1,1,1,'replace','Parent',S.ax(22));cla(S.ax(23));
subplot(1,1,1,'replace','Parent',S.ax(24));
                   
end
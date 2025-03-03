function PcaSpik = pca_feature(spikes,Tikpca,dispca,diswave)  

PcaSpik=0;

set(dispca,'value',0);set(diswave,'value',0);

if get(Tikpca,'value')==1
if spikes==0;msgbox('Please Load Spikes(i.e., Eneter Parameters Spike Detection)','','warn');return;end
Xm=repmat(mean(spikes),size(spikes,1),1);
spik=spikes-Xm;Cov=cov(spik);
[V,D]=eig(Cov);eigenval=diag(D);[~,ind]=sort(eigenval,'descend');
A=V(:,ind);PcaSpik=spikes*A;
msgbox('Operation Completed')
end

end




%% =============================================================================================
% ================================= Spike Extraction Software ==================================
% ================================ Presented by: Reza Saadatyar ================================
% ============================== Email: Reza.Saadatyar@outlook.com =============================
% ======================================= 2019-2020 ============================================

function Labels=clustering(InputClust,clus,numcl,inpclust,ax13,S,cm)

Labels=0;ax13.NextPlot='replaceall';%cla(ax13);axes(ax13)
S.plotR.Value=1;S.plotSU.Value=0;S.plotPhU.Value=0;S.binTime.Value=1;S.binFR.String='';
S.minInte.String='0';S.maxnInte.String='';S.bin.String='0.0005';S.sample.Value=0;
S.second.Value=0;S.minute.Value=0;S.hour.Value=0;

if InputClust==0;msgbox('Please Select Input Type in Section Clustering','','warn');return;end
if (S.auto.Value==0)&&(S.manual.Value==0);msgbox('Please Select Manual OR Automatic','','warn');return;end
if get(numcl,'value')==1;msgbox('Please Select Number Cluster','','warn');return;end

VClus=get(clus,'value');SNumClus=get(numcl,'string');NumClus=str2double(SNumClus(get(numcl,'value')));
if get(inpclust,'value')==2;til='PCA';
if size(InputClust,2)==2;Feat1=['Feature ' S.Feat1.String];Feat2=['Feature ' S.Feat2.String];
else;Feat1=['Feature ' S.Feat1.String];Feat2=['Feature ' S.Feat2.String];Feat3=['Feature ' S.Feat3.String];
end
elseif get(inpclust,'value')==3;til='Wavelet';
if size(InputClust,2)==2;Feat1=['Feature ' S.Feat31.String];Feat2=['Feature ' S.Feat32.String];
else;Feat1=['Feature ' S.Feat31.String];Feat2=['Feature ' S.Feat32.String];Feat3=['Feature ' S.Feat33.String];
end
end

if NumClus~=1
%% ================================= Automatic Center ==========================================
if (VClus==1)||(VClus==2)||(VClus==4);set(numcl,'enable','on');
if S.auto.Value==1;ind=randperm(size(InputClust,1));Center(:,1)=InputClust(ind(1:1),:)';
for i= 2:NumClus;D=zeros(i-1,size(InputClust,1));
for j=1:size(Center,2)
cj=Center(:,j);reptCj=repmat(cj,1,size(InputClust,1));D(j,:)=sqrt(sum((reptCj-InputClust').^2,1));
end
if i~=2;D=prod(D);end;[~,ind]=max(D);Center(:,i)=InputClust(ind,:)';
end
%% ======================================== Manual Center ======================================
elseif S.manual.Value==1
Center=zeros(size(InputClust,2),NumClus);
if size(InputClust,2)==2    
for i=1:NumClus;y=str2double(inputdlg({'Enter X','Enter Y'},['Class ',num2str(i)],[1 40; 1 40]));
if isnan(sum(y(:)))||isempty(y);msgbox('Please enter X and Y as scalars','','warn');return;end;Center(:,i)=y;end
elseif size(InputClust,2)==3   
for i=1:NumClus;y=str2double(inputdlg({'Enter X','Enter Y','Enter Z'},['Class ',num2str(i)],[1 40; 1 40; 1 40]));
if isnan(sum(y(:)))||isempty(y);msgbox('Please enter X, Y and Z as scalars','','warn');return;end;Center(:,i)=y;end       
end
end
elseif VClus==3;set(numcl,'enable','off');[Labels,Center]=Gmeans_Cluster(InputClust',0.01);
end
%% ================================ FCM & K-means training =====================================
if VClus==1;[Center,Mu]=fcm_cluster(InputClust',NumClus,Center,10,2);[~,Labels]=max(Mu);
elseif VClus==2;[Labels,Center]=kmeans_cluster(InputClust',NumClus,Center,10);end

L=unique(Labels);NClass=length(L);Tlegend=cell(NClass+1,1);Tlegend{end}='centers';
Col=hsv(NClass);InputClust=InputClust';Center=Center';
%% ====================================== Plot =================================================
if size(InputClust,1)==2 
for i=L
plot(ax13,InputClust(1,Labels==i),InputClust(2,Labels==i),'.','color',Col(i,:));
ax13.NextPlot='add';Tlegend{i}=['class ' num2str(i)];
end    
plot(ax13,Center(:,1),Center(:,2),'kx','linewidth',5,'markersize',8);legend(ax13,Tlegend);
title(til);xlabel(ax13,Feat1);ylabel(ax13,Feat2);ax13.XMinorGrid='on';ax13.YMinorGrid='on';
dcm=datacursormode;dcm.Enable='off';ax13.FontWeight='bold';ax13.FontName='Times New Roman';
ax13.FontSize=10; 
elseif size(InputClust,1)==3
for i=L
plot3(ax13,InputClust(1,Labels==i),InputClust(2,Labels==i),InputClust(3,Labels==i),'.','color',Col(i,:));
ax13.NextPlot='add';Tlegend{i}=['class ' num2str(i)];    
end     
plot3(ax13,Center(:,1),Center(:,2),Center(:,3),'kx','linewidth',5,'markersize',8);legend(ax13,Tlegend);
xlabel(ax13,Feat1);ylabel(ax13,Feat2);zlabel(ax13,Feat3);title(ax13,til);ax13.FontWeight='bold';
ax13.FontName='Times New Roman';ax13.FontSize=10;ax13.XMinorGrid='on';ax13.YMinorGrid='on';dcm=datacursormode;dcm.Enable='off';
end
set(ax13,'uicontextmenu',cm); 
else
Labels=ones(size(InputClust,1),1);       
end
msgbox('Operation Completed');
% DAL(i,NumClus+1)=CN;                 % K+1 is Cluster Label   
% if get(clus,'value')==2;[z,~,~]=mixGaussEm(InputClust',DAL(:,NumClus+1)');DAL(:,NumClus+1)=z';end
% save('Sub1-15min;Labels','INDPCA')
end
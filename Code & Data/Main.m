%##########################################################################
%                            Spike Sorting                                #
%                      Presented by: Reza Saadatyar                       #
%                              Fs = 30000 Hz                              #
%##########################################################################
% Please Run Code Main.m, the Software will run automatically and there is no need to run test code
clc;clear;close all
%% LOAD DATA
data=load('data.mat');
d=data.a.a;
%% filter data using Bandstop butter for spike detection
detect_fmin = 300;               % high pass filter(Hz) for spike detection 
detect_fmax =3000;               % low pass filter for detection 
sort_fmin = 300;                 % high pass filter for sorting 
sort_fmax = 3000;                % low pass filter for sorting  
sr = 30000; 
tim=(1:length(d))/sr;
[b_detect,a_detect] = butter(4,[300  3000]*2/sr);
d_f=filtfilt(b_detect,a_detect,d);
figure(1);
subplot(211)
plot(tim,d)
ylabel('mV','FontSize',12,'FontWeight','bold')
legend({'Raw Signal'},'FontSize',9,'FontWeight','bold')
grid on;grid minor;
subplot(212)
plot(tim,d_f,'r');
xlabel('Time(sec)','FontSize',12,'FontWeight','bold')
ylabel('mV','FontSize',12,'FontWeight','bold')
legend({'filtered Signal'},'FontSize',9,'FontWeight','bold')
grid on;grid minor;
%% THRESHULD
stdmin =5;                       % minimum threshold for estimated noise 
stdmax = 12;                     % maximum threshold for avoid high amplitude artifact 
noise_std_detect = median(abs(d))/0.6745;
noise_std_sorted = median(abs(d))/0.6745;
thr = stdmin * noise_std_detect;        %thr for detection is based on detect settings.
thrmax = stdmax * noise_std_sorted;     %thrmax for artifact removal is based on sorted settings.
%%  LOCATE SPIKE TIMES
w_pre = 20;                               % w_pre datapoints before the spike peak are stored
w_post =40;                               % w_post datapoints after the spike peak are stored 
alignment_window = 5;                     % number of points around the sample expected to be the maximum 
awin =alignment_window; 
ref_ms = 1.5;                             % detector dead time, minimum refractory period (in ms) 
ref = ceil(ref_ms/1000 * sr);             %Round toward positive infinity
par.detection = 'pos';                    % type of threshold 
%par.detection = 'neg'; 
%par.detection = 'both';
detect=par.detection;
switch detect
    case 'pos'
        nspk = 0;
        xaux = find(d_f(w_pre+awin+2:end-w_post-awin-2) > thr) + w_pre+1;
        xaux0 = 0;
         colorrr=hsv(length(xaux));
        for i=1:length(xaux)
            if xaux(i) >= xaux0 + ref
                [maxi, iaux]=max((d(xaux(i):xaux(i)+floor(ref/2)-1)));    %introduces alignment
                nspk = nspk + 1;
                index(nspk) = iaux + xaux(i) - 1; % we selec the max value among the values over the threshold
                                                     % minimum value for index is "w_pre+2"
               xaux0 = index(nspk);
               figure(2);
               hold on
               plot(1:floor(ref/2),d_f(xaux(i):xaux(i)+floor(ref/2)-1),'color',colorrr(i,:))
               title('detection positive')
               grid on;
               grid minor;

            end
        end
    case 'neg'
        nspk = 0;
        xaux = find(d_f_detect(w_pre+awin+2:end-w_post-awin-2) < -thr) + w_pre+1;
        xaux0 = 0;
        colorrr=hsv(length(xaux));
        for i=1:length(xaux)
            if xaux(i) >= xaux0 + ref
                [maxi, iaux]=min((d_f(xaux(i):xaux(i)+floor(ref/2)-1)));    %introduces alignment
                nspk = nspk + 1;
                index(nspk) = iaux + xaux(i) -1;
                xaux0 = index(nspk);
                figure(3);
                subplot(1,1,1)
                hold on
                plot(1:floor(ref/2),d_f(xaux(i):xaux(i)+floor(ref/2)-1),'color',colorrr(i,:))
                title('detection negative')
                grid on;
                grid minor;
%            
            end
        end
        case 'both'
        nspk = 0;
        xaux = find(abs(d_f_detect(w_pre+awin+2:end-w_post-awin-2)) > thr) + w_pre+1;
        xaux0 = 0;
        colorrr=hsv(length(xaux));
        for i=1:length(xaux)
            if xaux(i) >= xaux0 + ref
                [maxi, iaux]=max(abs(d_f(xaux(i):xaux(i)+floor(ref/2)-1)));    %introduces alignment
                 nspk = nspk + 1;
                 index(nspk) = iaux + xaux(i) -1;
                 xaux0 = index(nspk);
                 figure(4);
                 hold on
                 plot(1:floor(ref/2),ads_f(xaux(i):xaux(i)+floor(ref/2)-1),'color',colorrr(i,:))
                 title('detection positive and negative')
                 grid on;
                 grid minor;
            end
        end
end
%%  SPIKE STORING 
ls = w_pre+w_post;
spikes = zeros(nspk,ls+4);   %add 4 more points, a matrix with the spike shapes
d_f = [d_f zeros(1,w_post)];
colorrr=hsv(nspk);
for i=1:nspk                          %Eliminates artifacts
    if max(abs( d_f(index(i)-w_pre:index(i)+w_post) )) < thrmax
       spikes(i,:)=d_f(index(i)-w_pre-1:index(i)+w_post+2);
    end 
       figure(5);
       hold on
       plot(spikes(i,:),'color',colorrr(i,:))
       title('Spike waveform detection')
       grid on;grid minor;
end
aux = find(spikes(:,w_pre)==0);       %erases indexes that were artifacts
spikes(aux,:)=[];
index(aux)=[]; 
%%  FEATURES PARAMETERS 
% [C,L] = wavedec(X,N,'wname') returns the wavelet decomposition of the signal X at level N, using 'wname'.
%N must be a strictly positive integer. The output decomposition structure contains the wavelet decomposition
%vector C and the bookkeeping vector L
inputs = 10;    % number of inputs to the clustering 
nlevel = 4;                                % number of level for the wavelet decomposition 
par.features = 'wav';                 % type of feature ('wav' or 'pca') 
feature = par.features;
%Calculates the spike features
nspk = size(spikes,1);
ls = size(spikes,2);
switch feature
    case 'wav'
    wname='haar';
        cc=zeros(nspk,ls);
        colorrr=hsv(nspk);                            
            for i=1:nspk                                % Wavelet decomposition
                [c,l]=wavedec(spikes(i,:),nlevel,wname);
                cc(i,1:ls)=c(1:ls);
%                 figure(7);
%                 hold on
%                 plot(cc(i,1:ls),'color',colorrr(i,:))
%                 legend('Wavelet coefficients')
%                 grid on;
%                 grid minor;
            end
end
 for i=1:ls                                  % KS test for coefficient selection   
            thr_dist = std(cc(:,i)) * 3;
            thr_dist_min = mean(cc(:,i)) - thr_dist;
            thr_dist_max = mean(cc(:,i)) + thr_dist;
            aux = cc(find(cc(:,i)>thr_dist_min & cc(:,i)<thr_dist_max),i);
            if length(aux) > 10
                [ksstat]=test_ks(aux);
                sd(i)=ksstat;
            else
                sd(i)=0;
            end
 end
        [max_sd ind]=sort(sd);
        coeff(1:inputs)=ind(ls:-1:ls-inputs+1);
inspk=zeros(nspk,inputs); %a matrix with the features of the spike shapes
%% clustring
inspk=zeros(nspk,inputs);
coeff(1:inputs)=ind(ls:-1:ls-inputs+1);
for i=1:nspk
    for j=1:inputs
        inspk(i,j)=cc(i,coeff(j));
    end
end
nCluster=3;
[l, C]=kmeans(inspk,nCluster);
figure();
plot3(inspk(l==1,1),inspk(l==1,2),inspk(l==1,3),'ro')
hold on
plot3(inspk(l==2,1),inspk(l==2,2),inspk(l==2,3),'gs')
plot3(inspk(l==3,1),inspk(l==3,2),inspk(l==3,3),'b*') 
plot3(C( : ,1),C( :,2),C( :,3),'ks','LineWidth',8,'MarkerSize',5)
title('Feature Extraction: wavelet coef?cients','FontSize',12,'FontWeight','bold')
legend({'Cluster1','Cluster2','Cluster3',' X center'},'FontSize',9,'FontWeight','bold');
grid on;grid minor;

figure();
for i=1:size(spikes,1)
    hold on;
    if l(i)==1
        subplot(311);plot(spikes(i,:),'r')
        grid on;grid minor;
        legend({'Cluster1'},'FontSize',9,'FontWeight','bold');
        title('Sorted Spikes','FontSize',12,'FontWeight','bold')
    elseif l(i)==2
        subplot(312);plot(spikes(i,:),'g')
        grid on;grid minor;
        legend({'Cluster2'},'FontSize',9,'FontWeight','bold');
    elseif l(i)==3
        subplot(313);plot(spikes(i,:),'k')
        grid on;grid minor;
        legend({'Cluster3'},'FontSize',9,'FontWeight','bold');
    end
end
xlabel('Sample','FontSize',12,'FontWeight','bold')
 




# Spike-Sorting
This repository includes useful MATLAB codes for ENG analysis.

There are three main stages in the algorithm: (1) spike detection, (2) spike feature selection (Wavelet), and (3) clustering of the selected spike features (K-means).

In the ﬁrst step, spikes are detected with an automatic amplitude threshold on the band-pass ﬁltered data. In the second step, a small set of wavelet coefﬁcients from each spike is chosen as input for the clustering algorithm. Finally, the K-means classiﬁes the spikes according to the selected set of wavelet coefﬁcients.

Fs = 30000 Hz;              % Sampling frequency  
F_low = 300 Hz;             % low pass filter for detection  
F_high =3000 Hz;            % high pass filter for spike detection  

Threshold
* T_min = 5;                 % minimum threshold for estimated noise 
* T_max = 12;                % maximum threshold for avoid high amplitude artifact 

Detect spike times
w_pre = 20;                 % w_pre datapoints before the spike peak are stored
w_post =40;                 % w_post datapoints after the spike peak are stored 

Reza.Saadatyar@outlook.com

![Fig 1](https://user-images.githubusercontent.com/96347878/161287895-da71b39e-3021-4504-aa00-fc82563f743e.png)

![Fig 2](https://user-images.githubusercontent.com/96347878/161290847-c900dbc1-ef80-4b56-95e4-28ed376e0124.png)

![Fig 3](https://user-images.githubusercontent.com/96347878/161295295-a9241f44-24dd-46e0-be94-ddd8bf5c7191.png)

![Fig 4](https://user-images.githubusercontent.com/96347878/161295539-74ee8a41-c554-446a-bc28-bdcb3bbf297f.png)

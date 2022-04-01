# Spike-Sorting
This repository includes useful MATLAB codes for ENG analysis.
There are three main stages in the algorithm: (1) spike detection, (2) spike feature selection (Wavelet), and (3) clustering of the selected spike features (K-means).
In the ﬁrst step, spikes are detected with an automatic amplitude threshold on the band-pass ﬁltered data. In the second step, a small set of wavelet coefﬁcients from each spike is chosen as input for the clustering algorithm. Finally, the K-means classiﬁes the spikes according to the selected set of wavelet coefﬁcients.

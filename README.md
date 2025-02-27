# Neurophysiological Signal Processing and Analysis

This repository contains tools and scripts for processing and analyzing neurophysiological signals, focusing on spike detection, feature extraction, clustering, and firing rate analysis. Below is an overview of the steps involved in the pipeline and the functionalities provided by the software.

## Steps in the Pipeline

1. **Data Import and Preprocessing**
   - Import data from various formats (e.g., `.mat`, `.txt`, `.xlsx`).
   - Perform artifact removal and filtering using methods like Moving Average, Butterworth, Chebyshev, and Elliptic filters.
   - Apply band-pass filtering to the waveform.
   - Fs = 30000 Hz;                 % Sampling frequency  
   - F_low = 300 Hz;                % low pass filter for detection  
   - F_high =3000 Hz;               % high pass filter for spike detection  

2. **Spike Detection**
   - Use amplitude threshold discrimination to detect spikes.
   - Record spike times and align events.

3. **Feature Extraction**
   - Extract feature coefficients using Principal Component Analysis (PCA) and Wavelet Transform.
   - Select relevant feature coefficients for further analysis.

4. **Spike Clustering**
   - Cluster spikes using unsupervised algorithms such as Fuzzy C-Means (FCM), and K-Means.

5. **Firing Rate and ISI Analysis**
   - Analyze the distribution of firing rates.
   - Compute Interspike Interval (ISI) histograms and autocorrelograms for each class.

6. **Visualization and Results**
   - Generate and display firing rate figures, ISI histograms, and autocorrelograms.
   - Save results for further analysis.

## Contributing

Contributions are welcome! Please fork the repository and submit a pull request with your changes.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contact

For any questions or support, please contact Reza.Saadatyar@outlook.com.



![Image](https://github.com/user-attachments/assets/61ec7e53-b27d-4046-ba9f-98082996d339)
